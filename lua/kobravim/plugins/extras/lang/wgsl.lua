local M = {}

vim.filetype.add({ extension = { wgsl = "wgsl" } })

local current_file_path = debug.getinfo(1, "S").source:sub(2)
local current_dir = vim.fn.fnamemodify(current_file_path, ":p:h")
vim.opt.rtp:append(current_dir)

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
