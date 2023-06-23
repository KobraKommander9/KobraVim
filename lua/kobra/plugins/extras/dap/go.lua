local M = {}

M[#M + 1] = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		keys = {
			{
				"<leader>paG",
				function()
					require("dap-go").debug_test()
				end,
				desc = "Debug Test (Go)",
			},
			{
				"<leader>pag",
				function()
					require("dap-go").debug_last_test()
				end,
				desc = "Debug Last Test (Go)",
			},
		},
		opts = {
			dap_configurations = {
				{
					type = "go",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
				},
			},
		},
		config = function(_, opts)
			require("dap-go").setup(opts)
		end,
	},
}

return M
