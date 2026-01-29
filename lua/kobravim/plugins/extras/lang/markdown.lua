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

local function register_notebook()
	vim.ui.input({
		prompt = "Enter Notebook Path: ",
		default = vim.fn.getcwd(),
	}, function(path)
		if not path then
			return
		end

		vim.ui.input({
			prompt = "Enter Notebook Title: ",
			default = vim.fn.fnamemodify(path, ":t"),
		}, function(title)
			if title then
				require("bookwyrm").api.register_notebook({ path = path, title = title })
			end
		end)
	end)
end

local function search_notebooks()
	notebook_picker(function(item)
		require("bookwyrm").api.select_notebook(item.nb_id)
		vim.notify("Active: " .. item.title)
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
				{ mode = "n", keys = "<leader>jr", desc = "+Registry" },
			}),
		},
	},
	cmd = { "BookwyrmNotebookRegister", "BookwyrmNotebookRename", "BookwyrmNotebookSetDefault" },
	keys = {
		{ "<leader>jrd", "<cmd>BookwyrmNotebookSetDefault<cr>", desc = "Set active default" },
		{ "<leader>jrD", delete_notebook, desc = "Delete notebooks" },
		{ "<leader>jrN", register_notebook, desc = "Register notebook" },
		{ "<leader>jrn", "<cmd>BookwyrmNotebookRegister<cr>", desc = "Register current dir" },
		{ "<leader>jrr", "<cmd>BookwyrmNotebookRename<cr>", desc = "Rename active notebook" },
		{ "<leader>jrs", search_notebooks, desc = "Search notebooks" },
	},
	config = true,
}

return M
