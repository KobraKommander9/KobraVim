local M = {}

require("kobra.core.types")

M.lazy_version = ">=9.1.0"

local defaults = {
	defaults = {
		autocmds = true,
		commands = true,
		keymaps = true,
	},
	paths = {
		home = os.getenv("HOME"),
		data = vim.fn.stdpath("data") .. "/site",
		config = vim.fn.stdpath("config"),
		cache = vim.fn.stdpath("cache"),
	},
	layouts = {
		layout = "default",
		default = {
			escape = {
				keys = { "jk" },
				timeout = vim.o.timeoutlen,
			},
		},
		colemak = {
			escape = {
				keys = { "qn" },
				timeout = vim.o.timeoutlen,
			},
		},
	},
	lsp = {
		logging = "off",
	},
	ui = {
		background = "transparent",
		colorscheme = "one_monokai",
		colors = {
			black = "#393b44",
			red = "#c94f6d",
			green = "#81b29a",
			yellow = "#dbc074",
			blue = "#719cd6",
			magenta = "#9d79d6",
			cyan = "#63cdcf",
			white = "#dfdfe0",
		},
		start_screen = {
			header = {
				[[ █████  ████     ████             █████                              ]],
				[[ █████ ████      █████              █████      ██                     ]],
				[[  ████████       █████               █████                             ]],
				[[  ███████  ███ █████   ██ █ ██ ███████ ███   ███████████   ]],
				[[  █████████ ███████████ █████████████████ █████ ██████████████   ]],
				[[ █████████ ████ ██ ██████  ███ ███████ █████ █████ ████ █████   ]],
				[[ ████ ████ ████ ██ ████ ██  █████████ █████ █████ ████ █████  ]],
				[[ ██████  ██████████████████ ██████████████ █████ █████ ████ ██████ ]],
			},
			buttons = {
				["f"] = "new_file",
				["df"] = { "Dot Files", "~/dot-files" },
			},
			bottom_buttons = {
				["q"] = "quit",
			},
			folders = {
				{ "Projects", "~/Projects" },
			},
			workspaces = {
				{
					"Project Sessions",
					"p",
					"~/Projects",
				},
				{
					"Dotfile Sessions",
					"d",
					"~/dotfiles",
				},
			},
		},
		icons = {
			diagnostics = {
				Error = " ",
				Warn = " ",
				Hint = " ",
				Info = " ",
			},
			git = {
				added = " ",
				modified = "󰏫 ",
				removed = " ",
			},
			kinds = {
				Array = " ",
				Boolean = " ",
				Class = " ",
				Color = " ",
				Constant = " ",
				Constructor = " ",
				Copilot = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Folder = " ",
				Function = " ",
				Interface = " ",
				Key = " ",
				Keyword = " ",
				Method = " ",
				Module = " ",
				Namespace = " ",
				Null = " ",
				Number = " ",
				Object = " ",
				Operator = " ",
				Package = " ",
				Property = " ",
				Reference = " ",
				Snippet = " ",
				String = " ",
				Struct = " ",
				Text = " ",
				TypeParameter = " ",
				Unit = " ",
				Value = " ",
				Variable = " ",
			},
			marks = {
				Flag = "󰈿",
				Newest = "",
				Cursor = "󰇀",
				Next = "",
				Previous = "",
			},
			dap = {
				Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = " ",
				BreakpointCondition = " ",
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = ".>",
			},
		},
	},
}

M.renames = {
	["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
}

local options

function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {})

	if options.layouts.default == true then
		options.layouts.default = defaults.layouts.default
		options.layouts.layout = "default"
	end

	if options.layouts.colemak == true then
		options.layouts.colemak = defaults.layouts.colemak
		options.layouts.layout = "colemak"
	end

	if not M.has() then
		require("lazy.core.util").error(
			"**KobraVim** needs **lazy.nvim** version "
				.. M.lazy_version
				.. " to work properly.\n"
				.. "Please upgrade **lazy.nvim**",
			{ title = "KobraVim" }
		)
		error("Exiting")
	end

	require("kobra.core.keys").setup(options.layouts.layout, options.layouts)
	require("kobra.core.highlights").setup(options.ui.colors)

	local loadDefaults = function()
		for def in pairs(defaults.defaults) do
			M.load(def)
		end
	end

	if vim.fn.argc(-1) == 0 then
		-- autocmds and keymaps can wait to load
		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("KobraVim", { clear = true }),
			pattern = "VeryLazy",
			callback = loadDefaults,
		})
	else
		-- load them now so they affect the opened buffers
		loadDefaults()
	end

	require("lazy.core.util").try(function()
		if type(M.colorscheme) == "function" then
			M.colorscheme()
		else
			vim.cmd.colorscheme(M.colorscheme)
		end
	end, {
		msg = "Could not load colorscheme",
		on_error = function(msg)
			require("lazy.core.util").error(msg)
			vim.cmd.colorscheme(defaults.ui.colorscheme)
		end,
	})

	vim.lsp.set_log_level(options.lsp.logging)
end

function M.has(range)
	local semver = require("lazy.manage.semver")
	return semver.range(range or M.lazy_version):matches(require("lazy.core.config").version or "0.0.0")
end

function M.load(name)
	local util = require("lazy.core.util")
	local function _load(mod)
		util.try(function()
			require(mod)
		end, {
			msg = "Failed loading " .. mod,
			on_error = function(msg)
				local info = require("lazy.core.cache").find(mod)
				if info == nil or (type(info) == "table" and #info == 0) then
					return
				end
				util.error(msg)
			end,
		})
	end

	if M.defaults[name] or name == "options" then
		_load("kobra.core.config." .. name)
	end
	_load("config." .. name)

	if vim.bo.filetype == "lazy" then
		vim.cmd([[do VimResized]])
	end
end

M.did_init = false
function M.init()
	if not M.did_init then
		M.did_init = true
		KobraVim.lazy_notify()

		require("kobra.core").load("options")
		local Plugin = require("lazy.core.plugin")
		local add = Plugin.Spec.add
		Plugin.Spec.add = function(self, plugin, ...)
			if type(plugin) == "table" and M.renames[plugin[1]] then
				plugin[1] = M.renames[plugin[1]]
			end
			return add(self, plugin, ...)
		end
	end
end

setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end
		return options[key]
	end,
})

return M
