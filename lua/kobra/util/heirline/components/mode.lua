local M = {}

local utils = require("kobra.util.heirline.components.utils")

function M.vi_mode()
	return {
		provider = function(self)
			return self.mode
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
	}
end

function M.macro_rec()
	return {
		condition = function()
			return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
		end,
		provider = function()
			return " [" .. vim.fn.reg_recording() .. "]"
		end,
	}
end

function M.mode_bubble(component)
	return {
		{
			provider = "",
			hl = function(self)
				return KobraColors.hl.get_mode_color(self.mode) .. "rv"
			end,
		},
		{
			hl = function(self)
				return KobraColors.hl.get_mode_color(self.mode) .. "a"
			end,
			component,
		},
		{
			provider = "",
			hl = function(self)
				return KobraColors.hl.get_mode_color(self.mode) .. "ab"
			end,
		},
	}
end

function M.component()
	return {
		init = function(self)
			self.mode = Kobra.mode.get_mode()
		end,
		M.mode_bubble(M.vi_mode()),
		-- {
		-- 	provider = "",
		-- 	hl = "kobra_normal_a_rv",
		-- },
		-- {
		-- 	provider = "A",
		-- 	hl = "kobra_normal_a",
		-- },
		-- {
		-- 	provider = "",
		-- 	hl = "kobra_normal_ab",
		-- },
		-- {
		-- 	provider = "a",
		-- 	hl = "kobra_normal_b",
		-- },
		-- {
		-- 	provider = "",
		-- 	hl = "kobra_normal_bc",
		-- },
		-- {
		-- 	provider = "1",
		-- 	hl = "kobra_normal_c",
		-- },
		-- {
		-- 	provider = "",
		-- 	hl = "kobra_normal_c_rv",
		-- },
		-- {
		-- 	provider = " B ",
		-- 	hl = "kobra_insert_a",
		-- },
		-- {
		-- 	provider = " b ",
		-- 	hl = "kobra_insert_b",
		-- },
		-- {
		-- 	provider = " 2 ",
		-- 	hl = "kobra_insert_c",
		-- },
		-- {
		-- 	provider = " C ",
		-- 	hl = "kobra_replace_a",
		-- },
		-- {
		-- 	provider = " c ",
		-- 	hl = "kobra_replace_b",
		-- },
		-- {
		-- 	provider = " 3 ",
		-- 	hl = "kobra_replace_c",
		-- },
		-- {
		-- 	provider = " D ",
		-- 	hl = "kobra_visual_a",
		-- },
		-- {
		-- 	provider = " d ",
		-- 	hl = "kobra_visual_b",
		-- },
		-- {
		-- 	provider = " 4 ",
		-- 	hl = "kobra_visual_c",
		-- },
		-- {
		-- 	provider = " E ",
		-- 	hl = "kobra_command_a",
		-- },
		-- {
		-- 	provider = " e ",
		-- 	hl = "kobra_command_b",
		-- },
		-- {
		-- 	provider = " 5 ",
		-- 	hl = "kobra_command_c",
		-- },
		-- {
		-- 	provider = " F ",
		-- 	hl = "kobra_terminal_a",
		-- },
		-- {
		-- 	provider = " f ",
		-- 	hl = "kobra_terminal_b",
		-- },
		-- {
		-- 	provider = " 6 ",
		-- 	hl = "kobra_terminal_c",
		-- },
		-- {
		-- 	provider = " G ",
		-- 	hl = "kobra_inactive_a",
		-- },
		-- {
		-- 	provider = " g ",
		-- 	hl = "kobra_inactive_b",
		-- },
		-- {
		-- 	provider = " 7 ",
		-- 	hl = "kobra_inactive_c",
		-- },
	}
end

return M
