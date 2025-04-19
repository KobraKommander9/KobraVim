local M = {}

M[#M + 1] = {
	"github/copilot.vim",
	command = "Copilot",
	build = ":Copilot setup",
	config = function()
		vim.cmd('imap <silent><script><expr> <c-t> copilot#Accept("<CR>")')
	end,
}

return M
