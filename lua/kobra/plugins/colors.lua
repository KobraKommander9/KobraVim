local M = {}

M[#M + 1] = {
	"rktjmp/lush.nvim",
	cmd = { "Lushify", "LushImport", "LushRunTutorial" },
}

M[#M + 1] = {
	"KobraKommander9/autumn.nvim",
	lazy = true,
	dependencies = { "rktjmp/lush.nvim" },
}

return M
