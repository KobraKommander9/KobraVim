local M = {}

local function get_hl(name, attr)
	local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if ok then
		return string.format("#%06x", h[attr or "fg"])
	end
end

local colors = {
	bg = get_hl("StatusLine", "bg") or "NONE",
	bright_bg = get_hl("Folded", "bg") or "NONE",

	active = get_hl("Function") or get_hl("Identifier") or "NONE",
	danger = get_hl("Error") or get_hl("DiagnosticError") or "NONE",
	directive = get_hl("Keyword") or get_hl("Statement") or "NONE",
	literal = get_hl("String") or get_hl("Constant") or "NONE",
	number = get_hl("Number") or "NONE",
	special = get_hl("Special") or "NONE",
	type = get_hl("Type") or get_hl("Keyword") or "NONE",
}

local mode_map = {
	n = colors.active,
	i = colors.literal,
	v = colors.type,
	V = colors.type,
	["\22"] = colors.type,
	c = colors.directive,
	s = colors.special,
	S = colors.special,
	["\19"] = colors.special,
	R = colors.danger,
	r = colors.danger,
	["!"] = colors.danger,
	t = colors.number,
}

for name, hex in pairs(colors) do
	M[name] = hex
end

M.get_hl = get_hl
M.mode_map = mode_map

function M.get_mode_color()
	local mode = vim.fn.mode(1):sub(1, 1)
	return M.mode_map[mode] or M.blue
end

return M
