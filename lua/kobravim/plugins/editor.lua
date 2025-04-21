local M = {}

-- buffer management
M[#M + 1] = {
	"echasnovski/mini.visits",
	event = "BufReadPre",
	dependencies = {
		"echasnovski/mini.extra",
		{
			"echasnovski/mini.clue",
			opts = KobraVim.mini.clue_options({
				{ mode = "n", keys = "<leader>v", desc = "+Visits" },
			}),
		},
	},
	keys = {
		{ "<leader>vv", "<cmd>lua MiniVisits.add_label()<cr>", desc = "Add label" },
		{ "<leader>vV", "<cmd>lua MiniVisits.remove_label()<cr>", desc = "Remove label" },
		{ "<leader>fv", KobraVim.pick.extra("visit_paths"), desc = "Search visited files" },
		{ "<leader>fl", KobraVim.pick.extra("visit_labels"), desc = "Search visited labels" },
	},
	config = true,
}

-- global search and replace
M[#M + 1] = {
	"nvim-pack/nvim-spectre",
	cmd = { "Spectre" },
	keys = {
		{
			"<leader>sr",
			function()
				require("spectre").open()
			end,
			desc = "Replace in files (Spectre)",
		},
	},
	config = true,
}

-- file changes
M[#M + 1] = {
	"echasnovski/mini.diff",
	event = "BufReadPre",
	opts = function(_, opts)
		opts = opts or {}
		return vim.tbl_deep_extend("force", {
			view = {
				style = "sign",
				signs = {
					add = KobraVim.config.icons.diff.add,
					change = KobraVim.config.icons.diff.change,
					delete = KobraVim.config.icons.diff.delete,
				},
			},
		}, opts)
	end,
}

M[#M + 1] = {
	"echasnovski/mini.pairs",
	event = "InsertEnter",
	config = true,
}

return M
