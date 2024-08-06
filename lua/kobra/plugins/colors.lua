local M = {}

M[#M + 1] = {
	"folke/tokyonight.nvim",
	lazy = true,
	opts = { style = "moon" },
}

M[#M + 1] = {
	"shaunsingh/moonlight.nvim",
	lazy = true,
	init = function()
		vim.g.moonlight_borders = true
	end,
}

M[#M + 1] = {
	"EdenEast/nightfox.nvim",
	lazy = true,
}

M[#M + 1] = {
	"Mofiqul/dracula.nvim",
	lazy = true,
	opts = {
		transparent_bg = false,
		-- transparent_bg = vim.g.transparent_enabled,
	},
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

return M
