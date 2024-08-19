local M = {}

setmetatable(M, {
	__index = function(t, key)
		t[key] = require("kobra.util.scripts" .. key)
		return t[key]
	end,
})

return M
