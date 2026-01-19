local bars = KobraVim.bars

return {
	{ -- lsp server name
		condition = function()
			return #vim.lsp.get_clients({ bufnr = 0 }) > 0
		end,

		update = { "LspAttach", "LspDetach" },

		provider = function()
			local names = {}
			for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
				table.insert(names, server.name)
			end

			return "  [" .. table.concat(names, ",") .. "] "
		end,
	},

	{ -- error count
		provider = function()
			local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
			return count > 0 and ("  " .. count .. " ")
		end,
		hl = { fg = bars.get_hl("DiagnosticError") },
	},

	{ -- warning count
		provider = function()
			local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
			return count > 0 and ("  " .. count .. " ")
		end,
		hl = { fg = bars.get_hl("DiagnosticWarn") },
	},
}
