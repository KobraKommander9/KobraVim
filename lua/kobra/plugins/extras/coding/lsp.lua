local M = {}

M[#M + 1] = {
	"dnlhc/glance.nvim",
	keys = {
		{ "<leader>lgd", "<cmd>Glance definitions<cr>", desc = "Goto Definition" },
		{ "<leader>lgi", "<cmd>Glance implementations<cr>", desc = "Goto Implementations" },
		{ "<leader>lgr", "<cmd>Glance references<cr>", desc = "Goto References" },
		{ "<leader>lgt", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definitions" },
	},
	cmd = { "Glance" },
	opts = function(_, opts)
		local options = {}

		options.mappings = {
			list = {
				["<leader>l"] = false,
				["<c-l>"] = require("glance").actions.enter_win("preview"),
			},
			preview = {
				["<leader>l"] = false,
				["<c-l>"] = require("glance").actions.enter_win("list"),
			},
		}

		if require("kobra.core").layouts.colemak then
			options.mappings.list.j = false
			options.mappings.list.k = false
			options.mappings.list.n = require("glance").actions.next
			options.mappings.list.e = require("glance").actions.previous()
		end

		return vim.tbl_deep_extend("force", options, opts)
	end,
}

M[#M + 1] = {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"SmiteshP/nvim-navbuddy",
			keys = {
				{ "<leader>bn", "<cmd>Navbuddy<cr>", desc = "Navbuddy" },
			},
			config = function(_, opts)
				local actions = require("nvim-navbuddy.actions")
				local config = {
					lsp = {
						auto_attach = true,
					},
				}

				if require("kobra.core").layouts.colemak then
					config.use_default_mappings = false
					config.mappings = {
						["<esc>"] = actions.close,
						q = actions.close,

						n = actions.next_sibling,
						e = actions.previous_sibling,
						h = actions.parent,
						i = actions.children,
						["0"] = actions.root,

						v = actions.visual_name,
						V = actions.visual_scope,

						y = actions.yank_name,
						Y = actions.yank_scope,

						l = actions.insert_name,
						L = actions.insert_scope,

						a = actions.append_name,
						A = actions.append_scope,

						r = actions.rename,

						d = actions.delete,

						f = actions.fold_create,
						F = actions.fold_delete,

						c = actions.comment,

						["<enter>"] = actions.select,
						o = actions.select,

						N = actions.move_down,
						E = actions.move_up,

						t = actions.telescope({
							layout_config = {
								height = 0.6,
								width = 0.6,
								prompt_position = "top",
								preview_width = 0.5,
							},
							layout_strategy = "horizontal",
						}),
					}
				end

				config = vim.tbl_deep_extend("force", config, opts or {})
				require("nvim-navbuddy").setup(config)
			end,
		},
	},
}

return M
