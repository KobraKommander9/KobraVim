local M = {}

KobraVim.rtp.add_current_dir(debug.getinfo(1, "S").source:sub(2))
vim.filetype.add({ extension = { wgsl = "wgsl" } })

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter",
	opts = { ensure_installed = { "wgsl" } },
}

M[#M + 1] = {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			wgsl_analyzer = { filetypes = { "wgsl" } },
		},
	},
}

M[#M + 1] = {
	"williamboman/mason.nvim",
	opts = { ensure_installed = { "wgsl-analyzer" } },
}

return M
