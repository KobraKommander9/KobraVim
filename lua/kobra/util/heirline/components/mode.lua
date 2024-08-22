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
			provider = "",
			hl = "kobra_normal_a_rv",
		},
		{
			provider = "A",
			hl = "kobra_normal_a",
		},
		{
			provider = "",
			hl = "kobra_normal_ab",
		},
		{
			provider = "a",
			hl = "kobra_normal_b",
		},
		{
			provider = "",
			hl = "kobra_normal_b_rv",
		},
		{
			provider = " 1 ",
			hl = "kobra_normal_c",
		},
		{
			provider = " B ",
			hl = "kobra_insert_a",
		},
		{
			provider = " b ",
			hl = "kobra_insert_b",
		},
		{
			provider = " 2 ",
			hl = "kobra_insert_c",
		},
		{
			provider = " C ",
			hl = "kobra_replace_a",
		},
		{
			provider = " c ",
			hl = "kobra_replace_b",
		},
		{
			provider = " 3 ",
			hl = "kobra_replace_c",
		},
		{
			provider = " D ",
			hl = "kobra_visual_a",
		},
		{
			provider = " d ",
			hl = "kobra_visual_b",
		},
		{
			provider = " 4 ",
			hl = "kobra_visual_c",
		},
		{
			provider = " E ",
			hl = "kobra_command_a",
		},
		{
			provider = " e ",
			hl = "kobra_command_b",
		},
		{
			provider = " 5 ",
			hl = "kobra_command_c",
		},
		{
			provider = " F ",
			hl = "kobra_terminal_a",
		},
		{
			provider = " f ",
			hl = "kobra_terminal_b",
		},
		{
			provider = " 6 ",
			hl = "kobra_terminal_c",
		},
		{
			provider = " G ",
			hl = "kobra_inactive_a",
		},
		{
			provider = " g ",
			hl = "kobra_inactive_b",
		},
		{
			provider = " 7 ",
			hl = "kobra_inactive_c",
		},
	}
end

return M
