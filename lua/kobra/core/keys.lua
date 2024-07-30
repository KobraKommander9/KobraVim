local M = {}

local defaults = {
	j = "j",
	k = "k",
	l = "l",

	n = "n",
	e = "e",
	i = "i",

	nextMatch = "n",
	prevMatch = "N",
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

		keys.nextMatch = "N"
		keys.prevMatch = "E"
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
