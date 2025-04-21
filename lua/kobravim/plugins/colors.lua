local M = {}

M[#M + 1] = {
	"rktjmp/lush.nvim",
	cmd = { "Lushify", "LushImport", "LushRunTutorial" },
}

M[#M + 1] = {
	"KobraKommander9/autumn.nvim",
	branch = "colorscheme",
	lazy = true,
	dependencies = { "rktjmp/lush.nvim" },
	opts = function(_, opts)
		opts = opts or {}
		return vim.tbl_deep_extend("force", {
			transparency = {
				enabled = KobraVim.config.ui.transparent,
			},
		}, opts)
	end,
}

return M
