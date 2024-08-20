local M = {}

function M.safe_map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	local modes = type(mode) == "string" and { mode } or mode

	modes = vim.tbl_filter(function(m)
		return not (keys.have and keys:have(lhs, m))
	end, modes)

	-- do not create the keymap if a lazy keys handler exists
	if #modes > 0 then
		opts = opts or {}
		opts.silent = opts.silent ~= false

		if opts.remap and not vim.g.vscode then
			opts.remap = nil
		end

		vim.keymap.set(modes, lhs, rhs, opts)
	end
end

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
function M.setup()
	KobraVim.config.layout = KobraVim.config.layout or "default"
	local layout = KobraVim.config.layouts[KobraVim.config.layout] or {}

	keys = vim.deepcopy(defaults)
	keys = vim.tbl_deep_extend("force", keys, layout)

	if KobraVim.config.layout == "colemak" then
		keys.j = "n"
		keys.k = "e"
		keys.l = "i"

		keys.n = "j"
		keys.e = "k"
		keys.i = "l"

		keys.nextMatch = "N"
		keys.prevMatch = "E"
	end

	if KobraVim.config.layouts[KobraVim.config.layout] == false then
		return
	end

	require("kobra.util.escape").setup(keys.escape)
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
