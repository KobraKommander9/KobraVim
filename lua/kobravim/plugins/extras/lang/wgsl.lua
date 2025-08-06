local M = {}

vim.filetype.add({ extension = { wgsl = "wgsl" } })

local function copy_queries()
	local file_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
	local source = file_dir .. "queries/wgsl"
	local target = vim.fn.stdpath("config") .. "/queries/wgsl"

	vim.fn.mkdir(target, "p")

	local scandir = vim.fn.globpath(source, "*.scm", false, true)

	for _, src_file in ipairs(scandir) do
		local filename = vim.fn.fnamemodify(src_file, ":t")
		local dst_file = target .. "/" .. filename

		local src_lines = vim.fn.readfile(src_file)
		local dst_lines = vim.fn.filereadable(dst_file) == 1 and vim.fn.readfile(dst_file) or nil

		if not dst_lines or not vim.deep_equal(src_lines, dst_lines) then
			vim.fn.writefile(src_lines, dst_file)
		end
	end
end

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter",
	opts = { ensure_installed = { "wgsl" } },
	config = function(_, opts)
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.wgsl = {
			install_info = {
				url = "https://github.com/szebniok/tree-sitter-wgsl",
				files = { "src/parser.c", "src/scanner.c" },
			},
			filetype = "wgsl",
		}

		require("nvim-treesitter.configs").setup(opts)

		copy_queries()
	end,
}

M[#M + 1] = {
	"williamboman/mason.nvim",
	opts = { ensure_installed = { "wgsl-analyzer" } },
}

return M
