local M = {}

local pretty_ui = {
	"rcarriga/nvim-dap-ui",
  -- stylua: ignore
	keys = {
    { "<leader>pu", function() require("dapui").toggle({}) end, desc = "Dap UI" },
		{ "<leader>pe", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
	},
	opts = function()
		local e = "e"
		if require("kobra.core").layouts.colemak then
			e = "l"
		end

		return {
			mappings = {
				edit = e,
			},
		}
	end,
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup(opts)
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({})
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close({})
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close({})
		end
	end,
}

local virtual_text = {
	"theHamsta/nvim-dap-virtual-text",
	opts = {},
}

local mason_dap = {
	"jay-babu/mason-nvim-dap.nvim",
	dependencies = "mason.nvim",
	cmd = { "DapInstall", "DapUninstall" },
	opts = {
		automatic_installation = true,
		handlers = {},
		ensure_installed = {},
	},
}

-- stylua: ignore
local keys = {
	{ "<leader>pB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
	{ "<leader>pb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
	{ "<leader>pc", function() require("dap").continue() end, desc = "Continue" },
	{ "<leader>pC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
	{ "<leader>pg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
	{ "<leader>pi", function() require("dap").step_into() end, desc = "Step Into" },
	{ "<leader>pl", function() require("dap").run_last() end, desc = "Run Last" },
	{ "<leader>po", function() require("dap").step_out() end, desc = "Step Out" },
	{ "<leader>pO", function() require("dap").step_over() end, desc = "Step Over" },
	{ "<leader>pp", function() require("dap").pause() end, desc = "Pause" },
	{ "<leader>pr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
	{ "<leader>ps", function() require("dap").session() end, desc = "Session" },
	{ "<leader>pt", function() require("dap").terminate() end, desc = "Terminate" },
	{ "<leader>pw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
}

local function get_keys()
	local strokes = { j = "j", k = "k" }
	if require("kobra.core").layouts.colemak then
		strokes = { j = "n", k = "e" }
	end

  -- stylua: ignore
	local res = table.insert(keys, { "<leader>p" .. strokes.j, function() require("dap").down() end, desc = "Down" })
  -- stylua: ignore
	res = table.insert(keys, { "<leader>p" .. strokes.k, function() require("dap").up() end, desc = "Up" })

	return res
end

M[#M + 1] = {
	"mfussenegger/nvim-dap",
	dependencies = {
		pretty_ui,
		virtual_text,
		mason_dap,
	},
	keys = get_keys,
	config = function()
		local Config = require("kobra.core")
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

		for name, sign in pairs(Config.icons.dap) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define(
				"Dap" .. name,
				{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
			)
		end
	end,
}

M[#M + 1] = {
	"folke/which-key.nvim",
	opts = {
		defaults = {
			["<leader>p"] = { name = "+debug" },
			["<leader>pa"] = { name = "+adapters" },
		},
	},
}

return M
