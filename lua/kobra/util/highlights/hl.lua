local M = {}

local modes = Kobra.mode.abbrs

local mode_to_highlight = {
	[modes.visual] = "kobra_visual_",
	[modes.visual_line] = "kobra_visual_",
	[modes.visual_block] = "kobra_visual_",
	[modes.select] = "kobra_visual_",
	[modes.select_line] = "kobra_visual_",
	[modes.select_block] = "kobra_visual_",
	[modes.replace] = "kobra_replace_",
	[modes.replace_visual] = "kobra_replace_",
	[modes.insert] = "kobra_insert_",
	[modes.command] = "kobra_command_",
	[modes.execute] = "kobra_command_",
	[modes.more] = "kobra_command_",
	[modes.confirm] = "kobra_command_",
	[modes.shell] = "kobra_terminal_",
	[modes.terminal] = "kobra_terminal_",
}

function M.get_mode_color(mode, section)
	return (mode_to_highlight[mode] or "kobra_normal_") .. (section or "a")
end

return M
