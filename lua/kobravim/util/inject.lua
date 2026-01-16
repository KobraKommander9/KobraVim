local M = {}

function M.args(fn, wrapper)
	return function(...)
		if wrapper(...) == false then
			return
		end

		return fn(...)
	end
end

return M
