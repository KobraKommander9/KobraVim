local M = {}

M[#M + 1] = {
	"xiyaowong/transparent.nvim",
	lazy = false,
	cond = require("kobra.core").ui.background == "transparent",
}

M[#M + 1] = {
	"echasnovski/mini.notify",
	opts = {
		lsp_progress = {
			enable = false,
		},
	},
	init = function()
		-- when noice is not enabled, install notify on VeryLazy
		if not KobraVim.has("noice.nvim") then
			KobraVim.on_very_lazy(function()
				vim.notify = require("mini.notify").make_notify()
			end)
		end
	end,
}

return M
