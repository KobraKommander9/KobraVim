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
	"ellisonleao/gruvbox.nvim",
	lazy = true,
	config = true,
}

M[#M + 1] = {
	"sainnhe/everforest",
	lazy = true,
}

M[#M + 1] = {
	"sainnhe/sonokai",
	lazy = true,
}

M[#M + 1] = {
	"ofirgall/ofirkai.nvim",
	lazy = true,
	config = true,
}

M[#M + 1] = {
	"projekt0n/caret.nvim",
	lazy = true,
	config = true,
}

M[#M + 1] = {
	"lmburns/kimbox",
	lazy = true,
	config = function(_, opts)
		require("kimbox").setup(opts)
		require("kimbox").load()
	end,
}

M[#M + 1] = {
	"justinsgithub/oh-my-monokai.nvim",
	lazy = true,
	config = true,
}

return M
