local M = {}

local function get_hl(name, attr)
	local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
	local color = hl[attr or "fg"]
	return color and string.format("#%06x", color) or "NONE"
end

local colors = {
	blue = get_hl("Function"),
	bg = get_hl("StatusLine", "bg"),
	bright_bg = get_hl("Folded", "bg"),
	green = get_hl("DiagnosticOk"),
	magenta = get_hl("Statement"),
	orange = get_hl("DiagnosticWarn"),
	red = get_hl("DiagnosticError"),
}

local mode_map = {
	n = colors.blue,
	i = colors.green,
	v = colors.magenta,
	V = colors.magenta,
	["\22"] = colors.magenta,
	c = colors.orange,
	s = colors.orange,
	S = colors.orange,
	["\19"] = colors.orange,
	R = colors.red,
	r = colors.red,
	["!"] = colors.red,
	t = colors.green,
}

for name, hex in pairs(colors) do
	M[name] = hex
end

M.mode_map = mode_map

return M
