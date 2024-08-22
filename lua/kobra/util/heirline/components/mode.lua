local M = {}

function M.vi_mode()
	return {
		provider = function(self)
			return "%-2(" .. self.mode .. "%)"
		end,
		update = {
			"ModeChanged",
			pattern = "*:*",
			callback = vim.schedule_wrap(function()
				vim.cmd("redrawstatus")
			end),
		},
		hl = { bold = true },
	}
end

function M.search_count()
	return {
		init = function(self)
			local ok, search = pcall(vim.fn.searchcount)
			if ok and search.total then
				self.search = search
			end
		end,
		condition = function(self)
			local search = self.search and (self.search.maxcount > 0 and true or false) or true
			return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0 and search
		end,
		provider = function(self)
			local search = self.search
			if not search then
				return ""
			end

			local total = math.min(search.total, search.maxcount)
			if search.current == 0 and total == 0 then
				return ""
			end

			return string.format("[%d/%d]", search.current, total)
		end,
		hl = { bold = true },
	}
end

function M.macro_rec()
	return {
		condition = function()
			return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
		end,
		provider = function()
			return "[" .. vim.fn.reg_recording() .. "] "
		end,
		hl = { bold = true },
	}
end

function M.component()
	return {
		init = function(self)
			self.mode = Kobra.mode.get_mode()
		end,
		{
			provider = "",
			hl = function(self)
				return KobraColors.mode.get_mode_color(self.mode) .. "_rv"
			end,
		},
		{
			hl = function(self)
				return KobraColors.mode.get_mode_color(self.mode)
			end,
			{
				M.macro_rec(),
				M.vi_mode(),
			},
		},
		{
			provider = "",
			hl = function(self)
				return KobraColors.mode.get_mode_color(self.mode, "ab")
			end,
		},
		{
			hl = function(self)
				return KobraColors.mode.get_mode_color(self.mode, "b")
			end,
			M.search_count(),
		},
		{
			provider = "",
			hl = function(self)
				return KobraColors.mode.get_mode_color(self.mode, "b_rv")
			end,
		},
	}
end

return M
