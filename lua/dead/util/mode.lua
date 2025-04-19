local M = {}

M.abbrs = {
	normal = "N",
	op_pending = "N?",
	visual = "V",
	visual_line = "Vl",
	visual_block = "Vb",
	select = "S",
	select_line = "Sl",
	select_block = "Sb",
	insert = "I",
	replace = "R",
	replace_visual = "Rv",
	command = "C",
	execute = "Ex",
	more = "M",
	confirm = "?",
	shell = "!",
	terminal = "T",
}

M.map = {
	["n"] = M.abbrs.normal,
	["no"] = M.abbrs.op_pending,
	["nov"] = M.abbrs.op_pending,
	["noV"] = M.abbrs.op_pending,
	["no\22"] = M.abbrs.op_pending,
	["niI"] = M.abbrs.normal,
	["niR"] = M.abbrs.normal,
	["niV"] = M.abbrs.normal,
	["nt"] = M.abbrs.normal,
	["ntT"] = M.abbrs.normal,
	["v"] = M.abbrs.visual,
	["vs"] = M.abbrs.visual,
	["V"] = M.abbrs.visual_line,
	["Vs"] = M.abbrs.visual_line,
	["\22"] = M.abbrs.visual_block,
	["\22s"] = M.abbrs.visual_block,
	["s"] = M.abbrs.select,
	["S"] = M.abbrs.select_line,
	["\19"] = M.abbrs.select_block,
	["i"] = M.abbrs.insert,
	["ic"] = M.abbrs.insert,
	["ix"] = M.abbrs.insert,
	["R"] = M.abbrs.replace,
	["Rc"] = M.abbrs.replace,
	["Rx"] = M.abbrs.replace,
	["Rv"] = M.abbrs.replace_visual,
	["Rvc"] = M.abbrs.replace_visual,
	["Rvx"] = M.abbrs.replace_visual,
	["c"] = M.abbrs.command,
	["cv"] = M.abbrs.execute,
	["ce"] = M.abbrs.execute,
	["r"] = M.abbrs.replace,
	["rm"] = M.abbrs.more,
	["r?"] = M.abbrs.confirm,
	["!"] = M.abbrs.shell,
	["t"] = M.abbrs.terminal,
}

function M.get_mode()
	local mode_code = vim.api.nvim_get_mode().mode
	if M.map[mode_code] == nil then
		return mode_code
	end
	return M.map[mode_code]
end

return M
