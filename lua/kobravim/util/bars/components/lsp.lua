local M = {}

local conditions = require("heirline.conditions")

local function get_diag(icon, str)
	local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[str] })
	local count = #diagnostics

	return (count > 0) and icon .. " " .. count .. " " or ""
end

M.status = {
	-- lsp server name
	condition = conditions.lsp_attached,
	update = { "LspAttach", "LspDetach" },
	provider = function()
		local names = {}
		for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
			table.insert(names, server.name)
		end

		return " [" .. table.concat(names, " ") .. "]"
	end,
}

M.error = {
	provider = function()
		return get_diag("", "ERROR")
	end,
	hl = "error",
}

M.warn = {
	provider = function()
		return get_diag("", "WARN")
	end,
	hl = "warn",
}

M.info = {
	provider = function()
		return get_diag("", "INFO")
	end,
	hl = "info",
}

M.hint = {
	provider = function()
		return get_diag("", "HINT")
	end,
	hl = "hint",
}

return M
