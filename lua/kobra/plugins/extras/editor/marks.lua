local M = {}

M[#M + 1] = {
	"chentoast/marks.nvim",
	lazy = false,
	config = true,
}

M[#M + 1] = {
	"tom-anders/telescope-vim-bookmarks.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "<leader>fB", "<cmd>Telescope vim_bookmarks all", desc = "Find Bookmarks" },
	},
	config = function()
		require("telescope").load_extension("vim_bookmarks")
	end,
}

return M
