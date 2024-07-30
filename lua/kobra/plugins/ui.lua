local M = {}

local Util = require("kobra.util")

M[#M + 1] = {
	"xiyaowong/transparent.nvim",
	lazy = false,
	cond = require("kobra.core").ui.background == "transparent",
}

M[#M + 1] = {
	"rcarriga/nvim-notify",
	keys = {
		{
			"<leader>un",
			function()
				require("notify").dismiss({ silent = true, pending = true })
			end,
			desc = "Dismiss all notifications",
		},
	},
	opts = function(_, opts)
		local options = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			render = "compact",
			stages = "slide",
		}

		return vim.tbl_deep_extend("force", options, opts)
	end,
	init = function()
		-- when noice is not enabled, install notify on VeryLazy
		if not KobraVim.has("noice.nvim") then
			KobraVim.on_very_lazy(function()
				vim.notify = require("notify")
			end)
		end
	end,
}

M[#M + 1] = {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		-- mini clue integration
		{
			"echasnovski/mini.clue",
			opts = function(_, opts)
				local options = {
					clues = {
						{ mode = "n", keys = "<leader>sn", desc = "+Noice" },
					},
				}

				if Util.has("noice.nvim") then
					return vim.tbl_deep_extend("force", opts, options)
				end
			end,
		},
	},
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = {
			command_palette = true,
			long_message_to_split = true,
			inc_rename = true,
		},
	},
	keys = {
		{
			"<S-Enter>",
			function()
				require("noice").redirect(vim.fn.getcmdline())
			end,
			mode = "c",
			desc = "Redirect Cmdline",
		},
		{
			"<leader>snl",
			function()
				require("noice").cmd("last")
			end,
			desc = "Noice Last Message",
		},
		{
			"<leader>snh",
			function()
				require("noice").cmd("history")
			end,
			desc = "Noice History",
		},
		{
			"<leader>sna",
			function()
				require("noice").cmd("all")
			end,
			desc = "Noice All",
		},
		{
			"<leader>snd",
			function()
				require("noice").cmd("dismiss")
			end,
			desc = "Dismiss All",
		},
		{
			"<c-f>",
			function()
				if not require("noice.lsp").scroll(4) then
					return "<c-f>"
				end
			end,
			silent = true,
			expr = true,
			desc = "Scroll forward",
			mode = { "i", "n", "s" },
		},
		{
			"<c-b>",
			function()
				if not require("noice.lsp").scroll(-4) then
					return "<c-b>"
				end
			end,
			silent = true,
			expr = true,
			desc = "Scroll backward",
			mode = { "i", "n", "s" },
		},
	},
}

M[#M + 1] = { "nvim-tree/nvim-web-devicons", lazy = true }

M[#M + 1] = { "MunifTanjim/nui.nvim", lazy = true }

return M
