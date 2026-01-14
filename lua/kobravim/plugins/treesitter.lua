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
		},
	},
	config = function(_, opts)
		local ts = require("nvim-treesitter")

		if opts.ensure_installed and #opts.ensure_installed > 0 then
			ts.install(KobraVim.dedup(opts.ensure_installed))
		end

		ts.setup()

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("KobraTS", { clear = true }),
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
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
