local M = {}

function M.vi_mode()
	return {
		provider = function(self)
			return "%2(" .. self.mode .. "%) "
		end,
		update = {
			"ModeChanged",
			pattern = "*:*",
			callback = vim.schedule_wrap(function()
				vim.cmd("redrawstatus")
			end),
		},
	}
end

function M.component()
	return {
		init = function(self)
			self.mode = Kobra.mode.get_mode()
		end,
		hl = "kobra_normal_d",
		M.vi_mode(),
	}
end

return M
