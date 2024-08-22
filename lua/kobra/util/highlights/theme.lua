-- fg and bg must have this much contrast range 0 < contrast_threshold < 0.5
local contrast_threshold = 0.3
-- how much brightness is changed in percentage for light and dark themes
local brightness_modifier_param = 10

-- turns #rrggbb -> { red, green, blue }
local function rgb_str2num(str)
	if type(str) == "number" then
		str = ("%06x"):format(str)
  elseif str == nil then
    return { red = 0, green = 0, blue = 0 }
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
		-- normal = KobraColors.utils.extract_color_from_hllist(
		-- 	"bg",
		-- 	{ "PmenuSel", "PmenuThumb", "TabLineSel" },
		-- 	"#000000"
		-- ),
    normal = KobraColors.utils.extract_color_from_hllist("fg", { "Constant" }, "#000000"),
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
  end

	for name, color in pairs(colors) do
    if normal_color ~= nil then
		  colors[name] = brightness_modifier(color, brightness_modifier_param)
    end

    for _, brightness in ipairs({ 25, 50, 75 }) do
      colors[name .. "_" .. brightness] = brightness_modifier(color, brightness)
    end
	end

	return colors
end

local M = {}

function M.get_hl_groups()
	local colors = get_colors()
	local groups = {
		default = {
			bg = { bg = colors.bg, fg = colors.back2 },
			fg = { bg = colors.fg, fg = colors.back2 },
			red = { bg = colors.red, fg = colors.back2 },
			dark_red = { bg = colors.dark_red, fg = colors.back2 },
			green = { bg = colors.green, fg = colors.back2 },
			blue = { bg = colors.blue, fg = colors.back2 },
			gray = { bg = colors.gray, fg = colors.back2 },
			orange = { bg = colors.orange, fg = colors.back2 },
			purple = { bg = colors.purple, fg = colors.back2 },
			cyan = { bg = colors.cyan, fg = colors.back2 },
			diag_warn = { bg = colors.diag_warn, fg = colors.back2 },
			diag_error = { bg = colors.diag_error, fg = colors.back2 },
			diag_hint = { bg = colors.diag_hint, fg = colors.back2 },
			diag_info = { bg = colors.diag_info, fg = colors.back2 },
			git_del = { bg = colors.git_del, fg = colors.back2 },
			git_add = { bg = colors.git_add, fg = colors.back2 },
			git_change = { bg = colors.git_change, fg = colors.back2 },
		},
		normal = {
			a = { bg = colors.normal, fg = colors.back2 },
			b = { bg = colors.normal_25, fg = colors.back2 },
			c = { bg = colors.normal_50, fg = colors.back2 },
			d = { bg = colors.normal_75, fg = colors.back2 },
		},
		insert = {
      a = { bg = colors.insert, fg = colors.back2 },
      b = { bg = colors.insert_25, fg = colors.back2 },
      c = { bg = colors.insert_50, fg = colors.back2 },
      d = { bg = colors.insert_75, fg = colors.back2 },
		},
		replace = {
      a = { bg = colors.replace, fg = colors.back2 },
      b = { bg = colors.replace_25, fg = colors.back2 },
      c = { bg = colors.replace_50, fg = colors.back2 },
      d = { bg = colors.replace_75, fg = colors.back2 },
		},
		visual = {
      a = { bg = colors.visual, fg = colors.back2 },
      b = { bg = colors.visual_25, fg = colors.back2 },
      c = { bg = colors.visual_50, fg = colors.back2 },
      d = { bg = colors.visual_75, fg = colors.back2 },
		},
		command = {
      a = { bg = colors.command, fg = colors.back2 },
      b = { bg = colors.command_25, fg = colors.back2 },
      c = { bg = colors.command_50, fg = colors.back2 },
      d = { bg = colors.command_75, fg = colors.back2 },
		},
		terminal = {
      a = { bg = colors.terminal, fg = colors.back2 },
      b = { bg = colors.terminal_25, fg = colors.back2 },
      c = { bg = colors.terminal_50, fg = colors.back2 },
      d = { bg = colors.terminal_75, fg = colors.back2 },
		},
		inactive = {
			a = { bg = colors.inactive, fg = colors.back2 },
      b = { bg = colors.inactive_25, fg = colors.back2 },
      c = { bg = colors.inactive_50, fg = colors.back2 },
      d = { bg = colors.inactive_75, fg = colors.back2 },
		},
	}

  for _, section in pairs(groups) do
    for _, hl in pairs(section) do
      apply_contrast(hl)
    end
  end

	for mode, section in pairs(groups) do
    if mode == "default" then
      goto continue
    end

		groups[mode].ab = { bg = section.b.bg, fg = section.a.bg }
		groups[mode].bc = { bg = section.c.bg, fg = section.b.bg }
    groups[mode].cd = { bg = section.d.bg, fg = section.c.bg }

    ::continue::
	end

	return groups
end

return M
