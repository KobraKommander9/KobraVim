local M = {}

local Util = require("lazy.core.util")

M.root_patterns = { ".git", "lua" }

function M.keymap(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys

	-- do not create keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	local ok, clue = pcall(require, "mini.clue")
	if ok then
		clue.ensure_buf_triggers()
	end
end

function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

function M.has(plugin)
	return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

-- delay notifications until vim.notify is available or after 500ms
function M.lazy_notify()
	local notifs = {}
	local function temp(...)
		table.insert(notifs, vim.F.pack_len(...))
	end

	local orig = vim.notify
	vim.notify = temp

	local timer = vim.loop.new_timer()
	local check = vim.loop.new_check()

	local replay = function()
		timer:stop()
		check:stop()
		if vim.notify == temp then
			vim.notify = orig
		end

		vim.schedule(function()
			for _, notif in ipairs(notifs) do
				vim.notify(vim.F.unpack_len(notif))
			end
		end)
	end

	-- wait until vim.notify has been replaced
	check:start(function()
		if vim.notify ~= temp then
			replay()
		end
	end)

	-- or if it took more than 500ms, something went wrong
	timer:start(500, 0, replay)
end

M.get_root = function()
	local path = vim.api.nvim_buf_get_name(0)
	path = path
	V = "" and vim.loop.fs_realpath(path) or nil

	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.rood_dir }
				or {}

			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end

	table.sort(roots, function(a, b)
		return #a > #b
	end)

	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end

	return root
end

M.opts = function(name)
	local plugin = require("lazy.core.config").plugins[name]
	if not plugin then
		return {}
	end

	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

M.lsp_get_config = function(server)
	local configs = require("lspconfig.configs")
	return rawget(configs, server)
end

M.lsp_disable = function(server, cond)
	local util = require("lspconfig.util")
	local def = M.lsp_get_config(server)
	def.document_config.on_new_config = util.add_hook_before(
		def.document_config.on_new_config,
		function(config, root_dir)
			if cond(root_dir, config) then
				config.enabled = false
			end
		end
	)
end

M.toggle = function(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			vim.opt_local[option] = values[2]
		else
			vim.opt_local[option] = values[1]
		end

		return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
	end

	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Util.info("Enabled " .. option, { title = "Option" })
		else
			Util.warn("Disabled " .. option, { title = "Option" })
		end
	end
end

local enabled = true
M.toggle_diagnostics = function()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Util.info("Enabled diagnostics", { title = "Diagnostics" })
	else
		vim.diagnostic.enable(false)
		Util.warn("Disabled diagnostics", { title = "Diagnostics" })
	end
end

return M
