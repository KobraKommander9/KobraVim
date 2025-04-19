local M = {}

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter",
	opts = function(_, opts)
		opts.ensure_installed = opts.ensure_installed or {}
		vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
	end,
}

M[#M + 1] = {
	"neovim/nvim-lspconfig",
	dependencies = { "jose-elias-alvarez/typescript.nvim" },
	opts = {
		servers = {
			tsserver = {
				settings = {
					typescript = {
						format = {
							indentSize = vim.o.shiftwidth,
							convertTabsToSpaces = vim.o.expandtab,
							tabSize = vim.o.tabstop,
						},
					},
					javascript = {
						format = {
							indentSize = vim.o.shiftwidth,
							convertTabsToSpaces = vim.o.expandtab,
							tabSize = vim.o.tabstop,
						},
					},
					completions = {
						completeFunctionCalls = true,
					},
				},
			},
		},
		setup = {
			tsserver = function(_, opts)
				Kobra.on_attach(function(client, buffer)
					if client.name == "tsserver" then
						vim.keymap.set(
							"n",
							"<leader>co",
							"<cmd>TypescriptOrganizeImports<cr>",
							{ buffer = buffer, desc = "Organize Imports" }
						)
						vim.keymap.set(
							"n",
							"<leader>cR",
							"<cmd>TypescriptRenameFile<cr>",
							{ buffer = buffer, desc = "Rename File" }
						)
					end
				end)

				require("typescript").setup({ server = opts })
				return true
			end,
		},
	},
}

M[#M + 1] = {
	"jose-elias-alvarez/null-ls.nvim",
	opts = function(_, opts)
		table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
	end,
}

return M
