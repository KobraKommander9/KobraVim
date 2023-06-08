local M = {}

M[#M + 1] = {
	"norcalli/nvim-colorizer.lua",
	event = "BufEnter",
	keys = {
		{ "<leader>bca", "<cmd>ColorizerAttachToBuffer<cr>", desc = "Colorize current buffer" },
		{ "<leader>bcd", "<cmd>ColorizerDetachFromBuffer<cr>", desc = "Stop colorizing current buffer" },
		{ "<leader>bcr", "<cmd>ColorizerReloadAllBuffers<cr>", desc = "Reload colorizer on all buffers" },
		{ "<leader>bct", "<cmd>ColorizerToggle<cr>", desc = "Toggle colorizer" },
	},
	config = true,
}

M[#M + 1] = {
	"folke/which-key.nvim",
	opts = {
		defaults = {
			["<leader>bc"] = { name = "+colors" },
		},
	},
}

return M
