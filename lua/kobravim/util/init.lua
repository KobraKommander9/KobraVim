local M = {}

local LazyUtil = require("lazy.core.util")

setmetatable(M, {
	__index = function(t, key)
		if LazyUtil[key] then
			return LazyUtil[key]
		end
		t[key] = require("kobravim.util." .. key)
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

function M.opts(name)
	local plugin = M.get_plugin(name)
	if not plugin then
		return {}
	end

	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

function M.lazy_notify()
	local notifs = {}
	local function temp(...)
		table.insert(notifs, vim.F.pack_len(...))
	end

	local orig = vim.notify
	vim.notify = temp

	local timer = assert(vim.uv.new_timer())
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

return M
