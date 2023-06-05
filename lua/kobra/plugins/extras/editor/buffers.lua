local M = {}

M[#M + 1] = {
	"stevearc/oil.nvim",
	cmd = "Oil",
	keys = {
		{
			"<leader>bo",
			function()
				vim.cmd("Oil " .. vim.fn.expand("%:p:h"))
			end,
			desc = "Open Current Directory",
		},
	},
	opts = {
		default_file_explorer = false,
		keymaps = {
			["<C-s>"] = false,
			["<C-v>"] = "actions.select_vsplit",
		},
		view_options = {
			show_hidden = true,
		},
	},
}

M[#M + 1] = {
	"declancm/cinnamon.nvim",
	keys = { "<c-d>", "<c-u>" },
	config = true,
}

M[#M + 1] = {
	"sindrets/winshift.nvim",
	keys = {
		{ "<leader>bm", "<cmd>WinShift<cr>", desc = "Enter WinShift Mode" },
		{ "<leader>bs", "<cmd>WinShift swap<cr>", desc = "Swap Two Windows" },
	},
	opts = function(_, opts)
		local options = {}

		if require("kobra.core").layout.colemak then
			options.keys = {
				win_move_mode = {
					n = "down",
					e = "up",
					i = "right",
					N = "far_down",
					E = "far_up",
					I = "far_right",
				},
			}
		end

		return vim.tbl_deep_extend("keep", opts, options)
	end,
}

M[#M + 1] = {
	"anuvyklack/windows.nvim",
	cmd = {
		"WindowsMaximize",
		"WindowsMaximizeVertically",
		"WindowsMaximizeHorizontally",
		"WindowsEqualize",
		"WindowsEnableAutowidth",
		"WindowsDisableAutowidth",
		"WindowsToggleAutowidth",
	},
	keys = {
		{ "<leader>bh", "<cmd>WindowsMaximizeHorizontally<cr>", desc = "Maximize Windows Horizontally" },
		{ "<leader>bM", "<cmd>WindowsMaximize<cr>", desc = "Maximize Windows" },
		{ "<leader>bt", "<cmd>WindowsToggleAutowidth<cr>", desc = "Toggle Auto Width" },
		{ "<leader>bv", "<cmd>WindowsMaximizeVertically<cr>", desc = "Maximize Window Vertically" },
		{ "<leader>b=", "<cmd>WindowsEqualize<cr>", desc = "EqualizeWindows" },
	},
	dependencies = {
		"anuvyklack/middleclass",
	},
	config = function()
		vim.o.winwidth = 10
		vim.o.winminwidth = 10
		vim.o.equalalways = false
		require("windows").setup()
	end,
}

M[#M + 1] = {
	"sedm0784/vim-resize-mode",
	keys = { "<c-w>" },
}

return M
