local M = {}

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	branch = "main",
	build = function()
		local ts = require("nvim-treesitter")
		package.loaded["kobravim.util.treesitter"] = nil
		KobraVim.treesitter.build(function()
			ts.update(nil, { summary = true })
		end)
	end,
	event = { "VeryLazy" },
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
	opts_extend = { "ensure_installed" },
	opts = {
		indent = { enable = true },
		highlight = { enable = true },
		folds = { enable = true },
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

		ts.setup(opts)
		KobraVim.treesitter.get_installed(true)

		local install = vim.tbl_filter(function(lang)
			return not KobraVim.treesitter.have(lang)
		end, opts.ensure_installed or {})

		if #install > 0 then
			KobraVim.treesitter.build(function()
				ts.install(install, { summary = true }):await(function()
					KobraVim.treesitter.get_installed(true)
				end)
			end)
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("KobraTS", { clear = true }),
			callback = function(args)
				local ft, lang = args.match, vim.treesitter.language.get_lang(args.match)
				if not KobraVim.treesitter.have(ft) then
					return
				end

				local function enabled(feat)
					local f = opts[feat] or {}
					return f.enable ~= false
						and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
				end

				if enabled("highlight") then
					pcall(vim.treesitter.start, args.buf)
				end

				if enabled("indent") then
					vim.api.nvim_set_option_value(
						"indentexpr",
						"v:lua.KobraVim.treesitter.indentexpr()",
						{ scope = "local" }
					)
				end

				if enabled("folds") then
					vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local" })
					vim.api.nvim_set_option_value(
						"foldexpr",
						"v:lua.KobraVim.treesitter.foldexpr()",
						{ scope = "local" }
					)
				end
			end,
		})

		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				local ft = vim.bo[buf].filetype
				if ft ~= "" then
					vim.api.nvim_exec_autocmds("FileType", {
						group = "KobraTS",
						pattern = ft,
						buffer = buf,
						modeline = false,
					})
				end
			end
		end
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
