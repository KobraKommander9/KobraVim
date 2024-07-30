local M = {}

M[#M + 1] = {
	"xiyaowong/transparent.nvim",
	lazy = false,
	cond = require("kobra.core").ui.background == "transparent",
	opts = {
		exclude_groups = {
			"NotifyBackground",
		},
	},
}

return M
