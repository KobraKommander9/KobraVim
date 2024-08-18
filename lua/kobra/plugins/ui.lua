local M = {}

M[#M + 1] = {
	"Leviathenn/nvim-transparent",
	event = "VimEnter",
	opts = {
		enable = require("kobra.core").ui.background == "transparent",
		exclude = {
			"KobraTLHead",
			"KobraTLHeadSep",
			"KobraTLActive",
			"KobraTLActiveSep",
			"KobraTLBoldLine",
			"KobraTLLineSep",
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
	opts = function(_, opts)
		opts = vim.tbl_deep_extend("force", opts or {}, {
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
		})
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
				opts = opts or {}
				opts.clues = vim.tbl_deep_extend("force", opts.clues or {}, {
					{ mode = "n", keys = "<leader>sn", desc = "+Noice" },
				})
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

M[#M + 1] = {
	"echasnovski/mini.icons",
	lazy = true,
	config = true,
}

M[#M + 1] = { "nvim-tree/nvim-web-devicons", lazy = true }

M[#M + 1] = { "MunifTanjim/nui.nvim", lazy = true }

M[#M + 1] = {
	"nanozuki/tabby.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		local filename = require("tabby.filename")

		local cwd = function()
			return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
		end

		local options = {
			hl = "TabLineFill",
			layout = "active_wins_at_tail",
			head = {
				{ cwd, hl = "KobraTLHead" },
				{ "", hl = "KobraTLHeadSep" },
			},
			active_tab = {
				label = function(tabid)
					return {
						"  " .. tabid .. " ",
						hl = "KobraTLActive",
					}
				end,
				left_sep = { "", hl = "KobraTLActiveSep" },
				right_sep = { "", hl = "KobraTLActiveSep" },
			},
			inactive_tab = {
				label = function(tabid)
					return {
						"  " .. tabid .. " ",
						hl = "KobraTLBoldLine",
					}
				end,
				left_sep = { "", hl = "KobraTLLineSep" },
				right_sep = { "", hl = "KobraTLLineSep" },
			},
			top_win = {
				label = function(winid)
					return {
						"  " .. filename.unique(winid) .. " ",
						hl = "TabLine",
					}
				end,
				left_sep = { "", hl = "KobraTLLineSep" },
				right_sep = { "", hl = "KobraTLLineSep" },
			},
			win = {
				label = function(winid)
					return {
						"  " .. filename.unique(winid) .. " ",
						hl = "TabLine",
					}
				end,
				left_sep = { "", hl = "KobraTLLineSep" },
				right_sep = { "", hl = "KobraTLLineSep" },
			},
			tail = {
				{ "", hl = "KobraTLHeadSep" },
				{ "  ", hl = "KobraTLHead" },
			},
		}

		opts = vim.tbl_deep_extend("force", opts or {}, options)
	end,
}

M[#M + 1] = {
	"SmiteshP/nvim-navic",
	lazy = true,
	init = function()
		vim.g.navic_silence = true
		KobraVim.on_attach(function(client, buffer)
			if client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, buffer)
			end
		end)
	end,
	opts = function(_, opts)
		opts = vim.tbl_deep_extend("force", opts or {}, {
			separator = " ",
			highlight = true,
			depth_limit = 5,
			icons = require("kobra.core").ui.icons.kinds,
		})
	end,
}

return M
