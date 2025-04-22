local M = {}

if true then
	return {}
end

M[#M + 1] = {
	"rktjmp/lush.nvim",
	cmd = { "Lushify", "LushImport", "LushRunTutorial" },
}

M[#M + 1] = {
	"KobraKommander9/autumn.nvim",
	branch = "colorscheme",
	lazy = true,
	dependencies = { "rktjmp/lush.nvim" },
	opts = function()
		return {
			transparency = {
				enabled = KobraVim.config.ui.transparent,
			},
		}
	end,
}

return M
