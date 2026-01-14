local M = {}

vim.filetype.add({ extension = { wgsl = "wgsl" } })

local current_file_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
if current_file_dir then
	vim.opt.rtp:append(current_file_dir)
end

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter",
	opts = { ensure_installed = { "wgsl" } },
	config = function(_, opts)
		local parsers = require("nvim-treesitter.parsers")

		parsers.get_parser_configs().wgsl = {
			install_info = {
				url = "https://github.com/szebniok/tree-sitter-wgsl",
				files = { "src/parser.c", "src/scanner.c" },
				branch = "master",
			},
			filetype = "wgsl",
		}

		require("nvim-treesitter.configs").setup(opts)
	end,
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
