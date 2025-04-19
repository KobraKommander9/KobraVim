local M = {}

local layouts = {
	default = {
		nextMatch = "n",
		prevMatch = "N",

		cycleDown = "<C-n>",
		cycleUp = "<C-p>",
	},
	colemak = {
		-- N goes to the next match (replaces n)
		-- E goes to previous match (replaces N)
		-- I moves cursor to bottom of screen

		-- l to insert mode
		-- L to insert at beginning of line

		-- K/k replaces E/e
		-- previous word (B) and end of word (K) are next to each other

		-- Help is on lower case j

		j = "n",
		k = "e",
		l = "i",

		J = "N",
		K = "E",
		L = "I",

		n = "j",
		e = "k",
		i = "l",

		N = "J",
		E = "K",
		I = "L",

		nextMatch = "N",
		prevMatch = "E",

		cycleDown = "<C-p>",
		cycleUp = "<C-f>",
	},
}

local keys
local mappings

function M.setup(layout)
	layout = layout or "default"
	if type(layout) == "string" then
		layout = layouts[layout] or {}
	end

	keys = vim.deepcopy(layout)
	mappings = vim.deepcopy(keys)

	mappings.nextMatch = nil
	mappings.prevMatch = nil
	mappings.cycleDown = nil
	mappings.cycleUp = nil
end

function M.mappings()
	return mappings
end

function M.safe_map(mode, lhs, rhs, opts)
	local ks = require("lazy.core.handler").handlers.keys
	local modes = type(mode) == "string" and { mode } or mode

	modes = vim.tbl_filter(function(m)
		return not (ks.have and ks:have(lhs, m))
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

setmetatable(M, {
	__index = function(_, key)
		if keys == nil then
			keys = vim.deepcopy(layouts["default"])[key]
		end

		if not keys[key] then
			return key
		end

		return keys[key]
	end,
})

return M
