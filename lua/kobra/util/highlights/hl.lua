local M = {}

local modes = Kobra.mode.abbrs

local loaded_highlights = {}

local mode_to_highlight = {
	[modes.visual] = "_visual",
	[modes.visual_line] = "_visual",
	[modes.visual_block] = "_visual",
	[modes.select] = "_visual",
	[modes.select_line] = "_visual",
	[modes.select_block] = "_visual",
	[modes.replace] = "_replace",
	[modes.replace_visual] = "_replace",
	[modes.insert] = "_insert",
	[modes.command] = "_command",
	[modes.execute] = "_command",
	[modes.more] = "_command",
	[modes.confirm] = "_command",
	[modes.shell] = "_terminal",
	[modes.terminal] = "_terminal",
}

function M.get_mode_suffix()
	local mode = Kobra.mode.get_mode()
	return mode_to_highlight[mode] or "_normal"
end

function M.get_theme()
	return loaded_highlights
end

function M.highlight_exists(hl_name)
	return loaded_highlights[hl_name] or false
end

-- local function clear_highlights()
-- 	for hl_name, _ in pairs(loaded_highlights) do
-- 		vim.cmd("highlight clear " .. hl_name)
-- 	end
-- 	loaded_highlights = {}
-- end

function M.get_kobra_hl(name)
	local hl = loaded_highlights[name]
	if hl and not hl.empty then
		if hl.link then
			return KobraColors.utils.extract_highlight_colors(hl.link)
		end

		local hl_def = {
			fg = hl.fg ~= "None" and vim.deepcopy(hl.fg) or nil,
			bg = hl.bg ~= "None" and vim.deepcopy(hl.bg) or nil,
			sp = hl.sp ~= "None" and vim.deepcopy(hl.sp) or nil,
		}

		if hl.gui then
			for _, flag in ipairs(vim.split(hl.gui, ",")) do
				if flag ~= "None" then
					hl_def[flag] = true
				end
			end
		end

		return hl_def
	end
end

-- local active_theme = nil
-- local theme_hls = {}
--
-- function M.create_highlight_groups(theme)
-- 	clear_highlights()
--
-- 	active_theme = theme
-- 	theme_hls = {}
-- end

return M
