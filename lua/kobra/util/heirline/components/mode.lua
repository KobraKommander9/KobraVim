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
		hl = "kobra_normal_a",
		M.vi_mode(),
		{
			provider = " A ",
			hl = "kobra_insert_a",
		},
		{
			provider = " B ",
			hl = "kobra_replace_a",
		},
		{
			provider = " C ",
			hl = "kobra_visual_a",
		},
		{
			provider = " D ",
			hl = "kobra_command_a",
		},
		{
			provider = " E ",
			hl = "kobra_terminal_a",
		},
		{
			provider = " F ",
			hl = "kobra_inactive_a",
		},
	}
end

return M
