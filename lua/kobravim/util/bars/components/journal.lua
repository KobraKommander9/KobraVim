return {
	condition = function()
		local has_bw, bw = pcall(require, "bookwyrm")
		if not has_bw then
			return false
		end

		return bw.api.get_active_title() ~= nil
	end,

	init = function(self)
		self.title = require("bookwyrm").api.get_active_title()
	end,

	provider = function(self)
		if self.title == "" then
			return ""
		end

		return " 󱓧 " .. self.title .. " "
	end,
}
