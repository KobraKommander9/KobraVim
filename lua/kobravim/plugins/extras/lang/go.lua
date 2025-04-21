local M = {}

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter",
	opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
}

M[#M + 1] = {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			gopls = {
				gofumpt = true,
				codelenses = {
					gc_details = false,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					test = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				analyses = {
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
					useany = true,
				},
				usePlaceholders = true,
				completeUnimported = true,
				staticcheck = true,
				directoryFilters = {
					"-.git",
					"-.vscode",
					"-.idea",
					"-.vscode-test",
					"-node_modules",
					"-plz-out",
				},
				semanticTokens = true,
			},
		},
	},
	setup = {
		gopls = function()
			-- workaround for gopls not supporting semanticTokensProvider
			-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
			KobraVim.lsp.on_attach(function(client, _)
				if not client.server_capabilities.semanticTokensProvider then
					local semantic = client.config.capabilities.textDocument.semanticTokens
					client.server_capabilities.semanticTokensProvider = {
						full = true,
						legend = {
							tokenTypes = semantic.tokenTypes,
							tokenModifiers = semantic.tokenModifiers,
						},
						range = true,
					}
				end
			end, "gopls")
			-- end workaround
		end,
	},
}

M[#M + 1] = {
	"williamboman/mason.nvim",
	opts = { ensure_installed = { "goimports", "gofumpt" } },
}

M[#M + 1] = {
	"nvimtools/none-ls.nvim",
	optional = true,
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = { ensure_installed = { "gomodifytags", "impl" } },
		},
	},
	opts = function(_, opts)
		local nls = require("null-ls")
		opts.sources = vim.list_extend(opts.sources or {}, {
			nls.builtins.code_actions.gomodifytags,
			nls.builtins.code_actions.impl,
			nls.builtins.formatting.goimports,
			nls.builtins.formatting.gofumpt,
		})
	end,
}

M[#M + 1] = {
	"stevearc/conform.nvim",
	optional = true,
	opts = {
		formatters_by_ft = {
			go = { "goimports", "gofumpt" },
		},
	},
}

M[#M + 1] = {
	"mfussenegger/nvim-dap",
	optional = true,
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = { ensure_installed = { "delve" } },
		},
		{
			"leoluz/nvim-dap-go",
			opts = {},
		},
	},
}

M[#M + 1] = {
	"nvim-neotest/neotest",
	optional = true,
	dependencies = {
		"fredrikaverpil/neotest-golang",
	},
	opts = {
		adapters = {
			["neotest-golang"] = {
				dap_go_enabled = true,
			},
		},
	},
}

M[#M + 1] = {
	"echasnovski/mini.icons",
	opts = {
		file = {
			[".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
		},
		filetype = {
			gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
		},
	},
}

return M
