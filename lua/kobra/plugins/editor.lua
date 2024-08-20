local M = {}

-- buffer management
M[#M + 1] = {
	"echasnovski/mini.visits",
	event = "BufReadPre",
	dependencies = {
		"echasnovski/mini.extra",
		{
			"echasnovski/mini.clue",
			opts = KobraVim.clue.options({
				{ mode = "n", keys = "<leader>v", desc = "+Visits" },
			}),
		},
	},
	keys = {
		{ "<leader>vv", "<cmd>lua MiniVisits.add_label()<cr>", desc = "Add label" },
		{ "<leader>vV", "<cmd>lua MiniVisits.remove_label()<cr>", desc = "Remove label" },
		{
			"<leader>fv",
			function()
				require("mini.extra").pickers.visit_paths()
			end,
			desc = "Search visited files",
		},
		{
			"<leader>fl",
			function()
				require("mini.extra").pickers.visit_labels()
			end,
			desc = "Search visited labels",
		},
	},
	config = true,
}

-- move text
M[#M + 1] = {
	"echasnovski/mini.move",
	event = "BufEnter",
	dependencies = {
		{
			"echasnovski/mini.clue",
			opts = KobraVim.clue.options(function()
				local keys = KobraVim.keys

				return {
					{ mode = "n", keys = "<leader>m", desc = "+Move" },
					{ mode = "x", keys = "<leader>m", desc = "+Move" },
					{ mode = "n", keys = "<leader>mh", postkeys = "<leader>m", desc = "Move left" },
					{ mode = "n", keys = "<leader>m" .. keys.l, postkeys = "<leader>m", desc = "Move right" },
					{ mode = "n", keys = "<leader>m" .. keys.j, postkeys = "<leader>m", desc = "Move down" },
					{ mode = "n", keys = "<leader>m" .. keys.k, postkeys = "<leader>m", desc = "Move up" },
					{ mode = "x", keys = "<leader>mh", postkeys = "<leader>m", desc = "Move left" },
					{ mode = "x", keys = "<leader>m" .. keys.l, postkeys = "<leader>m", desc = "Move right" },
					{ mode = "x", keys = "<leader>m" .. keys.j, postkeys = "<leader>m", desc = "Move down" },
					{ mode = "x", keys = "<leader>m" .. keys.k, postkeys = "<leader>m", desc = "Move up" },
				}
			end),
		},
	},
	opts = function(_, opts)
		local keys = KobraVim.keys

		local options = {
			mappings = {
				left = "<leader>mh",
				right = "<leader>m" .. keys.l,
				down = "<leader>m" .. keys.j,
				up = "<leader>m" .. keys.k,

				line_left = "<leader>mh",
				line_right = "<leader>m" .. keys.l,
				line_down = "<leader>m" .. keys.j,
				line_up = "<leader>m" .. keys.k,
			},
		}

		return vim.tbl_deep_extend("force", options, opts)
	end,
}

-- better bracket jumps
M[#M + 1] = {
	"echasnovski/mini.bracketed",
	event = "BufEnter",
	dependencies = {
		{
			"echasnovski/mini.clue",
			opts = KobraVim.clue.options({
				{ mode = "n", keys = "]b", postkeys = "]", desc = "next bracket" },
				{ mode = "n", keys = "[b", postkeys = "[", desc = "previous bracket" },
			}),
		},
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
	opts = {
		style = "sign",
		signs = { add = "▎", change = "▎", delete = "" },
	},
}

return M
