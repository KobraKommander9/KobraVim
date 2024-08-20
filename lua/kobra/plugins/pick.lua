local M = {}

M[#M + 1] = {
	"echasnovski/mini.pick",
	cmd = { "Pick" },
	keys = {
		-- Buffers
		{
			"<leader>bb",
			function()
				local MiniPick = require("mini.pick")

				local wipeout_cur = function()
					vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
				end

				local buffer_mappings = KobraVim.config.layout == "colemak"
						and { wipeout = { char = "<C-q>" }, func = wipeout_cur }
					or { wipeout = { char = "<C-d>", func = wipeout_cur } }

				require("mini.pick").builtin.buffers({}, { mappings = buffer_mappings })
			end,
			desc = "Search buffers",
		},

		-- Files
		{
			"<leader>fs",
			function()
				require("mini.pick").builtin.files()
			end,
			desc = "Search files",
		},

		-- Search
		{
			"<leader>sg",
			function()
				require("mini.pick").builtin.grep_live()
			end,
			desc = "Search (grep live)",
		},
		{
			"<leader>sG",
			function()
				require("mini.pick").builtin.grep()
			end,
			desc = "Search (grep)",
		},

		-- Pickers
		{
			"<leader>sH",
			function()
				require("mini.pick").builtin.help()
			end,
			desc = "Search help tags",
		},
		{
			"<leader>sr",
			function()
				require("mini.pick").builtin.resume()
			end,
			desc = "Resume search",
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

		if KobraVim.config.layout == "colemak" then
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
		{ "echasnovski/mini.fuzzy", config = true },
		"echasnovski/mini.pick",
	},
	cmd = { "Pick" },
	keys = {
		{
			"<leader>sc",
			function()
				require("mini.extra").pickers.history({ scope = "/" })
			end,
			desc = "Search history",
		},
		{
			"<leader>sC",
			function()
				require("mini.extra").pickers.history({ scope = ":" })
			end,
			desc = "Search command history",
		},
		{
			"<leader>sd",
			function()
				require("mini.extra").pickers.diagnostic({ scope = "current" })
			end,
			desc = "Search diagnostics",
		},
		{
			"<leader>sD",
			function()
				require("mini.extra").pickers.diagnostic()
			end,
			desc = "Search diagnostics (all)",
		},
		{
			"<leader>sm",
			function()
				require("mini.extra").pickers.list({ scope = "change" })
			end,
			desc = "Search changelist",
		},
		{
			"<leader>sM",
			function()
				require("mini.extra").pickers.marsk()
			end,
			desc = "Search marks",
		},
		{
			"<leader>so",
			function()
				require("mini.extra").pickers.options()
			end,
			desc = "Search options",
		},
		{
			"<leader>sq",
			function()
				require("mini.extra").pickers.list({ scope = "quickfix" })
			end,
			desc = "Search quickfix",
		},
		{
			"<leader>sT",
			function()
				require("mini.extra").pickers.treesitter()
			end,
			desc = "Search treesitter",
		},
		{
			"<leader>sz",
			function()
				require("mini.extra").pickers.spellsuggest()
			end,
			desc = "Search spelling suggestions",
		},

		-- Buffers
		{
			"<leader>bl",
			function()
				require("mini.extra").pickers.buf_lines()
			end,
			desc = "Search buffer lines",
		},

		-- Files
		{
			"<leader>fS",
			function()
				require("mini.extra").pickers.explorer({ cwd = vim.fn.expand("%:p:h") })
			end,
			desc = "Search files (explorer)",
		},
		{
			"<leader>fo",
			function()
				require("mini.extra").pickers.oldfiles()
			end,
			desc = "Search old files",
		},

		-- Git
		{
			"<leader>gb",
			function()
				require("mini.extra").pickers.git_branches()
			end,
			desc = "Search git branches",
		},
		{
			"<leader>gc",
			function()
				require("mini.extra").pickers.git_commits()
			end,
			desc = "Search git commits",
		},
		{
			"<leader>gf",
			function()
				require("mini.extra").pickers.git_files()
			end,
			desc = "Search git files",
		},
		{
			"<leader>gh",
			function()
				require("mini.extra").pickers.git_hunks()
			end,
			desc = "Search git hunks",
		},

		-- LSP
		{
			"<leader>ld",
			function()
				require("mini.extra").pickers.lsp({ scope = "declaration" })
			end,
			desc = "LSP declarations",
		},
		{
			"<leader>lD",
			function()
				require("mini.extra").pickers.lsp({ scope = "definition" })
			end,
			desc = "LSP definitions",
		},
		{
			"<leader>li",
			function()
				require("mini.extra").pickers.lsp({ scope = "implementation" })
			end,
			desc = "LSP implementations",
		},
		{
			"<leader>lr",
			function()
				require("mini.extra").pickers.lsp({ scope = "references" })
			end,
			desc = "LSP references",
		},
		{
			"<leader>ls",
			function()
				require("mini.extra").pickers.lsp({ scope = "document_symbol" })
			end,
			desc = "LSP symbols",
		},
		{
			"<leader>lt",
			function()
				require("mini.extra").pickers.lsp({ scope = "type_definition" })
			end,
			desc = "LSP types",
		},
		{
			"<leader>lw",
			function()
				require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
			end,
			desc = "LSP workspace symbols",
		},
	},
	config = true,
}

return M
