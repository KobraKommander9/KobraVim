Core.init()

local M = {}

M[#M + 1] = {
	"folke/lazy.nvim",
	version = "*",
}

M[#M + 1] = {
	"KobraKommander9/KobraVim",
	priority = 10000,
	lazy = false,
	config = true,
	cond = true,
	version = "*",
}

return M
