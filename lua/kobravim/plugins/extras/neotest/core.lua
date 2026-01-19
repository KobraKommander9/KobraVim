local M = {}

M[#M + 1] = {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		{
			"nvim-mini/mini.clue",
			opts = KobraVim.mini.clue_options({
				{ mode = "n", keys = "<leader>t", desc = "+Test" },
			}),
		},
	},

  -- stylua: ignore
  keys = {
    { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to Test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run Current File" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
    { "<leader>ts", function() require("neotest").run.stop() end, desc = "Stop Test" },
  },

	config = true,
}

return M
