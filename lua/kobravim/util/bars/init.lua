local M = {}

M.surrounds = {
	left = { "", "" },
	right = { "", "" },
}

function M.statusline()
	local components = KobraVim.bars.components
	local palette = KobraVim.bars.palette

	return {
		M.surround({ "", "" }, palette.bright_bg, components.mode),

		{ provider = "%=" },

		{
			provider = "",
			hl = { fg = palette.bright_bg, bg = "NONE" },
		},
		{
			provider = "",
			hl = { fg = palette.bright_bg, bg = "NONE" },
		},
	}
end

function M.surround(delimiters, color, component)
	return {
		{
			provider = delimiters[1],
			hl = { fg = color, bg = "NONE" },
		},
		{
			hl = { bg = color, fg = "bright_bg" },
			component,
		},
		{
			provider = delimiters[2],
			hl = { fg = color, bg = "NONE" },
		},
	}
end

return KobraVim.make_package(M, "kobravim.util.bars")
