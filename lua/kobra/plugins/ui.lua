local M = {}

M[#M + 1] = {
	"xiyaowong/transparent.nvim",
	lazy = false,
	cond = require("kobra.core").ui.background == "transparent",
	opts = {
		exclude_groups = {
			"NotifyBackground",
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
			desc = "Dismiss all Notifications",
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
		}

		if require("kobra.core").ui.background == "transparent" then
			options.background_colour = "#000000"
		end

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
	"stevearc/dressing.nvim",
	lazy = true,
	init = function()
		vim.ui.select = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.select(...)
		end
		vim.ui.input = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.input(...)
		end
	end,
}

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
				{ cwd, hl = "UserTLHead" },
				{ "", hl = "UserTLHeadSep" },
			},
			active_tab = {
				label = function(tabid)
					return {
						"  " .. tabid .. " ",
						hl = "UserTLActive",
					}
				end,
				left_sep = { "", hl = "UserTLActiveSep" },
				right_sep = { "", hl = "UserTLActiveSep" },
			},
			inactive_tab = {
				label = function(tabid)
					return {
						"  " .. tabid .. " ",
						hl = "UserTLBoldLine",
					}
				end,
				left_sep = { "", hl = "UserTLLineSep" },
				right_sep = { "", hl = "UserTLLineSep" },
			},
			top_win = {
				label = function(winid)
					return {
						"  " .. filename.unique(winid) .. " ",
						hl = "TabLine",
					}
				end,
				left_sep = { "", hl = "UserTLLineSep" },
				right_sep = { "", hl = "UserTLLineSep" },
			},
			win = {
				label = function(winid)
					return {
						"  " .. filename.unique(winid) .. " ",
						hl = "TabLine",
					}
				end,
				left_sep = { "", hl = "UserTLLineSep" },
				right_sep = { "", hl = "UserTLLineSep" },
			},
			tail = {
				{ "", hl = "UserTLHeadSep" },
				{ "  ", hl = "UserTLHead" },
			},
		}

		return vim.tbl_deep_extend("force", options, opts)
	end,
}

M[#M + 1] = {
	"rebelot/heirline.nvim",
	event = "VeryLazy",
	config = function()
		require("heirline").setup({
			statusline = require("kobra.core.config.ui.lines.statusline").statusline(),
			winbar = require("kobra.core.config.ui.lines.winbar").winbar(),
			-- tabline = require('kobra.core.config.ui.lines.tabline').tabline(),
			opts = {
				disable_winbar_cb = function(args)
					return require("heirline.conditions").buffer_matches({
						buftype = { "nofile", "prompt", "help", "quickfix" },
						filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
					}, args.buf)
				end,
			},
		})
	end,
}

M[#M + 1] = {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		-- which key integration
		{
			"folke/which-key.nvim",
			opts = function(_, opts)
				if require("kobra.util").has("noice.nvim") then
					opts.defaults["<leader>sn"] = { name = "+noice" }
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

M[#M + 1] = {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function(_, opts)
		local options = vim.tbl_deep_extend("force", require("kobra.core.config.ui.start-screen").config, opts)

		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		require("alpha").setup(options)

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				require("kobra.core.config.ui.start-screen").section.footer.val = "⚡ Neovim loaded "
					.. stats.count
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
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
	opts = function()
		return {
			separator = " ",
			highlight = true,
			depth_limit = 5,
			icons = require("kobra.core").icons.kinds,
		}
	end,
}

M[#M + 1] = { "nvim-tree/nvim-web-devicons", lazy = true }

M[#M + 1] = { "MunifTanjim/nui.nvim", lazy = true }

return M
