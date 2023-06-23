local M = {}

local dap = {
	"mfussenegger/nvim-dap",
	optional = true,
  -- stylua: ignore
	keys = {
		{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
	},
}

M[#M + 1] = {
	"folke/which-key.nvim",
	opts = {
		["<leader>t"] = { name = "+tests" },
	},
}

M[#M + 1] = {
	"nvim-neotest/neotest",
	dependencies = {
		dap,
		"nvim-neotest/neotest-go",
		"haydenmeade/neotest-jest",
	},
  -- stylua: ignore
	keys = {
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
		{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
		{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
		{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
		{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
		{ "<leader>tS", function() require("neotest").stop() end, desc = "Stop" },
		{ "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to Test" },
	},
	opts = {
		adapters = {
			["neotest-go"] = {},
			["neotest-jest"] = {
				cwd = function()
					return vim.fn.getcwd()
				end,
			},
		},
		status = { virtual_text = true },
		output = { open_on_run = true },
		quickfix = {
			open = function()
				vim.cmd("copen")
			end,
		},
	},
	config = function(_, opts)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					-- Replace new line and tab characters with space for more compact diagnostics
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)

		if opts.adapters then
			local adapters = {}
			for name, config in pairs(opts.adapters or {}) do
				if type(name) == "number" then
					if type(config) == "string" then
						config = require(config)
					end
					adapters[#adapters + 1] = config
				elseif config ~= false then
					local adapter = require(name)
					if type(config) == "table" and not vim.tbl_isempty(config) then
						local meta = getmetatable(adapter)
						if adapter.setup then
							adapter.setup(config)
						elseif meta and meta.__call then
							adapter(config)
						else
							error("Adapter " .. name .. " does not support setup")
						end
					end
					adapters[#adapters + 1] = adapter
				end
			end
			opts.adapters = adapters
		end

		require("neotest").setup(opts)
	end,
}

return M
