local extras = {}

if vim.g.vscode then
	table.insert(extras, 1, "kobra.plugins.extras.vscode")
end

return vim.tbl_map(function(extra)
	return { import = extra }
end, extras)
