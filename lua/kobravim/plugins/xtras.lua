local M = {}

if vim.g.vscode then
	M[#M + 1] = {
		import = "kobravim.plugins.extras.vscode",
	}
end

return M
