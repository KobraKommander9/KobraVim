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
				settings = {
					gopls = {
						semanticTokens = true,
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
					},
				},
			},
		},
	},
	setup = {
		gopls = function(_, opts)
			opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities, {
				textDocument = {
					semanticTokens = {
						dynamicRegistration = true,
						requests = { full = true },
					},
				},
			})

			vim.lsp.enable("gopls", opts)

			return true
		end,
	},
}

M[#M + 1] = {
	"williamboman/mason.nvim",
	opts = { ensure_installed = { "gofumpt" } },
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
			nls.builtins.formatting.gofumpt,
		})
	end,
}

M[#M + 1] = {
	"stevearc/conform.nvim",
	optional = true,
	opts = {
		formatters_by_ft = {
			go = { "gofumpt", "lsp_format" },
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
			config = true,
		},
	},
	config = function()
		local dap = require("dap")
		table.insert(dap.configurations.go, {
			type = "go",
			name = "Debug (Prompt for Program, Tags, & Args)",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable/directory: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = require("dap-go").get_arguments,
			buildFlags = require("dap-go").get_build_flags,
		})
	end,
}

M[#M + 1] = {
	"nvim-neotest/neotest",
	optional = true,
	dependencies = {
		"fredrikaverpil/neotest-golang",
	},
	opts = function()
		return {
			adapters = {
				require("neotest-golang"),
			},
		}
	end,
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
