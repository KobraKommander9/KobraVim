local M = {}

local defaults = {
	nextMatch = "n",
	prevMatch = "N",

	cycleDown = "<C-n>",
	cycleUp = "<C-p>",
}

local keys
local mappings
function M.setup(name, layouts)
	name = name or "default"
	local layout = layouts[name] or {}

	keys = vim.deepcopy(defaults)
	keys = vim.tbl_deep_extend("force", keys, layout)

	mappings = vim.deepcopy(keys)
	mappings.nextMatch = nil
	mappings.prevMatch = nil
	mappings.cycleDown = nil
	mappings.cycleUp = nil
end

function M.mappings()
	return mappings
end

setmetatable(M, {
	__index = function(_, key)
		if keys == nil then
			keys = vim.deepcopy(defaults)[key]
		end

		if not keys[key] then
			return key
		end

		return keys[key]
	end,
})

return M
