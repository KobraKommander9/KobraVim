local M = {}

M._installed = nil
M._queries = {}

function M.build(cb)
	M.ensure_ts_cli(function(ok, err)
		if ok then
			return cb()
		end

		KobraVim.error(err, { title = "KobraVim Treesitter" })
	end)
end

function M.ensure_ts_cli(cb)
	if vim.fn.executable("tree-sitter") == 1 then
		return cb(true)
	end

	if not pcall(require, "mason") then
		return cb(false, "`mason.nvim` is disabled in your config, so we cannot install it automatically.")
	end

	if vim.fn.executable("tree-sitter") == 1 then
		return cb(true)
	end

	local mr = require("mason-registry")
	mr.refresh(function()
		local p = mr.get_package("tree-sitter-cli")
		if not p:is_installed() then
			KobraVim.info("Installing `tree-sitter-cli` with `mason.nvim`...")
			p:install(
				nil,
				vim.schedule_wrap(function(success)
					if success then
						KobraVim.info("Installed `tree-sitter-cli` with `mason.nvim`.")
						cb(true)
					else
						cb(false, "Failed to install `tree-sitter-cli` with `mason.nvim`.")
					end
				end)
			)
		end
	end)
end

function M.foldexpr()
	return M.have(nil, "folds") and vim.treesitter.foldexpr() or "0"
end

function M.get_installed(update)
	if update then
		M._installed, M._queries = {}, {}
		for _, lang in ipairs(require("nvim-treesitter").get_installed("parsers")) do
			M._installed[lang] = true
		end
	end

	return M._installed or {}
end

function M.have(what, query)
	what = what or vim.api.nvim_get_current_buf()
	what = type(what) == "number" and vim.bo[what].filetype or what

	local lang = vim.treesitter.language.get_lang(what)
	if lang == nil or M.get_installed()[lang] == nil then
		return false
	end

	if query and not M.have_query(lang, query) then
		return false
	end

	return true
end

function M.have_query(lang, query)
	local key = lang .. ":" .. query
	if M._queries[key] == nil then
		M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
	end

	return M._queries[key]
end

function M.indentexpr()
	return M.have(nil, "indents") and require("nvim-treesitter").indentexpr() or -1
end

return M
