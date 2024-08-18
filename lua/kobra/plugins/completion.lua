local M = {}

-- completion
M[#M + 1] = {
	"echasnovski/mini.completion",
	event = "VeryLazy",
	dependencies = {
		{
			"echasnovski/mini.fuzzy",
			config = true,
		},
	},
	opts = function(_, opts)
		opts = vim.tbl_deep_extend("force", opts or {}, {
			lsp_completion = {
				process_items = require("mini.fuzzy").process_lsp_items,
			},
		})
	end,
}

return M
