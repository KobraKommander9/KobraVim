local M = {}

local components = require("kobra.util.heirline.components")

setmetatable(M, {
	__index = function(t, key)
		t[key] = require("kobra.util.heirline." .. key)
		return t[key]
	end,
})

function M.statusline()
	return {
		components.mode.component(),
	}
end

function M.tabline()
	return {}
end

function M.winbar()
	return {}
end

return M
