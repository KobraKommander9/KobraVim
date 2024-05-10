local M = {}

-- better escape
M[#M + 1] = {
	"max397574/better-escape.nvim",
	event = "InsertEnter",
	opts = {
		mapping = { "jk", "qn" },
	},
}

-- global search and replace
M[#M + 1] = {
	"nvim-pack/nvim-spectre",
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

-- which key
M[#M + 1] = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = { spelling = true },
		defaults = {
			mode = { "n", "v" },
			["g"] = { name = "+goto" },
			["gz"] = { name = "+surround" },
			["]"] = { name = "+next" },
			["["] = { name = "+prev" },
			["<leader>a"] = { name = "+tabs" },
			["<leader>b"] = { name = "+buffer" },
			["<leader>c"] = { name = "+code" },
			["<leader>d"] = { name = "+diagnostics" },
			["<leader>f"] = { name = "+file/find" },
			["<leader>g"] = { name = "+git" },
			["<leader>gh"] = { name = "+hunks" },
			["<leader>l"] = { name = "+lsp" },
			["<leader>q"] = { name = "+quit/session" },
			["<leader>s"] = { name = "+search" },
			["<leader>u"] = { name = "+ui" },
			["<leader>w"] = { name = "+windows" },
			["<leader>x"] = { name = "+quickfix" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
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
				vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
			end

			map("n", "]h", gs.next_hunk, "Next Hunk")
			map("n", "[h", gs.prev_hunk, "Prev Hunk")
			map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
			map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
			map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
			map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
			map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
			map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
			map("n", "<leader>ghb", function()
				gs.blame_line({ full = true })
			end, "Blame Line")
			map("n", "<leader>ghd", gs.diffthis, "Diff This")
			map("n", "<leader>ghD", function()
				gs.diffthis("~")
			end, "Diff This ~")
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
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

-- todo comments
M[#M + 1] = {
	"folke/todo-comments.nvim",
	cmd = { "TodoTelescope" },
	event = { "BufReadPost", "BufNewFile" },
	config = true,
	keys = {
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Next todo comment",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Previous todo comment",
		},
		{ "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
	},
}

-- file navigation
M[#M + 1] = {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "BufReadPost",
	cmd = {
		"Grapple",
		"GrappleCycle",
		"GrapplePopup",
		"GrappleReset",
		"GrappleSelect",
		"GrappleTag",
		"GrappleToggle",
		"GrappleUntag",
	},
	keys = {
		{ "<leader>n", '<cmd>lua require"grapple".cycle_forward()<cr>', desc = "Cycle Forward" },
		{ "<leader>e", '<cmd>lua require"grapple".cycle_backward()<cr>', desc = "Cycle Backward" },
		{ "<leader>i", "<cmd>GrapplePopup tags<cr>", desc = "View Tags" },
		{ "<leader>o", "<cmd>GrappleReset<cr>", desc = "Reset Tags" },
		{ "<leader>h", '<cmd>lua require"grapple".toggle{}<cr>', desc = "Tag" },
	},
	opts = {
		scope = "git_branch",
	},
}

return M
