local M = {}

function M.extract_highlight_colors(color_group, scope)
	if vim.fn.hlexists(color_group) == 0 then
		return nil
	end

	local color = vim.api.nvim_get_hl(0, { name = color_group })
	if color.background ~= nil then
		color.bg = string.format("#%06x", color.background)
		color.background = nil
	end

	if color.foreground ~= nil then
		color.fg = string.format("#%06x", color.foreground)
		color.foreground = nil
	end

	if color.special ~= nil then
		color.sp = string.format("#%06x", color.special)
		color.special = nil
	end

	vim.notify((scope or "none") .. ": " .. vim.inspect(color))
	if scope then
		return color[scope]
	end

	return color
end

function M.extract_color_from_hllist(scope, syntaxlist, default)
	scope = type(scope) == "string" and { scope } or scope
	for _, hl_name in ipairs(syntaxlist) do
		if vim.fn.hlexists(hl_name) ~= 0 then
			local color = M.extract_highlight_colors(hl_name)
			if color ~= nil then
				for _, sc in ipairs(scope) do
					if color.reverse then
						if sc == "bg" then
							sc = "fg"
						else
							sc = "bg"
						end
					end

					vim.notify("1: " .. sc .. ": " .. vim.inspect(color[sc]))
					if color[sc] then
						return color[sc]
					end
				end
			end
		end
	end

	return default
end

return M
