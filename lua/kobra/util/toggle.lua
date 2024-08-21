local M = {}

function M.map(lhs, toggle)
	local t = M.wrap(toggle)
	Kobra.safe_map("n", lhs, function()
		t()
	end, { desc = "Toggle " .. toggle.name })
end

function M.wrap(toggle)
	return setmetatable(toggle, {
		__call = function()
			toggle.set(not toggle.get())
			local state = toggle.get()
			if state then
				Kobra.info("Enabled " .. toggle.name, { title = toggle.name })
			else
				Kobra.warn("Disabled " .. toggle.name, { title = toggle.name })
			end
			return state
		end,
	})
end

function M.option(option, opts)
	opts = opts or {}
	local name = opts.name or option
	local on = opts.values and opts.values[2] or true
	local off = opts.values and opts.values[1] or false
	return M.wrap({
		name = name,
		get = function()
			return vim.opt_local[option]:get() == on
		end,
		set = function(state)
			vim.opt_local[option] = state and on or off
		end,
	})
end

M.diagnostics = M.wrap({
	name = "Diagnostics",
	get = function()
		return vim.diagnostic.is_enabled and vim.diagnostic.is_enabled()
	end,
	set = vim.diagnostic.enable,
})

local nu = { number = true, relativenumber = true }
M.number = M.wrap({
	name = "Line Numbers",
	get = function()
		return vim.opt_local.number:get() or vim.opt_local.relativenumber:get()
	end,
	set = function(state)
		if state then
			vim.opt_local.number = nu.number
			vim.opt_local.relativenumber = nu.relativenumber
		else
			nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
		end
	end,
})

M.treesitter = M.wrap({
	name = "Treesitter Highlight",
	get = function()
		return vim.b.ts_highlight
	end,
	set = function(state)
		if state then
			vim.treesitter.start()
		else
			vim.treesitter.stop()
		end
	end,
})

-- function M.format(buf)
-- 	return M.wrap({
-- 		name = "Auto Format (" .. (buf and "Buffer" or "Global") .. ")",
-- 		get = function()
-- 			if not buf then
-- 				return vim.g.autoformat == nil or vim.g.autoformat
-- 			end
-- 			return Kobra.format.enabled()
-- 		end,
-- 		set = function(state)
-- 			Kobra.format.enable(state, buf)
-- 		end,
-- 	})
-- end

setmetatable(M, {
	__call = function(m, ...)
		return m.option(...)
	end,
})

return M
