local M = {}

local defaults = {
	escape = {
		keys = { "jk" },
		timeout = vim.o.timeoutlen,
	},

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
function M.setup(name, layouts)
	name = name or "default"
	local layout = layouts[name] or {}

	keys = vim.deepcopy(defaults)
	keys = vim.tbl_deep_extend("force", keys, layout)

	if name == "colemak" then
		keys.j = "n"
		keys.k = "e"
		keys.l = "i"

		keys.n = "j"
		keys.e = "k"
		keys.i = "l"

		keys.nextMatch = "N"
		keys.prevMatch = "E"
	end

	if layouts[name] == false then
		return
	end

	KobraVim.escape.setup(keys.escape)
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
