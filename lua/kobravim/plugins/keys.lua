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
		local keys = KobraVim.keys

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

			-- tabs
			{ mode = "n", keys = "<leader>am" .. keys.j, postkeys = "<leader>am", desc = "Move tab down" },
			{ mode = "n", keys = "<leader>am" .. keys.k, postkeys = "<leader>am", desc = "Move tab up" },

			-- clues
			{ mode = "n", keys = "<leader>a", desc = "+Tabs" },
			{ mode = "n", keys = "<leader>b", desc = "+Buffers" },
			{ mode = "n", keys = "<leader>c", desc = "+Commands" },
			-- { mode = "n", keys = "<leader>d", desc = "+Diagnostics" },
			{ mode = "n", keys = "<leader>f", desc = "+Files" },
			{ mode = "n", keys = "<leader>g", desc = "+Git" },
			-- { mode = "n", keys = "<leader>k", desc = "+Keys" },
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

return M
