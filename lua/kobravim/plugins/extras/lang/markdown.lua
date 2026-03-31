local M = {}

M[#M + 1] = {
	"KobraKommander9/bookwyrm.nvim",
	dependencies = {
		"kkharji/sqlite.lua",
		"nvim-mini/mini.pick",
		{
			"nvim-mini/mini.clue",
			opts = KobraVim.mini.clue_options({
				{ mode = "n", keys = "<leader>j", desc = "+Journals" },
				{ mode = "n", keys = "<leader>jr", desc = "+Registry" },
			}),
		},
	},
	keys = {
		-- notebook (registry)
		{ "<leader>jrd", "<cmd>BookwyrmNotebookSetDefault<cr>", desc = "Set active default" },
		{ "<leader>jrD", "<cmd>BookwyrmNotebookDelete<cr>", desc = "Delete notebooks" },
		{ "<leader>jrn", "<cmd>BookwyrmNotebookRegister<cr>", desc = "Register notebook" },
		{ "<leader>jrR", "<cmd>BookwyrmReset<cr>", desc = "Reset and re-scan notebook" },
		{ "<leader>jrr", "<cmd>BookwyrmNotebookRename<cr>", desc = "Rename active notebook" },
		{ "<leader>jrs", "<cmd>BookwyrmNotebookSwitch<cr>", desc = "Swap notebook" },
		{ "<leader>jrS", "<cmd>BookwyrmSync<cr>", desc = "Sync notebook with filesystem" },

		-- notes
		{ "<leader>jb", "<cmd>BookwyrmNoteBacklinks<cr>", desc = "Search backlinks" },
		{
			"<leader>jj",
			"<cmd>lua require('bookwyrm').api.open_capture({ tname = 'journal' })<cr>",
			desc = "Create journal note",
		},
		{ "<leader>jn", "<cmd>BookwyrmNoteCapture<cr>", desc = "Create note" },
		{ "<leader>js", "<cmd>BookwyrmNoteSearch<cr>", desc = "Search notes" },
		{
			"<leader>jt",
			"<cmd>lua require('bookwyrm').api.open_capture({ tname = 'todo' })<cr>",
			desc = "Create todo note",
		},
	},
	event = "VeryLazy",
	opts = {
		silent = true,
	},
}

return M
