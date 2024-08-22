local M = {}

setmetatable(M, {
	__index = function(t, key)
		t[key] = require("kobra.util.highlights." .. key)
		return t[key]
	end,
})

local links = {
	["@lsp.type.namespace"] = "@namespace",
	["@lsp.type.type"] = "@type",
	["@lsp.type.class"] = "@type",
	["@lsp.type.enum"] = "@type",
	["@lsp.type.interface"] = "@type",
	["@lsp.type.struct"] = "@structure",
	["@lsp.type.parameter"] = "@parameter",
	["@lsp.type.variable"] = "@variable",
	["@lsp.type.property"] = "@property",
	["@lsp.type.enumMember"] = "@constant",
	["@lsp.type.function"] = "@function",
	["@lsp.type.method"] = "@method",
	["@lsp.type.macro"] = "@macro",
	["@lsp.type.decorator"] = "@function",
}

function M.create_hl_groups()
	local generated_colors = {}

	local theme = KobraColors.theme
	for mode, sections in pairs(theme) do
		for section, color in pairs(sections) do
			local name = table.concat({ "kobra", mode, section }, "_")
			generated_colors[name] = color

			color.force = true
			vim.api.nvim_set_hl(0, name, color)
		end
	end

	return generated_colors
end

function M.setup()
	M.create_hl_groups()

	for newgroup, oldgroup in pairs(links) do
		vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
	end

	local group = vim.api.nvim_create_augroup("KobraFormat", { clear = false })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		pattern = "*",
		callback = M.create_hl_groups,
	})

	vim.api.nvim_create_autocmd("OptionSet", {
		group = group,
		pattern = "background",
		callback = M.create_hl_groups,
	})
end

return M
