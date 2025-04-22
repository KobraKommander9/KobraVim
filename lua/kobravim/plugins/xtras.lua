local M = {}

if true then
	return {}
end

if vim.g.vscode then
	table.insert(M, {
		import = "kobravim.plugins.extras.vscode",
	})
end

return M
