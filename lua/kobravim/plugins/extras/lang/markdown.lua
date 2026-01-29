local M = {}

local function notebook_picker()
	local BW = require("bookwyrm")
	local notebooks = BW.api.get_notebook_list()

	local items = vim.tbl_map(function(nb)
		return {
			text = nb.title .. " \t" .. nb.path,
			nb_id = nb.id,
			title = nb.title,
		}
	end, notebooks)

	require("mini.pick").start({
		source = {
			items = items,
			name = "Notebooks",
			choose = function(item)
				BW.api.select_notebook(item.nb_id)
				vim.notify("Active: " .. item.title)
			end,
		},
	})
end

M[#M + 1] = {
	"KobraKommander9/bookwyrm.nvim",
	dependencies = {
		"kkharji/sqlite.lua",
		"nvim-mini/mini.pick",
		{
			"nvim-mini/mini.clue",
			opts = KobraVim.mini.clue_options({
				{ mode = "n", keys = "<leader>j", desc = "+Journals" },
			}),
		},
	},
	cmd = { "BookwyrmRegister" },
	keys = {
		{ "<leader>js", notebook_picker, desc = "Search notebooks" },
		{ "<leader>jr", "<cmd>BookwyrmRegister<cr>", desc = "Register current dir" },
	},
	config = true,
}

return M
