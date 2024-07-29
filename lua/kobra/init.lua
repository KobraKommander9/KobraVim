local M = {}

function M.setup(opts)
	_G.Core = require("kobra.core")
	Core.setup(opts)
end

return M
