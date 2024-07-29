local M = {}

function M.setup(opts)
	_G.Core = Core
	Core.setup(opts)
end

return M
