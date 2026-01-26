local M = {}

local function get_hl(name, attr)
	local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if ok and h[attr or "fg"] then
		return string.format("#%06x", h[attr or "fg"])
	end
end

function M.build()
	local has_vr, vr = pcall(require, "vintage-rose")
	if not has_vr then
		return {
			bg = get_hl("StatusLine", "bg") or "NONE",
			bg_bright = get_hl("Folded", "bg") or "NONE",

			func = get_hl("Function") or "NONE",
			key = get_hl("Keyword") or "NONE",
			module = get_hl("WarningMsg") or "NONE",
			number = get_hl("Number") or "NONE",
			preproc = get_hl("PreProc") or "NONE",
			regex = get_hl("Special") or "NONE",
			string = get_hl("String") or "NONE",

			added = get_hl("DiffAdd") or "NONE",
			changed = get_hl("DiffChange") or "NONE",
			removed = get_hl("DiffDelete") or "NONE",

			error = get_hl("DiagnosticError") or "NONE",
			warn = get_hl("DiagnosticWarn") or "NONE",
			info = get_hl("DiagnosticInfo") or "NONE",
			hint = get_hl("DiagnosticHint") or "NONE",
			ok = get_hl("DiagnosticOk") or "NONE",
		}
	end

	local roles = vr.get_palette()

	return {
		bg = roles.ui.bg.alt,
		bg_bright = roles.ui.bg.visual,

		func = roles.syntax.func.fg,
		key = roles.syntax.keyword.fg,
		module = roles.syntax.module.fg,
		number = roles.syntax.number.fg,
		preproc = roles.syntax.preproc.fg,
		regex = roles.syntax.regex.fg,
		string = roles.syntax.string.fg,

		added = roles.semantic.added.fg,
		changed = roles.semantic.changed.fg,
		removed = roles.semantic.removed.fg,

		error = roles.semantic.error.fg,
		warn = roles.semantic.warn.fg,
		info = roles.semantic.info.fg,
		hint = roles.semantic.hint.fg,
		ok = roles.semantic.ok.fg,
	}
end

local mode_map = {
	n = "key",
	i = "func",
	V = "string",
	v = "string",
	["\22"] = "string",
	c = "number",
	S = "module",
	s = "module",
	["\19"] = "module",
	R = "regex",
	r = "regex",
	["!"] = "regex",
	t = "preproc",
}

function M.get_mode_color()
	return mode_map[vim.fn.mode(1):sub(1, 1)] or "key"
end

return M
