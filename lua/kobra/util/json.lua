local M = {}

local function encode(value, indent)
	local t = type(value)

	if t == "string" then
		return string.format("%q", value)
	elseif t == "number" or t == "boolean" then
		return tostring(value)
	elseif t == "table" then
		local is_list = KobraVim.is_list(value)
		local parts = {}
		local next_indent = indent .. "  "

		if is_list then
			for _, v in ipairs(value) do
				local e = encode(v, next_indent)
				if e then
					table.insert(parts, next_indent .. e)
				end
			end
			return "[\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "]"
		else
			local keys = vim.tbl_keys(value)
			table.sort(keys)
			for _, k in ipairs(keys) do
				local e = encode(value[k], next_indent)
				if e then
					table.insert(parts, next_indent .. string.format("%q", k) .. ": " .. e)
				end
			end
			return "{\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "}"
		end
	end
end

function M.encode(value)
	return encode(value, "")
end

function M.save()
	KobraVim.config.json.data.version = KobraVim.config.json.version
	local f = io.open(KobraVim.config.json.path, "w")
	if f then
		f:write(KobraVim.json.encode(KobraVim.config.json.data))
		f:close()
	end
end

function M.migrate()
	M.save()
end

return M
