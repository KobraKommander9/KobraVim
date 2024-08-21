local M = {}

local modes = Kobra.mode.abbrs

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

return M
