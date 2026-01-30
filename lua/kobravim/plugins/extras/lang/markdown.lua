local M = {}

local function notebook_picker(cb)
	local notebooks = require("bookwyrm").api.list_notebooks()

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
		require("bookwyrm").api.unregister_notebook({
			delete = true,
			id = item.nb_id,
		})
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
		require("bookwyrm").api.switch_to_notebook(item.nb_id)
		vim.notify("Active: " .. item.title)
	end)
end

local function create_note()
	vim.ui.input({
		prompt = "Enter Note Title: ",
	}, function(title)
		if title and title ~= "" then
			require("bookwyrm").api.create_note(title, { open = "split" })
		end
	end)
end

local function search_notes()
	local notes = require("bookwyrm").api.list_notes()

	vim.ui.select(notes, {
		prompt = "Notes",
		format_item = function(item)
			return item.title
		end,
	}, function(choice)
		if choice then
			vim.cmd("edit " .. vim.fn.fnameescape(choice.path))
		end
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
	cmd = {
		"BookwyrmNoteCreate",
		"BookwyrmNotebookRegister",
		"BookwyrmNotebookRename",
		"BookwyrmNotebookSetDefault",
	},
	keys = {
		-- registry
		{ "<leader>jrd", "<cmd>BookwyrmNotebookSetDefault<cr>", desc = "Set active default" },
		{ "<leader>jrD", delete_notebook, desc = "Delete notebooks" },
		{ "<leader>jrN", register_notebook, desc = "Register notebook" },
		{ "<leader>jrn", "<cmd>BookwyrmNotebookRegister<cr>", desc = "Register current dir" },
		{ "<leader>jrr", "<cmd>BookwyrmNotebookRename<cr>", desc = "Rename active notebook" },
		{ "<leader>jrs", search_notebooks, desc = "Search notebooks" },

		-- notebook
		{ "<leader>jn", create_note, desc = "Create note" },
		{ "<leader>js", search_notes, desc = "Search notes" },
	},
	event = "VeryLazy",
	config = true,
}

return M
