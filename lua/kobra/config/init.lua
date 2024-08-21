local M = {}

M.lazy_version = ">=9.1.0"
Kobra.config = M

local defaults = {
	defaults = {
		autocmds = true,
		commands = true,
		keymaps = true,
		-- kobra.config.options can't be configured here since that's loaded before KobraVim setup
		-- if you want to disable loading options, add `package.loaded["kobra.config.options"] = true` to the top of your init.lua
	},
	layout = "default",
	layouts = {
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
	ui = {
		transparent = true,
		colorscheme = "one_monokai",
	},
	icons = {
		misc = {
			dots = "󰇘",
		},
		-- 	ft = {
		-- 		octo = "",
		-- 	},
		-- 	dap = {
		-- 		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		-- 		Breakpoint = " ",
		-- 		BreakpointCondition = " ",
		-- 		BreakpointRejected = { " ", "DiagnosticError" },
		-- 		LogPoint = ".>",
		-- 	},
		diagnostics = {
			Error = " ",
			Warn = " ",
			Hint = " ",
			Info = " ",
		},
		-- 	git = {
		-- 		added = " ",
		-- 		modified = " ",
		-- 		removed = " ",
		-- 	},
		kinds = {
			Array = " ",
			Boolean = "󰨙 ",
			Class = " ",
			Codeium = "󰘦 ",
			Color = " ",
			Control = " ",
			Collapsed = " ",
			Constant = "󰏿 ",
			Constructor = " ",
			Copilot = " ",
			Enum = " ",
			EnumMember = " ",
			Event = " ",
			Field = " ",
			File = " ",
			Folder = " ",
			Function = "󰊕 ",
			Interface = " ",
			Key = " ",
			Keyword = " ",
			Method = "󰊕 ",
			Module = " ",
			Namespace = "󰦮 ",
			Null = " ",
			Number = "󰎠 ",
			Object = " ",
			Operator = " ",
			Package = " ",
			Property = " ",
			Reference = " ",
			Snippet = " ",
			String = " ",
			Struct = "󰆼 ",
			TabNine = "󰏚 ",
			Text = " ",
			TypeParameter = " ",
			Unit = " ",
			Value = " ",
			Variable = "󰀫 ",
		},
	},
}

local options
local lazy_clipboard

function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

	Kobra.keys.setup(options.layout, options.layouts)

	-- autocmds can be lazy loaded if not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load("autocmds")
	end

	local group = vim.api.nvim_create_augroup("KobraVim", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "VeryLazy",
		callback = function()
			if lazy_autocmds then
				M.load("autocmds")
			end

			M.load("commands")
			M.load("keymaps")

			-- Kobra.format.setup()

			if lazy_clipboard ~= nil then
				vim.opt.clipboard = lazy_clipboard
			end
		end,
	})

	Kobra.track("colorscheme")
	Kobra.try(function()
		if type(M.colorscheme) == "function" then
			M.colorscheme()
		else
			vim.cmd.colorscheme(M.colorscheme)
		end
	end, {
		msg = "Could not load colorscheme",
		on_error = function(msg)
			Kobra.error(msg)
			vim.cmd.colorscheme("one_monokai")
		end,
	})
	Kobra.track()
end

function M.load(name)
	local function _load(mod)
		if require("lazy.core.cache").find(mod)[1] then
			Kobra.try(function()
				require(mod)
			end, { msg = "Failed loading " .. mod })
		end
	end

	local pattern = "KobraVim" .. name:sub(1, 1):upper() .. name:sub(2)
	-- always load kobravim, then user file
	if M.defaults[name] or name == "options" then
		_load("kobra.config." .. name)
		vim.api.nvim_exec_autocmds("User", { pattern = pattern .. "Defaults", modeline = false })
	end

	_load("config." .. name)
	if vim.bo.filetype == "lazy" then
		vim.cmd([[do VimResized]])
	end

	vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
	if M.did_init then
		return
	end

	M.did_init = true
	local plugin = require("lazy.core.config").spec.plugins.KobraVim
	if plugin then
		vim.opt.rtp:append(plugin.dir)
	end

	-- delay notifications till vim.notify was replaced or after 500ms
	Kobra.lazy_notify()

	-- load options here, before lazy init while sourcing plugin modules
	-- this is needed to make sure options will be correctly applied
	-- after installing missing plugins
	M.load("options")

	-- defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
	lazy_clipboard = vim.opt.clipboard
	vim.opt.clipboard = ""

	Kobra.plugin.setup()
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
