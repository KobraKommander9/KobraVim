if not vim.g.vscode then
	return {}
end

local enabled = {
	"KobraVim",
	"lazy.nvim",
	"nvim-treesitter",
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
		vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
		vim.keymap.set("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
		vim.keymap.set("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])

		-- Keep undo/redo lists in sync with VsCode
		vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
		vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")

		-- Navigate VSCode tabs like lazyvim buffers
		-- vim.keymap.set("n", "<S-h>", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
		-- vim.keymap.set("n", "<S-l>", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
	end,
})

return {
	{
		"KobraKommander9/KobraVim",
		config = function(_, opts)
			opts = opts or {}
			-- disable the colorscheme
			-- opts.colorscheme = function() end
			require("kobravim").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { highlight = { enable = false } },
	},
}
