local M = {}

M[#M + 1] = {
	"KobraKommander9/autumn.nvim",
	branch = "colorscheme",
	lazy = true,
	opts = function()
		return {
			transparency = {
				enabled = KobraVim.config.ui.transparent,
			},
		}
	end,
}

return M
