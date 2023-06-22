local conditions = require("heirline.conditions")
local h_utils = require("heirline.utils")

local work_dir = {
	provider = function()
		local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
		local cwd = vim.fn.getcwd(0)
		cwd = vim.fn.fnamemodify(cwd, ":~")
		if not conditions.width_percent_below(#cwd, 0.25) then
			cwd = vim.fn.pathshorten(cwd)
		end
		local trail = cwd:sub(-1) == "/" and "" or "/"
		return icon .. cwd .. trail
	end,
	hl = { fg = "UserBlueN", bold = true },
}

local file_name_block = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}

local file_icon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("nvim-web-devicons").get_icon(filename, extension, { default = true })
	end,
	provider = function(self)
		return " " .. self.icon and (self.icon .. " ")
	end,
	hl = "UserDir",
}

local file_name_modifier = {
	hl = function()
		if vim.bo.modified then
			return { fg = "UserCyanGray", bold = true, force = true }
		end
	end,
}

local file_name = {
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ":.")
		if filename == "" then
			return "[No Name]"
		end
		if not conditions.width_percent_below(#filename, 0.25) then
			filename = vim.fn.pathshorten(filename)
		end
		return filename
	end,
	hl = "UserDir",
}

local file_flags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = "[+]",
		hl = "UserGreenGray",
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = "",
		hl = "UserRedGray",
	},
}

return h_utils.insert(
	file_name_block,
	work_dir,
	file_icon,
	h_utils.insert(file_name_modifier, file_name),
	file_flags,
	{ provider = "%<" }
)
