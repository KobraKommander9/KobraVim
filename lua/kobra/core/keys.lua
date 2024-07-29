local M = {}

local setupKeys = function()
	local layouts = require("kobra.core").layouts

	local keys = {
		j = "j",
		k = "k",
		l = "l",

		J = "J",
		K = "K",
		L = "L",

		n = "n",
		e = "e",
		i = "i",

		N = "N",
		E = "E",
		I = "I",
	}

	if layouts.colemak then
		keys.j = "n"
		keys.k = "e"
		keys.l = "i"

		keys.n = "j"
		keys.e = "k"
		keys.i = "l"

		keys.J = "N"
		keys.K = "E"
		keys.L = "I"

		keys.N = "J"
		keys.E = "K"
		keys.I = "L"
	end

	return keys
end

setmetatable(M, {
	__index = setupKeys(),
})

return M
