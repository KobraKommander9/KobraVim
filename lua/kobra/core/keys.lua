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
	local map = require("kobra.util").keymap

	keys = vim.deepcopy(defaults)
	if opts.colemak then
		local key_opts = { silent = true, noremap = true }

		keys.j = "n"
		keys.k = "e"
		keys.l = "i"
		map("", "n", "j", key_opts)
		map("", "e", "k", key_opts)
		map("", "i", "l", key_opts)

		keys.n = "j"
		keys.e = "k"
		keys.i = "l"
		map("", "j", "n", key_opts)
		map("", "k", "e", key_opts)
		map("", "l", "i", key_opts)

		keys.J = "N"
		keys.K = "E"
		keys.L = "I"
		map("", "N", "J", key_opts)
		map("", "E", "K", key_opts)
		map("", "I", "L", key_opts)

		keys.N = "J"
		keys.E = "K"
		keys.I = "L"
		map("", "J", "N", key_opts)
		map("", "K", "E", key_opts)
		map("", "L", "I", key_opts)
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
