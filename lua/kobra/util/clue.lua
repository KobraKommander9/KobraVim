local M = {}

function M.options(clues, triggers)
	return function(_, opts)
		opts = opts or {}
		opts.clues = vim.tbl_deep_extend("force", opts.clues or {}, clues or {})
		opts.triggers = vim.tbl_deep_extend("force", opts.triggers or {}, triggers or {})
	end
end

return M
