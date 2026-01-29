local M = {}

local function notebook_picker(cb)
	local notebooks = require("bookwyrm").api.get_notebook_list()

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
			choose = cb,
		},
	})
end

local function delete_notebook()
	notebook_picker(function(item)
		require("bookwyrm").api.delete_notebook(item.nb_id)
	end)
end

local function search_notebooks()
	notebook_picker(function(item)
		require("bookwyrm").api.select_notebook(item.nb_id)
	end)
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
		{ "<leader>jD", delete_notebook, desc = "Delete notebooks" },
		{ "<leader>jR", "<cmd>BookwyrmRegister<cr>", desc = "Register current dir" },
		{ "<leader>jS", search_notebooks, desc = "Search notebooks" },
	},
	config = true,
}

return M
