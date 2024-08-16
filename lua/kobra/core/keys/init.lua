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
	local default = opts.default or {}

	keys = vim.deepcopy(defaults)
	keys = vim.tbl_deep_extend("force", keys, default)

	if opts.colemak then
		keys.escape = vim.tbl_deep_extend("force", keys.escape or {}, opts.colemak.escape)

		keys.j = "n"
		keys.k = "e"
		keys.l = "i"

		keys.n = "j"
		keys.e = "k"
		keys.i = "l"

		keys.nextMatch = "N"
		keys.prevMatch = "E"
	end

	require("kobra.core.keys.escape").setup(keys.escape)
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
