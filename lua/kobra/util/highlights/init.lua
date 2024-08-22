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

local generated_colors = {}

function M.get_hl_group(name)
	return generated_colors[name] or vim.api.nvim_get_hl(0, { name = name })
end

function M.create_hl_groups()
	generated_colors = {}

	local theme = KobraColors.theme.get_hl_groups()
	for mode, sections in pairs(theme) do
		for section, color in pairs(sections) do
			color.force = true

			local name = table.concat({ "kobra", mode, section }, "_")
			local name_rv = name .. "_rv"
			generated_colors[name] = color
			generated_colors[name_rv] = vim.tbl_extend("force", color, {
				fg = color.bg,
				bg = color.fg,
			})

			vim.api.nvim_set_hl(0, name, generated_colors[name])
			vim.api.nvim_set_hl(0, name_rv, generated_colors[name_rv])
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
