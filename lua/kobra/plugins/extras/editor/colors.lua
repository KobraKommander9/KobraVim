local M = {}

M[#M + 1] = {
	"norcalli/nvim-colorizer.lua",
	keys = {
		{ "<leader>bca", "<cmd>ColorizerAttachToBuffer<cr>", desc = "Colorize current buffer" },
		{ "<leader>bcd", "<cmd>ColorizerDetachFromBuffer<cr>", desc = "Stop colorizing current buffer" },
		{ "<leader>bcr", "<cmd>ColorizerReloadAllBuffers<cr>", desc = "Reload colorizer on all buffers" },
		{ "<leader>bct", "<cmd>ColorizerToggle<cr>", desc = "Toggle colorizer" },
	},
	ft = { "css", "html", "javascript", "typescript", "lua", "vim" },
	opts = {
		css = { rgb_fn = true, mode = "foreground" },
		html = { rgb_fn = true, mode = "foreground" },
		javascript = { rgb_fn = true, mode = "foreground" },
		typescript = { rgb_fn = true, mode = "foreground" },
		lua = { rgb_fn = true, mode = "foreground" },
		vim = { rgb_fn = true, mode = "foreground" },
	},
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
