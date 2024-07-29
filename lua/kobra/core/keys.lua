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
	local map = require("kobra.core.util").keymap

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

		local key_opts = { silent = true, noremap = true }
		map("", keys.j, "n", key_opts)
		map("", keys.k, "e", key_opts)
		map("", keys.l, "i", key_opts)

		map("", keys.n, "j", key_opts)
		map("", keys.e, "k", key_opts)
		map("", keys.i, "l", key_opts)

		map("", keys.J, "N", key_opts)
		map("", keys.K, "E", key_opts)
		map("", keys.L, "I", key_opts)

		map("", keys.N, "J", key_opts)
		map("", keys.E, "K", key_opts)
		map("", keys.I, "L", key_opts)
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
