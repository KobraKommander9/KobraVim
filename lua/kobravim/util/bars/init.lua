local M = {}

M.surrounds = {
	left = { "", "" },
	right = { "", "" },
}

function M.statusline()
	local components = KobraVim.bars.components
	local palette = KobraVim.bars.palette

	return {
		M.surround(M.surrounds.left, palette.get_mode_color, components.mode),
		components.git,
		components.file,

		{ provider = "%=" },

		M.surround(M.surrounds.right, palette.blue, components.ruler),
	}
end

function M.surround(delimiters, color, component)
	color = type(color) == "function" and color() or color

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
