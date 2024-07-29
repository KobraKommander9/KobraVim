local M = {}

local defaults = {
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

local keys
function M.setup(opts)
	keys = vim.deepcopy(defaults)
	if opts.colemak then
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
end

setmetatable(M, {
	__index = function(_, key)
		if keys == nil then
			return vim.deepcopy(defaults)[key]
		end
		return keys[key]
	end,
})

return M
