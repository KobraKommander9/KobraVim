local M = {}

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	init = function(plugin)
		require("lazy.core.loader").add_to_rtp(plugin)
	end,
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
			"zsh",
		},
	},
	config = function(_, opts)
		local ts = require("nvim-treesitter")

		ts.setup()

		print(vim.inspect(opts))
		if opts.ensure_installed then
			local installed = require("nvim-treesitter.config").installed_parsers()
			local to_install = vim.tbl_filter(function(p)
				return not vim.tbl_contains(installed, p)
			end, opts.ensure_installed)

			if #to_install > 0 then
				ts.install(to_install)
			end
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("KobraTS", { clear = true }),
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				local lang = vim.treesitter.language.get_lang(ft)

				if lang then
					pcall(vim.treesitter.start, args.buf, lang)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	opts = {
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]f"] = "@function.outer",
				["]c"] = "@class.outer",
				["]a"] = "@parameter.inner",
			},
			goto_next_end = {
				["]F"] = "@function.outer",
				["]C"] = "@class.outer",
				["]A"] = "@parameter.inner",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[c"] = "@class.outer",
				["[a"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
				["[C"] = "@class.outer",
				["[A"] = "@parameter.inner",
			},
		},
		lsp_interop = {
			enable = true,
			peek_definition_code = {
				["<leader>lf"] = "@function.outer",
				["<leader>lF"] = "@class.outer",
			},
		},
	},
}

-- Automatically add closing tags for HTML and JSX
M[#M + 1] = {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	config = true,
}

return M
