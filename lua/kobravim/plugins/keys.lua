local M = {}

M[#M + 1] = {
	"KobraKommander9/escapist",
	event = "VeryLazy",
	opts = function()
		if not KobraVim.keys.esc then
			return {}
		end

		return {
			keys = { KobraVim.keys.esc },
		}
	end,
}

-- next key clues
M[#M + 1] = {
	"echasnovski/mini.clue",
	event = "VeryLazy",
	opts = KobraVim.mini.clue_options(function()
		local miniclue = require("mini.clue")

		return {
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows({
				submode_move = true,
				submode_navigate = true,
				submode_resize = true,
			}),
			miniclue.gen_clues.z(),

			-- clues
			{ mode = "n", keys = "<leader>a", desc = "+Tabs" },
			{ mode = "n", keys = "<leader>am", desc = "+Move" },
			{ mode = "n", keys = "<leader>b", desc = "+Buffers" },
			{ mode = "n", keys = "<leader>c", desc = "+Commands" },
			{ mode = "n", keys = "<leader>f", desc = "+Files" },
			{ mode = "n", keys = "<leader>g", desc = "+Git" },
			{ mode = "n", keys = "<leader>l", desc = "+LSP" },
			{ mode = "n", keys = "<leader>u", desc = "+UI" },
			{ mode = "n", keys = "<leader>q", desc = "+Quit" },
			{ mode = "n", keys = "<leader>s", desc = "+Search" },
			{ mode = "n", keys = "<leader>w", desc = "+Windows" },
			{ mode = "n", keys = "<leader>x", desc = "+Lists" },
		}
	end, {
		-- Leader triggers
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },

		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },

		-- g key
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },

		-- marks
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },

		-- registers
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },

		-- window commands
		{ mode = "n", keys = "<C-w>" },

		-- `z` key
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },

		-- brackets
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "[" },
	}),
}

-- easily jump to any location
M[#M + 1] = {
	"folke/flash.nvim",
	keys = {
		{
			"<cr>",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"<c-c>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}

-- better bracket jumps
M[#M + 1] = {
	"echasnovski/mini.bracketed",
	event = "BufEnter",
	dependencies = {
		{
			"echasnovski/mini.clue",
			opts = KobraVim.mini.clue_options({
				{ mode = "n", keys = "]b", postkeys = "]", desc = "next bracket" },
				{ mode = "n", keys = "[b", postkeys = "[", desc = "previous bracket" },
			}),
		},
	},
	config = true,
}

return M
