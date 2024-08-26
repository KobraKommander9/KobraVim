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

				local buffer_mappings = Kobra.config.layout == "colemak"
						and { wipeout = { char = "<C-q>" }, func = wipeout_cur }
					or { wipeout = { char = "<C-d>", func = wipeout_cur } }

				require("mini.pick").builtin.buffers({}, { mappings = buffer_mappings })
			end,
			desc = "Search buffers",
		},

		-- Files
		{ "<leader>fs", Kobra.pick.builtin("files"), desc = "Search files" },

		-- Search
		{ "<leader>sg", Kobra.pick.builtin("grep_live"), desc = "Search (grep live)" },
		{ "<leader>sG", Kobra.pick.builtin("grep"), desc = "Search (grep)" },
		{ "<leader>sH", Kobra.pick.builtin("help"), desc = "Search help tags" },
		{ "<leader>sr", Kobra.pick.builtin("resume"), desc = "Resume search" },
	},
	opts = function(_, opts)
		opts = opts or {}

		local mappings = {}

		if Kobra.config.layout == "colemak" then
			mappings = {
				delete_left = "<C-l>",

				mark = "<C-o>",

				move_up = "<C-e>",

				paste = "<C-p>",

				scroll_down = "<C-d>",
				scroll_right = "<C-i>",
				scroll_up = "<C-u>",
			}
		end

		opts.mappings = opts.mappings or {}
		for key, value in pairs(mappings) do
			opts.mappings[key] = value
		end
	end,
	build = function()
		vim.ui.select = require("mini.pick").ui_select
	end,
}

M[#M + 1] = {
	"echasnovski/mini.extra",
	dependencies = {
		"echasnovski/mini.fuzzy",
		"echasnovski/mini.pick",
	},
	cmd = { "Pick" },
	keys = {
		{ "<leader>sc", Kobra.pick.extra("history", "{ scope = '/' }"), desc = "Search history" },
		{ "<leader>sC", Kobra.pick.extra("history", "{ scope = ':' }"), desc = "Search command history" },
		{ "<leader>sd", Kobra.pick.extra("diagnostic", "{ scope = 'current' }"), desc = "Search diagnostics" },
		{ "<leader>sD", Kobra.pick.extra("diagnostic"), desc = "Search diagnostics (all)" },
		{ "<leader>sm", Kobra.pick.extra("list", "{ scope = 'change' }"), desc = "Search changelist" },
		{ "<leader>sM", Kobra.pick.extra("marks"), desc = "Search marks" },
		{ "<leader>so", Kobra.pick.extra("options"), desc = "Search options" },
		{ "<leader>sq", Kobra.pick.extra("list", "{ scope = 'quickfix' }"), desc = "Search quickfix" },
		{ "<leader>sT", Kobra.pick.extra("treesitter"), desc = "Search treesitter" },
		{ "<leader>sz", Kobra.pick.extra("spellsuggest"), desc = "Search spelling suggestions" },

		-- Buffers
		{ "<leader>bl", Kobra.pick.extra("buf_lines"), desc = "Search buffer lines" },

		-- Files
		{
			"<leader>fS",
			Kobra.pick.extra("explorer", "{ cwd = vim.fn.expand('%:p:h') }"),
			desc = "Search files (explorer)",
		},
		{ "<leader>fo", Kobra.pick.extra("oldfiles"), desc = "Search old files" },

		-- Git
		{ "<leader>gb", Kobra.pick.extra("git_branches"), desc = "Search git branches" },
		{ "<leader>gc", Kobra.pick.extra("git_commits"), desc = "Search git commits" },
		{ "<leader>gf", Kobra.pick.extra("git_files"), desc = "Search git files" },
		{ "<leader>gh", Kobra.pick.extra("git_hunks"), desc = "Search git hunks" },

		-- LSP
		{ "<leader>ld", Kobra.pick.extra("lsp", "{ scope = 'declaration' }"), desc = "Search LSP declarations" },
		{ "<leader>lD", Kobra.pick.extra("lsp", "{ scope = 'definition' }"), desc = "Search LSP definitions" },
		{ "<leader>li", Kobra.pick.extra("lsp", "{ scope = 'implementation' }"), desc = "Search LSP implementations" },
		{ "<leader>lr", Kobra.pick.extra("lsp", "{ scope = 'references' }"), desc = "Search LSP references" },
		{ "<leader>ls", Kobra.pick.extra("lsp", "{ scope = 'document_symbol' }"), desc = "Search LSP symbols" },
		{ "<leader>lt", Kobra.pick.extra("lsp", "{ scope = 'type_definition' }"), desc = "Search LSP types" },
		{
			"<leader>lw",
			Kobra.pick.extra("lsp", "{ scope = 'workspace_symbol' }"),
			desc = "Search LSP workspace symbols",
		},
	},
	config = true,
}

return M
