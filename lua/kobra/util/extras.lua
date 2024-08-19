local M = {}

local Float = require("lazy.view.float")
local LazyConfig = require("lazy.core.config")
local Text = require("lazy.view.text")

M.buf = 0

M.sources = {
	{ name = "KobraVim", desc = "KobraVim extras", module = "kobra.plugins.extras" },
	{ name = "User", desc = "User extras", module = "user.extras" },
}

M.ns = vim.api.nvim_create_namespace("kobra.extras")
M.state = nil

local X = {}

function X.new()
	local self = setmetatable({}, { __index = X })
	M.buf = vim.api.nvim_get_current_buf()
	self.float = Float.new({ title = "KobraVim Extras" })
	self.float:on_key("x", function()
		self:toggle()
	end, "Toggle extra")
	self.diag = {}
	self:update()
	return self
end

function X:diagnostic(diag)
	diag.row = diag.row or self.text:row()
	diag.severity = diag.severity or vim.diagnostic.severity.INFO
	table.insert(self.diag, diag)
end

function X:toggle()
	local pos = vim.api.nvim_win_get_cursor(self.float.win)
	for _, extra in ipairs(self.extras) do
		if extra.row == pos[1] then
			if not extra.managed then
				KobraVim.error(
					"Not managed by KobraExtras. Remove from your config to enable/disable here.",
					{ title = "KobraExtras" }
				)
				return
			end

			extra.enabled = not extra.enabled

			KobraVim.config.json.data.extras = vim.tbl_filter(function(name)
				return name ~= extra.module
			end, KobraVim.config.json.data.extras)

			M.state = vim.tbl_filter(function(name)
				return name ~= extra.module
			end, M.state)

			if extra.enabled then
				table.insert(KobraVim.config.json.data.extras, extra.module)
				M.state[#M.state + 1] = extra.module
			end

			table.sort(KobraVim.config.json.data.extras)
			KobraVim.json.save()
			KobraVim.info(
				"`"
					.. extra.name
					.. "`"
					.. " "
					.. (extra.enabled and "**enabled**" or "**disabled**")
					.. "\nPlease restart KobraVim to apply the changes.",
				{ title = "KobraExtras" }
			)

			self:update()
			return
		end
	end
end

function X:update()
	self.diag = {}
	self.extras = M.get()
	self.text = Text.new()
	self.text.padding = 2
	self:render()
	self.text:trim()
	vim.bo[self.float.buf].modifiable = true
	self.text:render(self.float.buf)
	vim.bo[self.float.buf].modifiable = false
	vim.diagnostic.set(
		M.ns,
		self.float.buf,
		vim.tbl_map(function(diag)
			diag.col = 0
			diag.lnum = diag.row - 1
			return diag
		end, self.diag),
		{ signs = false, virtual_text = true, underline = false }
	)
end

function X:render()
	self.text:nl():nl():append("KobraVim Extras", "LazyH1"):nl():nl()
	self.text
		:append("This is a list of all enabled/disabled KobraVim extras.", "LazyComment")
		:nl()
		:append("Each extra shows the required and optional plugins it may install.", "LazyComment")
		:nl()
		:append("Enable/disable extras with the ", "LazyComment")
		:append("<x>", "LazySpecial")
		:append(" key", "LazyComment")
		:nl()
	for _, extra in ipairs(self.extras) do
		extra.section = nil
	end
	self:section({
		recommended = true,
		enabled = false,
		include = "^lang%.",
		title = "Recommended Languages",
		empty = false,
	})
	self:section({ enabled = true, exclude = "^lang%.", title = "Enabled Plugins" })
	self:section({ enabled = true, title = "Enabled Languages" })
	self:section({ recommended = true, title = "Recommended Plugins", empty = false })
	self:section({ title = "Plugins", exclude = "^lang%." })
	self:section({ title = "Languages" })
end

function X:extra(extra)
	if not extra.managed then
		local parents = {}
		for _, x in ipairs(self.extras) do
			if x.enabled and vim.tbl_contains(x.imports, extra.module) then
				parents[#parents + 1] = x
			end
		end

		if #parents > 0 then
			local pp = vim.tbl_map(function(x)
				return x.name
			end, parents)
			self:diagnostic({
				message = "Required by " .. table.concat(pp, ", "),
			})
		elseif vim.tbl_contains(KobraVim.plugin.core_imports, extra.module) then
			self:diagnostic({
				message = "This extra is included by default",
			})
		else
			self:diagnostic({
				message = "Not managed by KobraExtras (config)",
				severity = vim.diagnostic.severity.WARN,
			})
		end
	end

	extra.row = self.text:row()
	local hl = extra.managed and "LazySpecial" or "LazyLocal"

	if extra.enabled then
		self.text:append("  " .. LazyConfig.options.ui.icons.loaded .. " ", hl)
	else
		self.text:append("  " .. LazyConfig.options.ui.icons.not_loaded .. " ", hl)
	end

	self.text:append(extra.name)
	if extra.recommended then
		self.text:append(" "):append(LazyConfig.options.ui.icons.favorite or " ", "LazyCommit")
	end

	if extra.source.name ~= "KobraVim" then
		self.text:append(" "):append(LazyConfig.options.ui.icons.event .. extra.source.name, "LazyReasonEvent")
	end

	for _, import in ipairs(extra.imports) do
		import = import:gsub("^kobra.plugins.extras.", "")
		self.text:append(" "):append(LazyConfig.options.ui.icons.plugin .. import, "LazyReasonStart")
	end

	for _, plugin in ipairs(extra.plugins) do
		self.text:append(" "):append(LazyConfig.options.ui.icons.plugin .. plugin, "LazyReasonPlugin")
	end

	for _, plugin in ipairs(extra.optional) do
		self.text:append(" "):append(LazyConfig.options.ui.icons.plugin .. plugin, "LazyReasonRequire")
	end

	if extra.desc then
		self.text:nl():append("    " .. extra.desc, "LazyComment")
	end

	self.text:nl()
end

function X:section(opts)
	opts = opts or {}
	local extras = vim.tbl_filter(function(extra)
		return extra.section == nil
			and (opts.enabled == nil or extra.enabled == opts.enabled)
			and (opts.recommended == nil or extra.recommended == opts.recommended)
			and (opts.include == nil or extra.name:find(opts.include))
			and (opts.exclude == nil or not extra.name:find(opts.exclude))
	end, self.extras)

	if opts.empty == false and #extras == 0 then
		return
	end

	self.text:nl():append(opts.title .. ":", "LazyH2"):append(" (" .. #extras .. ")", "LazyComment"):nl()
	for _, extra in ipairs(extras) do
		extra.section = opts.title
		self:extra(extra)
	end
end

function M.show()
	X.new()
end

return M
