local M = {}

local layouts = {
	default = {
		esc = "jk",

		nextMatch = "n",
		prevMatch = "N",

		cycleDown = "<C-n>",
		cycleUp = "<C-p>",

		clearSearch = "<C-d>",
		pick = {
			toggle_preview = "<C-o>",
		},
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

		esc = "qn",

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

		clearSearch = "<C-q>",
		pick = {
			delete_left = "<C-l>",
			mark = "<C-o>",
			move_up = "<C-e>",

			scroll_down = "<C-d>",
			scroll_right = "<C-i>",
			scroll_up = "<C-u>",

			toggle_preview = "<C-p>",
		},
	},
}

function M.setup(layout)
	layout = layout or "default"
	if type(layout) == "string" then
		layout = layouts[layout] or {}
	end

	M.keys = vim.deepcopy(layout)
	M.mappings = vim.deepcopy(M.keys)

	M.mappings.esc = nil

	M.mappings.nextMatch = nil
	M.mappings.prevMatch = nil

	M.mappings.cycleDown = nil
	M.mappings.cycleUp = nil

	M.mappings.clearSearch = nil
	M.mappings.pick = nil
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
	__index = function(t, key)
		assert(t.keys, "keys not initialized")

		if not t.keys[key] then
			return key
		end

		return t.keys[key]
	end,
})

return M
