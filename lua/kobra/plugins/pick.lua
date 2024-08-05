local M = {}

local Core = require("kobra.core")

M[#M + 1] = {
	"echasnovski/mini.pick",
	cmd = { "Pick" },
	keys = {
		-- Buffers
		{
			"<leader>pb",
			function()
				local MiniPick = require("mini.pick")

				local wipeout_cur = function()
					vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
				end

				local buffer_mappings = Core.layouts.colemak and { wipeout = { char = "<C-q>" }, func = wipeout_cur }
					or { wipeout = { char = "<C-d>", func = wipeout_cur } }

				require("mini.pick").builtin.buffers({}, { mappings = buffer_mappings })
			end,
			desc = "Pick buffers",
		},

		-- Files
		{
			"<leader>pf",
			function()
				require("mini.pick").builtin.files()
			end,
			desc = "Pick files",
		},
		{
			"<leader>pfg",
			function()
				require("mini.pick").builtin.grep_live()
			end,
			desc = "Pick files (grep live)",
		},
		{
			"<leader>pfG",
			function()
				require("mini.pick").builtin.grep()
			end,
			desc = "Pick files (grep)",
		},

		-- Help
		{
			"<leader>ph",
			function()
				require("mini.pick").builtin.help()
			end,
			desc = "Pick help tags",
		},

		-- Resume
		{
			"<leader>pr",
			function()
				require("mini.pick").builtin.resume()
			end,
			desc = "Resume picker",
		},
	},
	opts = function(_, opts)
		local options = {}

		local colemak = {
			mappings = {
				delete_left = "<C-l>",

				mark = "<C-o>",

				move_up = "<C-e>",

				paste = "<C-p>",

				scroll_down = "<C-d>",
				scroll_right = "<C-i>",
				scroll_up = "<C-u>",
			},
		}

		if Core.layouts.colemak then
			options = vim.tbl_deep_extend("force", options, colemak)
		end

		return vim.tbl_deep_extend("force", options, opts)
	end,
	build = function()
		vim.ui.select = require("mini.pick").ui_select
	end,
}

M[#M + 1] = {
	"echasnovski/mini.extra",
	dependencies = {
		{ "echasnovski/mini.fuzzy", version = false, config = true },
		"echasnovski/mini.pick",
	},
	cmd = { "Pick" },
	keys = {
		-- Buffers
		{
			"<leader>pbl",
			function()
				require("mini.extra").pickers.buf_lines()
			end,
			desc = "Pick buffer lines",
		},

		-- Commands
		{
			"<leader>pc",
			function()
				require("mini.extra").pickers.history({ scope = "/" })
			end,
			desc = "Pick search history",
		},
		{
			"<leader>pC",
			function()
				require("mini.extra").pickers.history({ scope = ":" })
			end,
			desc = "Pick command history",
		},

		-- Diagnostics
		{
			"<leader>pd",
			function()
				require("mini.extra").pickers.diagnostic({ scope = "current" })
			end,
			desc = "Pick diagnostics",
		},
		{
			"<leader>pD",
			function()
				require("mini.extra").pickers.diagnostic()
			end,
			desc = "Pick diagnostics (all)",
		},

		-- Files
		{
			"<leader>pF",
			function()
				require("mini.extra").pickers.explorer({ cwd = vim.fn.expand("%:p:h") })
			end,
			desc = "Pick files (explorer)",
		},
		{
			"<leader>pfr",
			function()
				require("mini.extra").pickers.oldfiles()
			end,
			desc = "Pick old files",
		},

		-- Git
		{
			"<leader>pgb",
			function()
				require("mini.extra").pickers.git_branches()
			end,
			desc = "Pick git branches",
		},
		{
			"<leader>pgc",
			function()
				require("mini.extra").pickers.git_commits()
			end,
			desc = "Pick git branches",
		},
		{
			"<leader>pgf",
			function()
				require("mini.extra").pickers.git_files()
			end,
			desc = "Pick git branches",
		},
		{
			"<leader>pgh",
			function()
				require("mini.extra").pickers.git_hunks()
			end,
			desc = "Pick git hunks",
		},

		-- Marks
		{
			"<leader>pm",
			function()
				require("mini.extra").pickers.marsk()
			end,
			desc = "Pick marks",
		},

		-- LSP
		{
			"<leader>lgd",
			function()
				require("mini.extra").pickers.lsp({ scope = "declaration" })
			end,
			desc = "Goto LSP declarations",
		},
		{
			"<leader>lgD",
			function()
				require("mini.extra").pickers.lsp({ scope = "definition" })
			end,
			desc = "Goto LSP definitions",
		},
		{
			"<leader>lgi",
			function()
				require("mini.extra").pickers.lsp({ scope = "implementation" })
			end,
			desc = "Goto LSP implementations",
		},
		{
			"<leader>lgr",
			function()
				require("mini.extra").pickers.lsp({ scope = "references" })
			end,
			desc = "Goto LSP references",
		},
		{
			"<leader>lgs",
			function()
				require("mini.extra").pickers.lsp({ scope = "document_symbol" })
			end,
			desc = "Goto LSP symbols",
		},
		{
			"<leader>lgt",
			function()
				require("mini.extra").pickers.lsp({ scope = "type_definition" })
			end,
			desc = "Goto LSP types",
		},
		{
			"<leader>lgw",
			function()
				require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
			end,
			desc = "Goto LSP workspace symbols",
		},
	},
	config = true,
}

return M
