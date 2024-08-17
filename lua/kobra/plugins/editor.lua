local M = {}

local Keys = require("kobra.core.keys")

-- move text
M[#M + 1] = {
	"echasnovski/mini.move",
	event = "BufEnter",
	dependencies = {
		-- mini clue integration
		{
			"echasnovski/mini.clue",
			opts = function(_, opts)
				local options = {
					clues = {
						{ mode = "n", keys = "<leader>mh", postkeys = "<leader>m", desc = "Move left" },
						{ mode = "n", keys = "<leader>m" .. Keys.l, postkeys = "<leader>m", desc = "Move right" },
						{ mode = "n", keys = "<leader>m" .. Keys.j, postkeys = "<leader>m", desc = "Move down" },
						{ mode = "n", keys = "<leader>m" .. Keys.k, postkeys = "<leader>m", desc = "Move up" },
						{ mode = "x", keys = "<leader>mh", postkeys = "<leader>m", desc = "Move left" },
						{ mode = "x", keys = "<leader>m" .. Keys.l, postkeys = "<leader>m", desc = "Move right" },
						{ mode = "x", keys = "<leader>m" .. Keys.j, postkeys = "<leader>m", desc = "Move down" },
						{ mode = "x", keys = "<leader>m" .. Keys.k, postkeys = "<leader>m", desc = "Move up" },
					},
				}

				return vim.tbl_deep_extend("force", options, opts)
			end,
		},
	},
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
	dependencies = {
		-- mini clue integration
		{
			"echasnovski/mini.clue",
			opts = function(_, opts)
				local clues = {
					{ mode = "n", keys = "]b", postkeys = "]", desc = "next buffer" },
					{ mode = "n", keys = "[b", postkeys = "[", desc = "previous buffer" },
				}

				for _, clue in ipairs(clues) do
					table.insert(opts.clues, clue)
				end
			end,
		},
	},
	config = true,
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
