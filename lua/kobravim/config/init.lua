local M = {}

M.lazy_version = ">=9.1.0"
KobraVim.config = M

local defaults = {
	defaults = {
		autocmds = true,
		commands = true,
		keymaps = true,
		-- kobravim.config.options can't be configured here since that's loaded before KobraVim setup
		-- if you want to disable loading options, add `package.loaded["kobravim.config.options"] = true` to the top of your init.lua
	},
	keys = "default",
	ui = {
		transparent = true,
		colorscheme = "autumn",
	},
	-- you can customize the "words" config here
	-- words = {
	--   refer to "defaults" in "kobravim.util.words"
	-- },
	icons = {
		misc = {
			dots = "󰇘",
		},
		-- 	ft = {
		-- 		octo = "",
		-- 	},
		dap = {
			Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
			Breakpoint = " ",
			BreakpointCondition = " ",
			BreakpointRejected = { " ", "DiagnosticError" },
			LogPoint = ".>",
		},
		diagnostics = {
			Error = " ",
			Warn = " ",
			Hint = " ",
			Info = " ",
		},
		diff = {
			add = "▎",
			change = "▎",
			delete = "",
		},
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

setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end
		return options[key]
	end,
})

function M.setup(opts)
	vim.notify("setting up")
	options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

	KobraVim.keys.setup(options.keys)
	KobraVim.words.setup(options.words)

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

			if lazy_clipboard ~= nil then
				vim.opt.clipboard = lazy_clipboard
			end

			KobraVim.format.setup()
		end,
	})

	KobraVim.track("colorscheme")
	KobraVim.try(function()
		if type(M.ui.colorscheme) == "function" then
			M.ui.colorscheme()
		else
			vim.cmd.colorscheme(M.ui.colorscheme)
		end
	end, {
		msg = "Could not load colorscheme",
		on_error = function(msg)
			KobraVim.error(msg)
			vim.cmd.colorscheme("autumn")
		end,
	})
	KobraVim.track()
end

function M.load(name)
	-- safely require modules
	local function _load(mod)
		if require("lazy.core.cache").find(mod)[1] then
			KobraVim.try(function()
				require(mod)
			end, { msg = "Failed loading " .. mod })
		end
	end

	local pattern = "KobraVim" .. name:sub(1, 1):upper() .. name:sub(2)
	-- always load KobraVim, then user file
	if M.defaults[name] or name == "options" then
		_load("kobravim.config." .. name)
		vim.api.nvim_exec_autocmds("User", { pattern = pattern .. "Defaults", modeline = false })
	end

	_load("config." .. name)
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
	KobraVim.lazy_notify()

	-- load options here, before lazy init while sourcing plugin modules
	-- this is needed to make sure options will be correctly applied
	-- after installing missing plugins
	M.load("options")

	-- defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
	lazy_clipboard = vim.opt.clipboard
	vim.opt.clipboard = ""

	KobraVim.plugin.setup()
end

return M
