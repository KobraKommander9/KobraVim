local M = {}

local Keys = require("kobra.core.keys")
local Util = require("kobra.util")

-- next key clues
M[#M + 1] = {
	"echasnovski/mini.clue",
	event = "VeryLazy",
	opts = function(_, opts)
		local miniclue = require("mini.clue")

		local options = {
			triggers = {
				-- Leader triggers
				{ mode = "n", keys = "<Leader>" },
				{ mode = "v", keys = "<Leader>" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- g key
				{ mode = "n", keys = "g" },
				{ mode = "v", keys = "g" },

				-- marks
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "v", keys = "'" },
				{ mode = "v", keys = "`" },

				-- registers
				{ mode = "n", keys = '"' },
				{ mode = "v", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },

				-- window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = "n", keys = "z" },
				{ mode = "v", keys = "z" },

				-- move
				{ mode = "n", keys = "<leader>m" },
				{ mode = "v", keys = "<leader>m" },

				-- brackets
				{ mode = "n", keys = "]" },
				{ mode = "n", keys = "[" },
			},
			clues = {
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

				-- move
				{ mode = "n", keys = "<leader>mh", postkeys = "<leader>m", desc = "Move left" },
				{ mode = "n", keys = "<leader>m" .. Keys.l, postkeys = "<leader>m", desc = "Move right" },
				{ mode = "n", keys = "<leader>m" .. Keys.j, postkeys = "<leader>m", desc = "Move down" },
				{ mode = "n", keys = "<leader>m" .. Keys.k, postkeys = "<leader>m", desc = "Move up" },
				{ mode = "v", keys = "<leader>mh", postkeys = "<leader>m", desc = "Move left" },
				{ mode = "v", keys = "<leader>m" .. Keys.l, postkeys = "<leader>m", desc = "Move right" },
				{ mode = "v", keys = "<leader>m" .. Keys.j, postkeys = "<leader>m", desc = "Move down" },
				{ mode = "v", keys = "<leader>m" .. Keys.k, postkeys = "<leader>m", desc = "Move up" },

				-- brackets
				{ mode = "n", keys = "]b", postkeys = "]", desc = "next buffer" },
				{ mode = "n", keys = "[b", postkeys = "[", desc = "previous buffer" },

				-- clues
				{ mode = "n", keys = "<leader>a", desc = "+Tabs" },
				{ mode = "n", keys = "<leader>d", desc = "+Diagnostics" },
				{ mode = "n", keys = "<leader>u", desc = "+UI" },
				{ mode = "n", keys = "<leader>q", desc = "+Quit" },
			},
		}

		return vim.tbl_extend("force", options, opts)
	end,
}

-- move text
M[#M + 1] = {
	"echasnovski/mini.move",
	event = "BufEnter",
	opts = function(_, opts)
		local options = {
			mappings = {
				left = "<leader>mh",
				right = "<leader>m" .. Keys.l,
				down = "<leader>m" .. Keys.j,
				up = "<leader>m" .. Keys.k,

				line_left = "<leader>mh",
				line_right = "<leader>m" .. Keys.l,
				line_down = "<leader>m" .. Keys.j,
				line_up = "<leader>m" .. Keys.k,
			},
		}

		return vim.tbl_deep_extend("force", options, opts)
	end,
}

-- better bracket jumps
M[#M + 1] = {
	"echasnovski/mini.bracketed",
	event = "BufEnter",
	config = true,
}

-- better escape
M[#M + 1] = {
	"max397574/better-escape.nvim",
	event = "InsertEnter",
	opts = {
		default_mappings = true,
		mappings = {
			i = {
				q = {
					o = "<Esc>",
				},
			},
			c = {
				q = {
					o = "<Esc>",
				},
			},
			t = {
				q = {
					o = "<Esc>",
				},
			},
			v = {
				q = {
					o = "<Esc>",
				},
			},
			s = {
				q = {
					o = "<Esc>",
				},
			},
		},
	},
}

-- global search and replace
M[#M + 1] = {
	"nvim-pack/nvim-spectre",
	cmd = { "Spectre" },
	keys = {
		{
			"<leader>sr",
			function()
				require("spectre").open()
			end,
			desc = "Replace in files (Spectre)",
		},
	},
	config = true,
}

-- easily jump to any location and enhanced f/t motions for leap
M[#M + 1] = {
	"ggandor/flit.nvim",
	keys = function()
		local ret = {}
		for _, key in ipairs({ "f", "F", "t", "T" }) do
			ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
		end
		return ret
	end,
	opts = { labeled_modes = "nx" },
}

M[#M + 1] = {
	"ggandor/leap.nvim",
	keys = {
		{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
		{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
		{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
	},
	config = function(_, opts)
		local leap = require("leap")
		for k, v in pairs(opts) do
			leap.opts[k] = v
		end

		leap.add_default_mappings(true)
		vim.keymap.del({ "x", "o" }, "x")
		vim.keymap.del({ "x", "o" }, "X")
	end,
}

-- file changes
M[#M + 1] = {
	"echasnovski/mini.diff",
	event = "BufReadPre",
	opts = {
		style = "sign",
		signs = { add = "▎", change = "▎", delete = "" },
	},
}

-- references
M[#M + 1] = {
	"RRethy/vim-illuminate",
	event = { "BufReadPost", "BufNewFile" },
	opts = { delay = 200 },
	config = function(_, opts)
		require("illuminate").configure(opts)

		local function map(key, dir, buffer)
			vim.keymap.set("n", key, function()
				require("illuminate")["goto_" .. dir .. "_reference"](false)
			end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
		end

		map("]]", "next")
		map("[[", "prev")

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				local buffer = vim.api.nvim_get_current_buf()
				map("]]", "next", buffer)
				map("[[", "prev", buffer)
			end,
		})
	end,
	keys = {
		{ "]]", desc = "Next Reference" },
		{ "[[", desc = "Prev Reference" },
	},
}

return M
