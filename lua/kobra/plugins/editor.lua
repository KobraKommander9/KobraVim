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

				-- move
				{ mode = "n", keys = "<leader>m" },
				{ mode = "x", keys = "<leader>m" },

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
				{ mode = "x", keys = "<leader>mh", postkeys = "<leader>m", desc = "Move left" },
				{ mode = "x", keys = "<leader>m" .. Keys.l, postkeys = "<leader>m", desc = "Move right" },
				{ mode = "x", keys = "<leader>m" .. Keys.j, postkeys = "<leader>m", desc = "Move down" },
				{ mode = "x", keys = "<leader>m" .. Keys.k, postkeys = "<leader>m", desc = "Move up" },

				-- brackets
				{ mode = "n", keys = "]b", postkeys = "]", desc = "next buffer" },
				{ mode = "n", keys = "[b", postkeys = "[", desc = "previous buffer" },

				-- clues
				{ mode = "n", keys = "<leader>a", desc = "+Tabs" },
				{ mode = "n", keys = "<leader>d", desc = "+Diagnostics" },
				{ mode = "n", keys = "<leader>h", desc = "+Git Hunks" },
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
					n = "<Esc>",
				},
			},
			c = {
				q = {
					n = "<Esc>",
				},
			},
			t = {
				q = {
					n = "<Esc>",
				},
			},
			v = {
				q = {
					n = "<Esc>",
				},
			},
			s = {
				q = {
					n = "<Esc>",
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

-- git signs
M[#M + 1] = {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				Util.keymap(mode, l, r, { buffer = buffer, desc = desc })
			end

			map("n", "]h", gs.nav_hunk("next"), "Next Hunk")
			map("n", "[h", gs.nav_hunk("prev"), "Prev Hunk")

			map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage Hunk")
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset Hunk")
			map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
			map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
			map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
			map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, "Blame Line")
			map("n", "<leader>htb", gs.toggle_current_line_blame, "Toggle Blame Line")
			map("n", "<leader>hd", gs.diffthis, "Diff This")
			map("n", "<leader>hD", function()
				gs.diffthis("~")
			end, "Diff This ~")
			map("n", "<leader>htd", gs.toggle_deleted, "Toggle Deleted")
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")

			Util.ensure_keys()
		end,
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
