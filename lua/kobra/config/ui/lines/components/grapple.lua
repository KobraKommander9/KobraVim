return {
	condition = function()
		return require("grapple").exists
	end,
	provider = function()
		local key = require("grapple").key()
		return " [" .. key .. "]"
	end,
	hl = "UserPurpleN",
}
