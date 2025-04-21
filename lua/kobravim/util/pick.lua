local M = {}

function M.builtin(fn, opts)
	return "<cmd>lua require('mini.pick').builtin." .. fn .. "(" .. (opts or "") .. ")<cr>"
end

function M.extra(fn, opts)
	return "<cmd>lua require('mini.extra').pickers." .. fn .. "(" .. (opts or "") .. ")<cr>"
end

return M
