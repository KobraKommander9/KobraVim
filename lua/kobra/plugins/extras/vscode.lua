if not vim.g.vscode then
	return {}
end

local layouts = require("kobra.core").layouts

local enabled = {
	"KobraVim",
	"flit.nvim",
	"lazy.nvim",
	"leap.nvim",
	"mini.ai",
	"mini.comment",
	"mini.pairs",
	"mini.surround",
	"nvim-treesitter",
	"nvim-treesitter-textobjects",
	"nvim-ts-context-commentstring",
	"vim-repeat",
}

local keys = {
	j = "j",
	k = "k",
	l = "l",
	n = "n",
	N = "N",
	e = "e",
	i = "i",
}

if layouts.colemak then
	keys.j = "n"
	keys.k = "e"
	keys.l = "i"
	keys.n = "j"
	keys.N = "J"
	keys.e = "k"
	keys.i = "l"
end

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
	return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

vim.api.nvim_create_autocmd("User", {
	pattern = "KobraVimKeymapsDefault",
	callback = function()
		-- Keep undo/redo lists in sync with VSCode
		vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
		vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")

		-- Navigate VSCode tabs like buffers
		vim.keymap.set("n", "<S-h>", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
		vim.keymap.set("n", "<S-" + keys.l + ">", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
	end,
})

return {
	{
		"KobraKommander9/KobraVim",
		config = function(_, opts)
			opts = opts or {}
			-- disable colorscheme
			opts.colorscheme = function() end
			require("kobra").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = {
				enable = false,
			},
		},
	},
}
