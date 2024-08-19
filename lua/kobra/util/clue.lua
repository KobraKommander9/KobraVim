local M = {}

function M.options(clues, triggers)
	return function(_, opts)
		opts = opts or {}
		opts.clues = vim.tbl_deep_extend("force", clues or {}, opts.clues or {})
		opts.triggers = vim.tbl_deep_extend("force", triggers or {}, opts.triggers or {})
	end
end

return M
