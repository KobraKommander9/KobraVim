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
	"navarasu/onedark.nvim",
	lazy = true,
	opts = function(_, opts)
		opts = opts or {}
		opts.style = opts.style or "deep"
		opts.transparent = opts.transparent or Kobra.config.ui.transparent == true
	end,
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
	config = function()
		vim.g.edge_style = "aura"
		if Kobra.config.ui.transparent == true then
			vim.g.edge_transparent_background = 1
		end
	end,
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
	"lmburns/kimbox",
	lazy = true,
	config = true,
}

M[#M + 1] = {
	"justinsgithub/oh-my-monokai.nvim",
	lazy = true,
	config = true,
}

return M
