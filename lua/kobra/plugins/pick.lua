local M = {}

local Core = require("kobra.core")

M[#M + 1] = {
	"echasnovski/mini.pick",
	cmd = { "Pick" },
	keys = {
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
		{
			"<leader>ph",
			function()
				require("mini.pick").builtin.help()
			end,
			desc = "Pick help tags",
		},
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

				mark = "<C-m>",

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

return M
