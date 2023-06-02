local mode_names = function()
	return {
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
		r = "...",
		rm = "M",
		["r?"] = "?",
		["!"] = "!",
		t = "T",
	}
end

local vi_mode = {
	provider = function(self)
		return "%2(" .. self.mode_names[self.mode] .. "%) "
	end,
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}

local search_count = {
	condition = function()
		return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
	end,
	init = function(self)
		local ok, search = pcall(vim.fn.searchcount)
		if ok and search.total then
			self.search = search
		end
	end,
	provider = function(self)
		local search = self.search
		if not search then
			return ""
		end
		return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
	end,
}

local macro_rec = {
	condition = function()
		return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
	end,
	provider = " [" .. vim.fn.reg_recording() .. "]",
	update = {
		"RecordingEnter",
		"RecordingLeave",
	},
}

return {
	init = function(self)
		self.mode = vim.fn.mode(1)
	end,
	static = {
		mode_names = mode_names(),
	},
	hl = function(self)
		return self:mode_color()
	end,
	macro_rec,
	vi_mode,
	search_count,
}
