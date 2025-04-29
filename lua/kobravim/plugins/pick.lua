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

				require("mini.pick").builtin.buffers({}, {
					mappings = {
						wipeout = {
							char = KobraVim.keys.pick.clearSearch,
						},
						func = wipeout_cur,
					},
				})
			end,
			desc = "Search buffers",
		},

		-- Files
		{ "<leader>fs", KobraVim.pick.builtin("files"), desc = "Search files" },

		-- Search
		{ "<leader>sg", KobraVim.pick.builtin("grep_live"), desc = "Search (grep live)" },
		{ "<leader>sG", KobraVim.pick.builtin("grep"), desc = "Search (grep)" },
		{ "<leader>sH", KobraVim.pick.builtin("help"), desc = "Search help tags" },
		{ "<leader>sR", KobraVim.pick.builtin("resume"), desc = "Resume search" },
	},
	opts = function(_, opts)
		opts = opts or {}
		opts.mappings = opts.mappings or {}

		if KobraVim.keys.pick then
			for key, value in pairs(KobraVim.keys.pick) do
				opts.mappings[key] = value
			end
		end

		return opts
	end,
	build = function()
		vim.ui.select = require("mini.pick").ui_select
	end,
}

M[#M + 1] = {
	"echasnovski/mini.extra",
	dependencies = {
		"echasnovski/mini.pick",
	},
	cmd = { "Pick" },
	keys = {
		{ "<leader>sc", KobraVim.pick.extra("history", "{ scope = '/' }"), desc = "Search history" },
		{ "<leader>sC", KobraVim.pick.extra("history", "{ scope = ':' }"), desc = "Search command history" },
		{ "<leader>sd", KobraVim.pick.extra("diagnostic", "{ scope = 'current' }"), desc = "Search diagnostics" },
		{ "<leader>sD", KobraVim.pick.extra("diagnostic"), desc = "Search diagnostics (all)" },
		{ "<leader>sm", KobraVim.pick.extra("list", "{ scope = 'change' }"), desc = "Search changelist" },
		{ "<leader>sM", KobraVim.pick.extra("marks"), desc = "Search marks" },
		{ "<leader>so", KobraVim.pick.extra("options"), desc = "Search options" },
		{ "<leader>sq", KobraVim.pick.extra("list", "{ scope = 'quickfix' }"), desc = "Search quickfix" },
		{ "<leader>sT", KobraVim.pick.extra("treesitter"), desc = "Search treesitter" },
		{ "<leader>sz", KobraVim.pick.extra("spellsuggest"), desc = "Search spelling suggestions" },

		-- Buffers
		{ "<leader>bl", KobraVim.pick.extra("buf_lines"), desc = "Search buffer lines" },

		-- Files
		{
			"<leader>fS",
			KobraVim.pick.extra("explorer", "{ cwd = vim.fn.expand('%:p:h') }"),
			desc = "Search files (explorer)",
		},
		{ "<leader>fo", KobraVim.pick.extra("oldfiles"), desc = "Search old files" },

		-- Git
		{ "<leader>gb", KobraVim.pick.extra("git_branches"), desc = "Search git branches" },
		{ "<leader>gc", KobraVim.pick.extra("git_commits"), desc = "Search git commits" },
		{ "<leader>gf", KobraVim.pick.extra("git_files"), desc = "Search git files" },
		{ "<leader>gh", KobraVim.pick.extra("git_hunks"), desc = "Search git hunks" },

		-- LSP
		{ "<leader>ld", KobraVim.pick.extra("lsp", "{ scope = 'declaration' }"), desc = "Search LSP declarations" },
		{ "<leader>lD", KobraVim.pick.extra("lsp", "{ scope = 'definition' }"), desc = "Search LSP definitions" },
		{
			"<leader>li",
			KobraVim.pick.extra("lsp", "{ scope = 'implementation' }"),
			desc = "Search LSP implementations",
		},
		{ "<leader>lr", KobraVim.pick.extra("lsp", "{ scope = 'references' }"), desc = "Search LSP references" },
		{ "<leader>ls", KobraVim.pick.extra("lsp", "{ scope = 'document_symbol' }"), desc = "Search LSP symbols" },
		{ "<leader>lt", KobraVim.pick.extra("lsp", "{ scope = 'type_definition' }"), desc = "Search LSP types" },
		{
			"<leader>lw",
			KobraVim.pick.extra("lsp", "{ scope = 'workspace_symbol' }"),
			desc = "Search LSP workspace symbols",
		},
	},
	config = true,
}

return M
