-- fg and bg must have this much contrast range 0 < contrast_threshold < 0.5
local contrast_threshold = 0.3
-- how much brightness is changed in percentage for light and dark themes
local brightness_modifier_param = 10

-- turns #rrggbb -> { red, green, blue }
local function rgb_str2num(str)
	if type(str) == "number" then
		str = ("%06x"):format(str)
	end

	if str:find("#") == 1 then
		str = str:sub(2, #str)
	end

	local red = tonumber(str:sub(1, 2), 16)
	local green = tonumber(str:sub(3, 4), 16)
	local blue = tonumber(str:sub(5, 6), 16)

	return { red = red, green = green, blue = blue }
end

-- turns { red, green, blue } -> #rrggbb
local function rgb_num2str(num)
	local str = string.format("#%02x%02x%02x", num.red, num.green, num.blue)
	return str
end

-- returns brightness level of color in range 0 to 1
local function get_color_brightness(rgb)
	local color = rgb_str2num(rgb)
	local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
	return brightness / 256
end

-- returns average of colors in range 0 to 1
-- used to determine contrast level
local function get_color_avg(rgb)
	local color = rgb_str2num(rgb)
	return (color.red + color.green + color.blue) / 3 / 256
end

-- clamps the value between left and right
local function clamp(val, left, right)
	if val > right then
		return right
	end

	if val < left then
		return left
	end

	return val
end

-- changes brightness of rgb by percentage
local function brightness_modifier(rgb, percentage)
	local color = rgb_str2num(rgb)
	color.red = clamp(color.red + (color.red * percentage / 100), 0, 255)
	color.green = clamp(color.green + (color.green * percentage / 100), 0, 255)
	color.blue = clamp(color.blue + (color.blue * percentage / 100), 0, 255)
	return rgb_num2str(color)
end

-- changes contrast of rgb_color by amount
local function contrast_modifier(rgb, amount)
	local color = rgb_str2num(rgb)
	color.red = clamp(color.red + amount, 0, 255)
	color.green = clamp(color.green + amount, 0, 255)
	color.blue = clamp(color.blue + amount, 0, 255)
	return rgb_num2str(color)
end

-- changes brightness of foreground color to achieve contrast
-- without changing the color
local function apply_contrast(hl)
	local hl_bg_avg = get_color_avg(hl.bg)
	local contrast_thresh_cfg = clamp(contrast_threshold, 0, 0.5)
	local contrast_change_step = 5
	if hl_bg_avg > 0.5 then
		contrast_change_step = -contrast_change_step
	end

	-- max 25 iterations should be enough
	local iter_count = 1
	while math.abs(get_color_avg(hl.fg) - hl_bg_avg) < contrast_thresh_cfg and iter_count < 25 do
		hl.fg = contrast_modifier(hl.fg, contrast_change_step)
		iter_count = iter_count + 1
	end
end

-- get colors to generate theme
local function get_colors()
	local colors = {
		normal = KobraColors.utils.extract_color_from_hllist(
			"bg",
			{ "PmenuSel", "PmenuThumb", "TabLineSel" },
			"#000000"
		),
		insert = KobraColors.utils.extract_color_from_hllist("fg", { "String", "MoreMsg" }, "#000000"),
		replace = KobraColors.utils.extract_color_from_hllist("fg", { "Number", "Type" }, "#000000"),
		visual = KobraColors.utils.extract_color_from_hllist("fg", { "Special", "Boolean", "Constant" }, "#000000"),
		command = KobraColors.utils.extract_color_from_hllist("fg", { "Identifier" }, "#000000"),
		terminal = KobraColors.utils.extract_color_from_hllist("fg", { "Function" }, "#000000"),
		inactive = KobraColors.utils.extract_color_from_hllist("fg", { "NonText" }, "#000000"),
		back1 = KobraColors.utils.extract_color_from_hllist("bg", { "Normal", "StatusLineNC" }, "#000000"),
		fore = KobraColors.utils.extract_color_from_hllist("fg", { "Normal", "StatusLine" }, "#000000"),
		back2 = KobraColors.utils.extract_color_from_hllist("bg", { "StatusLine" }, "#000000"),

		bg = KobraColors.utils.extract_color_from_hllist("bg", { "Folded" }, "#000000"),
		fg = KobraColors.utils.extract_color_from_hllist("fg", { "Folded" }, "#000000"),
		red = KobraColors.utils.extract_color_from_hllist("fg", { "DiagnosticError" }, "#c94f6d"),
		dark_red = KobraColors.utils.extract_color_from_hllist("bg", { "DiffDelete" }, "#000000"),
		green = KobraColors.utils.extract_color_from_hllist("fg", { "String" }, "#81b29a"),
		blue = KobraColors.utils.extract_color_from_hllist("fg", { "Function" }, "#719cd6"),
		gray = KobraColors.utils.extract_color_from_hllist("fg", { "NonText" }, "#484848"),
		orange = KobraColors.utils.extract_color_from_hllist("fg", { "Constant" }, "#dbc074"),
		purple = KobraColors.utils.extract_color_from_hllist("fg", { "Statement" }, "#9d79d6"),
		cyan = KobraColors.utils.extract_color_from_hllist("fg", { "Special" }, "#63cdcf"),
		diag_warn = KobraColors.utils.extract_color_from_hllist("fg", { "DiagnosticWarn" }, "#000000"),
		diag_error = KobraColors.utils.extract_color_from_hllist("fg", { "DiagnosticError" }, "#000000"),
		diag_hint = KobraColors.utils.extract_color_from_hllist("fg", { "DiagnosticHint" }, "#000000"),
		diag_info = KobraColors.utils.extract_color_from_hllist("fg", { "DiagnosticInfo" }, "#000000"),
		git_del = KobraColors.utils.extract_color_from_hllist("fg", { "diffDeleted" }, "#000000"),
		git_add = KobraColors.utils.extract_color_from_hllist("fg", { "diffAdded" }, "#000000"),
		git_change = KobraColors.utils.extract_color_from_hllist("fg", { "diffChanged" }, "#000000"),
	}

	-- change brightness of colors
	-- darken if light theme or lighten if dark theme
	local normal_color = KobraColors.utils.extract_highlight_colors("Normal", "bg")
	if normal_color ~= nil then
		if get_color_brightness(normal_color) > 0.5 then
			brightness_modifier_param = -brightness_modifier_param
		end

		for name, color in pairs(colors) do
			colors[name] = brightness_modifier(color, brightness_modifier_param)
		end
	end

	for name, color in pairs(colors) do
		colors[name .. "_bright"] = brightness_modifier(color, 50)
	end

	return colors
end

local M = {}

function M.get_hl_groups()
	local colors = get_colors()
	local groups = {
		normal = {
			a = { bg = colors.normal, fg = colors.back1, bold = true },
			b = { bg = colors.normal_bright, fg = colors.back1 },
			c = { bg = colors.back1, fg = colors.normal },
		},
		insert = {
			a = { bg = colors.insert, fg = colors.back1, bold = true },
			b = { bg = colors.insert_bright, fg = colors.back1 },
			c = { bg = colors.back1, fg = colors.insert },
		},
		replace = {
			a = { bg = colors.replace, fg = colors.back1, bold = true },
			b = { bg = colors.replace_bright, fg = colors.back1 },
			c = { bg = colors.back1, fg = colors.replace },
		},
		visual = {
			a = { bg = colors.visual, fg = colors.back1, bold = true },
			b = { bg = colors.visual_bright, fg = colors.back1 },
			c = { bg = colors.back1, fg = colors.visual },
		},
		command = {
			a = { bg = colors.command, fg = colors.back1, bold = true },
			b = { bg = colors.command_bright, fg = colors.back1 },
			c = { bg = colors.back1, fg = colors.command },
		},
		terminal = {
			a = { bg = colors.terminal, fg = colors.back1, bold = true },
			b = { bg = colors.terminal_bright, fg = colors.back1 },
			c = { bg = colors.back1, fg = colors.terminal },
		},
		inactive = {
			a = { bg = colors.inactive, fg = colors.back1, bold = true },
			b = { bg = colors.inactive_bright, fg = colors.back1 },
			c = { bg = colors.back1, fg = colors.inactive },
		},
	}

	for _, section in pairs(groups) do
		for _, hl in pairs(section) do
			apply_contrast(hl)
		end
	end

	for mode, section in pairs(groups) do
		groups[mode].ab = { bg = section.b.bg, fg = section.a.bg }
		groups[mode].bc = { bg = section.c.bg, fg = section.b.bg }
	end

	return groups
end

return M
