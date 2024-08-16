local M = {}

local api = vim.api
local uv = vim.uv or vim.loop

local termcodes = function(str)
	api.nvim_replace_termcodes(str, true, true, true)
end

local defaults = {
	keys = { "jk" },
	timeout = vim.o.timeoutlen,
}

local function validate_keys(keys)
	assert(type(keys) == "table", "keys must be a table")

	for _, mapping in ipairs(keys) do
		assert(type(mapping) == "string" or type(mapping) == "table", "keys must be a string or table")

		-- each key can specify an action and mode(s)
		if type(mapping) == "string" then
			-- replace all multibyte chars to `A` char
			local length = #vim.fn.substitute(mapping, ".", "A", "g")
			assert(length == 2, "keys must be 2 characters long")
		else
			assert(#mapping >= 1, "keys must have at least 1 key")
			for key, v in mapping do
				if key == "action" then
					assert(type(v) == "string" or type(v) == "function", "action must be a string or function")
				elseif key == "mode" then
					assert(type(v) == "string" or type(v) == "table", "mode must be a string or table")
				end
			end
		end
	end
end

local function get_keys(keys)
	local mappings = {
		n = {},
		i = {},
		c = {},
		t = {},
		v = {},
		s = {},
	}

	for _, mapping in ipairs(keys) do
		local first_key, second_key
		if type(mapping) == "string" then
			first_key = mapping:sub(1, 1)
			second_key = mapping:sub(2, 2)
		else
			first_key = mapping[1]:sub(1, 1)
			second_key = mapping[1]:sub(2, 2)
		end

		local modes = {
			n = {
				[first_key] = { [second_key] = "<Esc>" },
			},
			i = {
				[first_key] = { [second_key] = "<Esc>" },
			},
			c = {
				[first_key] = { [second_key] = "<Esc>" },
			},
			t = {
				[first_key] = { [second_key] = "<C-\\><C-n>" },
			},
			v = {
				[first_key] = { [second_key] = "<Esc>" },
			},
			s = {
				[first_key] = { [second_key] = "<Esc>" },
			},
		}

		if type(mapping) == "table" then
			local mode = mapping.mode or { "i", "c", "t", "v", "s" }
			if type(mode) == "string" then
				mode = { mode }
			end

			for _, m in ipairs(mode) do
				if mapping.action then
					modes[m][first_key][second_key] = mapping.action
				end
			end
		end

		mappings = vim.tbl_deep_extend("force", mappings, modes)
	end

	return mappings
end

local settings
function M.setup(opts)
	local options = vim.tbl_deep_extend("force", defaults, opts or {})

	local ok, msg = pcall(validate_keys, options.keys)
	if not ok then
		vim.notify("Error(keys): " .. msg, vim.log.levels.ERROR)
		return
	end

	settings = {
		timeout = options.timeout,
		mappings = get_keys(options.keys),
	}
end

local waiting = false
local recorded_key = nil
local recorded_mode = nil
local has_recorded = false
local bufmodified = nil
local timeout_timer = uv.new_timer()
local function record_key(key)
	if timeout_timer:is_active() then
		timeout_timer:stop()
	end

	waiting = true
	recorded_key = key
	recorded_mode = api.nvim_get_mode().mode
	has_recorded = true
	bufmodified = vim.bo.modified

	timeout_timer:start(settings.timeout, 0, function()
		waiting = false
		recorded_key = nil
	end)
end

local undo_keys = {
	i = "<bs>",
	c = "<bs>",
	t = "<bs>",
}

local function execute(mode, action)
	local keys = ""
	keys = keys
		.. termcodes((undo_keys[mode] or "") .. ("<cmd>setlocal %smodified<cr>"):format(bufmodified and "" or "no"))

	if type(action) == "string" then
		keys = keys .. termcodes(action)
	else
		keys = keys .. termcodes(action() or "")
	end

	api.nvim_feedkeys(keys, "in", false)
end

local function check_key(key)
	local mode = api.nvim_get_mode().mode
	if mode ~= recorded_mode then
		waiting = false
		recorded_key = nil
		recorded_mode = nil
	end

	if waiting then
		for second_key, action in pairs(settings.mappings[recorded_mode][recorded_key]) do
			if key == second_key then
				waiting = false
				execute(recorded_mode, action)
				return
			end
		end
	end

	for first_key in pairs(settings.mappings[mode]) do
		if key == first_key then
			record_key(key)
			return
		end
	end
end

vim.on_key(function(_, typed)
	if typed == "" then
		return
	end

	check_key(typed)

	if has_recorded == false then
		recorded_key = nil
		return
	end
	has_recorded = false
end)

return M
