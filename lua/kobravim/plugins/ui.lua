local M = {}

M[#M + 1] = {
	"xiyaowong/transparent.nvim",
	cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
	opts = {
		groups = {
			"DiagnosticVirtualTextError",
			"DiagnosticVirtualTextWarn",
			"DiagnosticVirtualTextInfo",
			"DiagnosticVirtualTextHint",
			"DiagnosticVirtualTextOk",
			"LspInlayHint",
			"Normal",
			"NormalFloat",
			"NormalNC",
			"Pmenu",
		},
	},
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
	opts = {
		timeout = 3000,
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
		render = "compact",
		stages = "slide",
		background_colour = "#000000",
	},
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
		{
			"echasnovski/mini.clue",
			opts = KobraVim.mini.clue_options({
				{ mode = "n", keys = "<leader>sn", desc = "+Noice" },
			}),
		},
		{
			"rcarriga/nvim-notify",
			opts = {
				background_colour = "#000000",
			},
		},
	},

  -- stylua: ignore
	keys = {
		{ "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
		{ "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
		{ "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
		{ "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
		{ "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
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

	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
		},
		presets = {
			command_palette = true,
			long_message_to_split = true,
			inc_rename = true,
		},
	},
}

M[#M + 1] = {
	"echasnovski/mini.animate",
	event = "VeryLazy",
	config = true,
}

M[#M + 1] = {
	"echasnovski/mini.icons",
	lazy = true,
	opts = {
		file = {
			[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
			["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
		},
		filetype = {
			dotenv = { glyph = "", hl = "MiniIconsYellow" },
		},
	},
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}

M[#M + 1] = {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufRead",
	main = "ibl",
	config = true,
}

M[#M + 1] = { "MunifTanjim/nui.nvim", lazy = true }

return M
