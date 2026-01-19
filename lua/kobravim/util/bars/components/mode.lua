local bars = KobraVim.bars
local palette = bars.palette

local utils = require("heirline.utils")

return {
	init = function(self)
		self.mode = vim.fn.mode(1)
	end,

	static = {
		mode_names = {
			n = "N",
			no = "N?",
			nov = "N?",
			noV = "N?",
			["no\22"] = "N?",
			niI = "Ni",
			niR = "Nr",
			niV = "Nv",
			nt = "Nt",
			v = "V",
			vs = "Vs",
			V = "V_",
			Vs = "Vs",
			["\22"] = "^V",
			["\22s"] = "^V",
			s = "S",
			S = "S_",
			["\19"] = "^S",
			i = "I",
			ic = "Ic",
			ix = "Ix",
			R = "R",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "C",
			cv = "Ex",
			ce = "EX",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = "T",
		},
	},

	hl = function(self)
		local mode = self.mode:sub(1, 1)
		return {
			fg = palette.mode_map[mode] or palette.blue,
			bold = true,
		}
	end,

	{ -- macro recording
		condition = function()
			return vim.fn.reg_recording() ~= ""
		end,
		provider = " ",
		hl = { fg = palette.red, anim = true },
		utils.surround({ " ", " " }, nil, {
			provider = function()
				return vim.fn.reg_recording()
			end,
			hl = { italic = true },
		}),
	},

	{ -- mode text
		provider = function(self)
			return (self.mode_names[self.mode] or self.mode:upper():sub(1, 1)) .. " "
		end,
	},

	{
		condition = function()
			return vim.v.hlsearch ~= 0
		end,
		init = function(self)
			local ok, search = pcall(vim.fn.searchcount)
			if ok and search.total then
				self.search = search
			end
		end,
		provider = function(self)
			if not self.search or self.search.total == 0 then
				return ""
			end
			return string.format("[%d/%d] ", self.search.current, math.min(self.search.total, self.search.maxcount))
		end,
	},

	update = {
		"ModeChanged",
		"RecordingEnter",
		"RecordingLeave",
		"CmdlineLeave",
	},
}
