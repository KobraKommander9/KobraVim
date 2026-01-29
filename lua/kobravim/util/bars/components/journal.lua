return {
	condition = function()
		local has_bw, bw = pcall(require, "bookwyrm")
		if not has_bw then
			return false
		end

		return bw.api.get_active_notebook() ~= nil
	end,

	init = function(self)
		self.nb = require("bookwyrm").api.get_active_notebook()
	end,

	provider = function(self)
		if not self.nb then
			return ""
		end

		return " 󱓧 " .. self.nb.title .. " "
	end,
}
