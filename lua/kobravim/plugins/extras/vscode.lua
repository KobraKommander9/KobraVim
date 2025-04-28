if not vim.g.vscode then
	return {}
end

local enabled = {
	"KobraVim",
	"flash.nvim",
	"lazy.nvim",
	"mini.ai",
	"mini.bracketed",
	"mini.comment",
	"mini.pairs",
	"nvim-treesitter",
	"nvim-treesitter-textobjects",
	"nvim-ts-autotag",
	"ts-comments.nvim",
	"vim-repeat",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
	return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
	pattern = "KobraVimKeymapsDefaults",
	callback = function()
		-- VSCode-specific keymaps for search and navigation
		vim.keymap.set("n", "<leader>/", "<cmd>Find<cr>")
		vim.keymap.set("n", "<leader>f", [[<cmd>lua require('vscode').action('workbench.action.find')<cr>]])
		vim.keymap.set("n", "<leader>F", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
		vim.keymap.set("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])

		-- Keep undo/redo lists in sync with VsCode
		vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
		vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")

		-- Navigate VSCode tabs
		-- vim.keymap.set("n", "<leader>ac", "<Cmd>call VSCodeNotify('workbench.action.closeEditor')<CR>")
		-- vim.keymap.set("n", "<leader>af", "<Cmd>call VSCodeNotify('workbench.action.openFirstEditorInGroup')<CR>")
		-- vim.keymap.set("n", "<leader>al", "<Cmd>call VSCodeNotify('workbench.action.openLastEditorInGroup')<CR>")
		-- vim.keymap.set("n", "<leader>an", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
		-- vim.keymap.set("n", "<leader>ap", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
		-- vim.keymap.set(
		-- 	"n",
		-- 	"<leader>am" .. KobraVim.keys.j,
		-- 	"<Cmd>call VSCodeNotify('workbench.action.moveEditorLeft')<CR>"
		-- )
		-- vim.keymap.set(
		-- 	"n",
		-- 	"<leader>am" .. KobraVim.keys.k,
		-- 	"<Cmd>call VSCodeNotify('workbench.action.moveEditorRight')<CR>"
		-- )

		-- Navigate VSCode editor groups
		-- vim.keymap.set(
		-- 	{ "n", "x" },
		-- 	"<C-" .. KobraVim.keys.j .. ">",
		-- 	"<Cmd>call VSCodeNotify('workbench.action.navigateDown')"
		-- )
		-- vim.keymap.set(
		-- 	{ "n", "x" },
		-- 	"<C-" .. KobraVim.keys.k .. ">",
		-- 	"<Cmd>call VSCodeNotify('workbench.action.navigateUp')"
		-- )
		-- vim.keymap.set({ "n", "x" }, "<C-h>", "<Cmd>call VSCodeNotify('workbench.action.navigateLeft')")
		-- vim.keymap.set(
		-- 	{ "n", "x" },
		-- 	"<C-" .. KobraVim.keys.l .. ">",
		-- 	"<Cmd>call VSCodeNotify('workbench.action.navigateRight')"
		-- )
	end,
})

return {
	{
		"KobraKommander9/KobraVim",
		config = function(_, opts)
			opts = opts or {}
			-- disable the colorscheme
			opts.ui = opts.ui or {}
			opts.ui.colorscheme = function() end
			require("kobravim").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { highlight = { enable = false } },
	},
}
