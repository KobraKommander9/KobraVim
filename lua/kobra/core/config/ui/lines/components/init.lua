local components = {}

local utils = require("kobra.core.config.ui.lines.components.utils")
local conditions = require("heirline.conditions")

local align = { provider = "%=", hl = "UserSL" }

components.parent = function()
	return {
		static = {
			mode_colors_map = {
				n = "UserRvCyan",
				i = "UserSLStatus",
				v = "UserRvMagenta",
				V = "UserRvMagenta",
				["\22"] = "UserRvMagenta",
				c = "UserRvYellow",
				s = "UserRvMagenta",
				S = "UserRvMagenta",
				["\19"] = "UserRvMagenta",
				R = "UserRvRed",
				r = "UserRvBlue",
				["!"] = "UserRvBlue",
				t = "UserRvBlue",
			},
			mode_sep_colors_map = {
				n = "UserCyan",
				i = "UserSLStatusBg",
				v = "UserMagenta",
				V = "UserMagenta",
				["\22"] = "UserMagenta",
				c = "UserYellow",
				s = "UserMagenta",
				S = "UserMagenta",
				["\19"] = "UserMagenta",
				R = "UserRed",
				r = "UserBlue",
				["!"] = "UserBlue",
				t = "UserBlue",
			},
			mode_color = function(self)
				local mode = conditions.is_active() and vim.fn.mode() or "n"
				return self.mode_colors_map[mode]
			end,
			mode_sep_color = function(self)
				local mode = conditions.is_active() and vim.fn.mode() or "n"
				return self.mode_sep_colors_map[mode]
			end,
		},
	}
end

components.statusline = function()
	local vi_mode = require("kobra.core.config.ui.lines.components.vi_mode")
	local git = require("kobra.core.config.ui.lines.components.git")
	local grapple = require("kobra.core.config.ui.lines.components.grapple")
	local file = require("kobra.core.config.ui.lines.components.file")
	local lsp = require("kobra.core.config.ui.lines.components.lsp")
	local ruler = require("kobra.core.config.ui.lines.components.ruler")

	return {
		utils.surround_mode({ "", "" }, vi_mode),
		git,
		grapple,
		utils.surround({ "", "" }, "UserDirSep", file),
		align,
		lsp,
		utils.surround({ "", "" }, "UserSLAltSep", ruler),
	}
end

components.winbar = function()
	return require("kobra.core.config.ui.lines.components.navic")
end

components.tabline = function()
	return require("kobra.core.config.ui.lines.components.tab")
end

return components
