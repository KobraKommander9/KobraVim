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
