local M = {}

M[#M + 1] = {
	"folke/tokyonight.nvim",
	lazy = true,
	opts = { style = "moon" },
}

M[#M + 1] = {
	"EdenEast/nightfox.nvim",
	lazy = true,
}

M[#M + 1] = {
	"olimorris/onedarkpro.nvim",
	lazy = true,
	config = true,
}

M[#M + 1] = {
	"rockyzhang24/arctic.nvim",
	lazy = true,
	branch = "v2",
	dependencies = { "rktjmp/lush.nvim" },
}

M[#M + 1] = {
	"cpea2506/one_monokai.nvim",
	lazy = true,
	config = true,
}

M[#M + 1] = {
	"sainnhe/edge",
	lazy = true,
}

M[#M + 1] = {
	"ray-x/aurora",
	lazy = true,
}

M[#M + 1] = {
	"ray-x/starry.nvim",
	lazy = true,
}

return M
