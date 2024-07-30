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
		vim.notify("colemak")
		-- keys.j = "n"
		-- keys.k = "e"
		-- keys.l = "i"
		--
		-- keys.n = "j"
		-- keys.e = "k"
		-- keys.i = "l"
		--
		-- keys.J = "N"
		-- keys.K = "E"
		-- keys.L = "I"
		--
		-- keys.N = "J"
		-- keys.E = "K"
		-- keys.I = "L"

		-- N goes to the next match (replaces n)
		-- E goes to previous match (replaces N)
		-- I moves cursor to bottom of screen

		-- l to insert mode
		-- L to insert at beginning of line

		-- K/k replaces E/e
		-- previous word (B) and end of word (K) are next to each other

		-- Help is on lower case j

		local key_opts = { silent = true, noremap = true }
		map("", "n", "j", key_opts)
		map("", "N", "n", key_opts)
		map("", "e", "k", key_opts)
		map("", "E", "N", key_opts)
		map("", "i", "l", key_opts)
		map("", "I", "L", key_opts)
		map("", "j", "K", key_opts)
		map("", "k", "e", key_opts)
		map("", "K", "E", key_opts)
		map("", "l", "i", key_opts)
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
