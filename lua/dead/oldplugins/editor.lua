local M = {}

-- git signs
M[#M + 1] = {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
			end

			map("n", "]h", gs.next_hunk, "Next Hunk")
			map("n", "[h", gs.prev_hunk, "Prev Hunk")
			map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
			map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
			map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
			map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
			map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
			map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
			map("n", "<leader>ghb", function()
				gs.blame_line({ full = true })
			end, "Blame Line")
			map("n", "<leader>ghd", gs.diffthis, "Diff This")
			map("n", "<leader>ghD", function()
				gs.diffthis("~")
			end, "Diff This ~")
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
		end,
	},
}

-- todo comments
M[#M + 1] = {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = true,
	keys = {
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Next todo comment",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Previous todo comment",
		},
	},
}

-- file navigation
M[#M + 1] = {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "BufReadPost",
	cmd = {
		"Grapple",
		"GrappleCycle",
		"GrapplePopup",
		"GrappleReset",
		"GrappleSelect",
		"GrappleTag",
		"GrappleToggle",
		"GrappleUntag",
	},
	keys = {
		{ "<leader>n", '<cmd>lua require"grapple".cycle_forward()<cr>', desc = "Cycle Forward" },
		{ "<leader>e", '<cmd>lua require"grapple".cycle_backward()<cr>', desc = "Cycle Backward" },
		{ "<leader>i", "<cmd>GrapplePopup tags<cr>", desc = "View Tags" },
		{ "<leader>o", "<cmd>GrappleReset<cr>", desc = "Reset Tags" },
		{ "<leader>h", '<cmd>lua require"grapple".toggle{}<cr>', desc = "Tag" },
	},
	opts = {
		scope = "git_branch",
	},
}

return M
