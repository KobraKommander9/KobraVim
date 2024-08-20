local M = {}

M._keys = nil

function M.get()
	if M._keys then
		return M._keys
	end

	M._keys = {
		{ "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
		{ "gr", vim.lsp.buf.references, desc = "References", nowait = true },
		{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
		{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
		{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
		{ "K", vim.lsp.buf.hover, desc = "Hover" },
		{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
		{ "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },

		{ "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
		{ "<leader>lA", KobraVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
		{ "<leader>lc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
		{
			"<leader>lC",
			vim.lsp.codelens.refresh,
			desc = "Refresh & Display Codelens",
			mode = { "n" },
			has = "codeLens",
		},
		{ "<leader>ll", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
		{ "<leader>lR", vim.lsp.buf.rename, desc = "Rename", has = "rename" },

		{
			"]]",
			function()
				KobraVim.lsp.words.jump(vim.v.count1)
			end,
			has = "documentHighlight",
			desc = "Next Reference",
			cond = function()
				return KobraVim.lsp.words.enabled
			end,
		},
		{
			"[[",
			function()
				KobraVim.lsp.words.jump(-vim.v.count1)
			end,
			has = "documentHighlight",
			desc = "Prev Reference",
			cond = function()
				return KobraVim.lsp.words.enabled
			end,
		},

		{
			"<a-n>",
			function()
				KobraVim.lsp.words.jump(vim.v.count1, true)
			end,
			has = "documentHighlight",
			desc = "Next Reference",
			cond = function()
				return KobraVim.lsp.words.enabled
			end,
		},
		{
			"<a-p>",
			function()
				KobraVim.lsp.words.jump(-vim.v.count1, true)
			end,
			has = "documentHighlight",
			desc = "Prev Reference",
			cond = function()
				return KobraVim.lsp.words.enabled
			end,
		},
	}

	return M._keys
end

function M.has(buffer, method)
	if type(method) == "table" then
		for _, m in ipairs(method) do
			if M.has(buffer, m) then
				return true
			end
		end
		return false
	end

	method = method:find("/") and method or "textDocument/" .. method
	local clients = KobraVim.lsp.get_clients({ bufnr = buffer })

	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end

	return false
end

function M.resolve(buffer)
	local Keys = require("lazy.core.handler.keys")
	if not Keys.resolve then
		return {}
	end

	local spec = M.get()
	local opts = KobraVim.opts("nvim-lspconfig")
	local clients = KobraVim.lsp.get_clients({ bufnr = buffer })

	for _, client in ipairs(clients) do
		local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
		vim.list_extend(spec, maps)
	end

	return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
	local Keys = require("lazy.core.handler.keys")
	local keymaps = M.resolve(buffer)

	for _, keys in pairs(keymaps) do
		local has = not keys.has or M.has(buffer, keys.has)
		local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

		if has and cond then
			local opts = Keys.opts(keys)
			opts.cond = nil
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
		end
	end
end

return M
