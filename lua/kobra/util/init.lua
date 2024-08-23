local M = {}

local LazyUtil = require("lazy.core.util")

setmetatable(M, {
	__index = function(t, key)
		if LazyUtil[key] then
			return LazyUtil[key]
		end
		t[key] = require("kobra.util." .. key)
		return t[key]
	end,
})

function M.get_plugin(name)
	return require("lazy.core.config").spec.plugins[name]
end

function M.has(plugin)
	return M.get_plugin(plugin) ~= nil
end

function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

function M.lazy_notify()
	local notifs = {}
	local function temp(...)
		table.insert(notifs, vim.F.pack_len(...))
	end

	local orig = vim.notify
	vim.notify = temp

	local timer = vim.uv.new_timer()
	local check = assert(vim.uv.new_check())

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

	check:start(function()
		if vim.notify ~= temp then
			replay()
		end
	end)

	timer:start(500, 0, replay)
end

function M.is_loaded(name)
	local config = require("lazy.core.config")
	return config.plugins[name] and config.plugins[name]._.loaded
end

function M.on_load(name, fn)
	if M.is_loaded(name) then
		fn(name)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

function M.safe_map(mode, lhs, rhs, opts)
	local ks = require("lazy.core.handler").handlers.keys
	local modes = type(mode) == "string" and { mode } or mode

	modes = vim.tbl_filter(function(m)
		return not (ks.have and ks:have(lhs, m))
	end, modes)

	-- do not create the keymap if a lazy keys handler exists
	if #modes > 0 then
		opts = opts or {}
		opts.silent = opts.silent ~= false

		if opts.remap and not vim.g.vscode then
			opts.remap = nil
		end

		vim.keymap.set(modes, lhs, rhs, opts)
	end
end

function M.opts(name)
	local plugin = M.get_plugin(name)
	if not plugin then
		return {}
	end

	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

-- M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
-- function M.create_undo()
-- 	if vim.api.nvim_get_mode().mode == "i" then
-- 		vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
-- 	end
-- end

return M
