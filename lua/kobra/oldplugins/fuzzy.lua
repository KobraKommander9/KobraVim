local M = {}

M[#M + 1] = {
	"echasnovski/mini.pick",
	lazy = true,
	version = false,
	keys = {
		{ "<leader>sC", "<cmd>Pick cli<cr>", desc = "CLI Output" },
		{ "<leader>sf", "<cmd>Pick files<cr>", desc = "Search Files" },
		{ "<leader>sg", "<cmd>Pick grep_live<cr>", desc = "Live Grep" },
		{ "<leader>sG", "<cmd>Pick grep<cr>", desc = "Grep" },
		{ "<leader>s?", "<cmd>Pick help<cr>", desc = "Help" },
	},
	config = function(_, opts)
		local options = {}

		if require("kobra.core").layouts.colemak then
			options.mappings = {
				choose_marked = "<C-m>",
				delete_left = "<C-b>",
				mark = "<C-l>",
				move_up = "<C-e>",
				paste = "<C-p>",
				refine_marked = "<C-;>",
				scroll_down = "<C-d>",
				scroll_right = "<C-i>",
				scroll_up = "<C-u>",
				toggle_info = "<S-Tab>",
				toggle_preview = "<Tab>",
			}
		end

		vim.tbl_deep_extend("force", options, opts)
		require("mini.pick").setup(options)
	end,
}

M[#M + 1] = {
	"echasnovski/mini.extra",
	dependencies = {
		{ "echasnovski/mini.fuzzy", version = false, config = true },
		"echasnovski/mini.pick",
	},
	cmd = "Pick",
	version = false,
	keys = {
		{ "<leader>:", "<cmd>Pick commands<cr>", desc = "Commands" },
		-- buffers
		{ "<leader>bl", "<cmd>Pick buffers<cr>", desc = "Buffers" },
		-- diagnostics
		{ "<leader>dg", "<cmd>Pick diagnostic<cr>", desc = "Diagnostics" },
		-- find
		{ "<leader>fF", "<cmd>Pick explorer<cr>", desc = "Find Files" },
		{ "<leader>fr", "<cmd>Pick old_files<cr>", desc = "Recent Files" },
		-- git
		{ "<leader>gb", "<cmd>Pick git_branches<cr>", desc = "Git Branches" },
		{ "<leader>gc", "<cmd>Pick git_commits<cr>", desc = "Git Commits" },
		{ "<leader>gf", "<cmd>Pick git_files<cr>", desc = "Git Files" },
		{ "<leader>gH", "<cmd>Pick git_hunks<cr>", desc = "Git Hunks" },
		-- search
		{ "<leader>sb", "<cmd>Pick buf_lines<cr>", desc = "In Buffer" },
		{ "<leader>sc", "<cmd>Pick list scope='changelist'<cr>", desc = "Change List" },
		{ "<leader>sh", "<cmd>Pick history<cr>", desc = "History" },
		{ "<leader>sH", "<cmd>Pick hl_groups<cr>", desc = "Highlights" },
		{ "<leader>sj", "<cmd>Pick list scope='jumplist'<cr>", desc = "Jump List" },
		{ "<leader>sk", "<cmd>Pick keymaps<cr>", desc = "Keymaps" },
		{ "<leader>sl", "<cmd>Pick list scope='location'<cr>", desc = "Quickfix List" },
		{ "<leader>sm", "<cmd>Pick marks scope='buf'<cr>", desc = "Marks (buffer)" },
		{ "<leader>sM", "<cmd>Pick marks<cr>", desc = "Marks" },
		{ "<leader>so", "<cmd>Pick options<cr>", desc = "Options" },
		{ "<leader>sq", "<cmd>Pick list scope='quickfix'<cr>", desc = "Quickfix List" },
		{ "<leader>sR", "<cmd>Pick registers<cr>", desc = "Registers" },
		{ "<leader>ss", "<cmd>Pick spellsuggest<cr>", desc = "Spelling Suggestions" },
		{ "<leader>st", "<cmd>Pick treesitter<cr>", desc = "Treesitter Nodes" },
	},
	config = true,
}

return M
