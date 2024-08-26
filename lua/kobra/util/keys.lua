local M = {}

local defaults = {
	nextMatch = "n",
	prevMatch = "N",
}

local keys
function M.setup(name, layouts)
	name = name or "default"
	local layout = layouts[name] or {}

	keys = vim.deepcopy(defaults)
	keys = vim.tbl_deep_extend("force", keys, layout)
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
