local M = {}

setmetatable(M, {
	__index = function(t, key)
		t[key] = require("kobra.util.heirline.components." .. key)
		return t[key]
	end,
})

return M
