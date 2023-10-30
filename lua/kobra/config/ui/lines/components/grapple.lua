return {
	condition = function()
		local ok, grapple = pcall(require, "grapple")
		if not ok then
			return false
		end
		return grapple.exists
	end,
	provider = function()
		local key = require("grapple").key()
		if key == nil then
			return ""
		end
		return " [" .. key .. "]"
	end,
	hl = "UserPurpleN",
}
