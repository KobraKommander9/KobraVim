local M = {}

M[#M + 1] = {
	"KobraKommander9/bookwyrm.nvim",
	dependencies = {
		"kkharji/sqlite.lua",
	},
	config = true,
}

return M
