local M = {}

M[#M + 1] = {
	"nvim-treesitter/nvim-treesitter",
	opts = function(_, opts)
		opts.ensure_installed = opts.ensure_installed or {}
		vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
	end,
}

M[#M + 1] = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"b0o/SchemaStore.nvim",
		version = false,
	},
	opts = {
		servers = {
			jsonls = {
				on_new_config = function(new_config)
					new_config.settings.json.schemas = new_config.settings.json.schemas or {}
					vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
				end,
				settings = {
					json = {
						format = {
							enable = true,
						},
						validate = { enable = true },
					},
				},
			},
		},
	},
}

return M
