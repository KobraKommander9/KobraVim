local M = {}

M[#M + 1] = {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			tsserver = {
				enabled = false,
			},
			ts_ls = {
				enabled = false,
			},
			vtsls = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							maxInlayHintLength = 30,
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
			},
		},
		setup = {
			tsserver = function()
				-- disable tsserver
				return true
			end,
			ts_ls = function()
				--disable ts_ls
				return true
			end,
		},
	},
}

M[#M + 1] = {
	"williamboman/mason.nvim",
	opts = { ensure_installed = { "vtsls" } },
}

M[#M + 1] = {
	"nvim-mini/mini.icons",
	opts = {
		file = {
			[".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
			[".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
			[".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
			[".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
			["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
			["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
			["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
			["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
			["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
		},
	},
}

return M
