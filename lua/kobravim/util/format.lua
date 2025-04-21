local M = setmetatable({}, {
	__call = function(m, ...)
		return m.format(...)
	end,
})

M.formatters = {}

function M.register(formatter)
	M.formatters[#M.formatters + 1] = formatter
	table.sort(M.formatters, function(a, b)
		return a.priority > b.priority
	end)
end

function M.formatexpr()
	if KobraVim.has("conform.nvim") then
		return require("conform").formatexpr()
	end
	return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

function M.resolve(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local have_primary = false

	return vim.tbl_map(function(formatter)
		local sources = formatter.sources(buf)
		local active = #sources > 0 and (not formatter.primary or not have_primary)
		have_primary = have_primary or (active and formatter.primary) or false

		return setmetatable({
			active = active,
			resolved = sources,
		}, { __index = formatter })
	end, M.formatters)
end

function M.info(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local gaf = vim.g.autoformat == nil or vim.g.autoformat
	local baf = vim.b[buf].autoformat
	local enabled = M.enabled(buf)
	local lines = {
		"# Status",
		("- [%s] global **%s**"):format(gaf and "x" or " ", gaf and "enabled" or "disabled"),
		("- [%s] buffer **%s**"):format(
			enabled and "x" or " ",
			baf == nil and "inherit" or baf and "enabled" or "disabled"
		),
	}

	local have = false
	for _, formatter in ipairs(M.resolve(buf)) do
		if #formatter.resolved > 0 then
			have = true
			lines[#lines + 1] = "\n# " .. formatter.name .. (formatter.active and " ***(active)***" or "")
			for _, line in ipairs(formatter.resolved) do
				lines[#lines + 1] = ("- [%s] **%s**"):format(formatter.active and "x" or " ", line)
			end
		end
	end

	if not have then
		lines[#lines + 1] = "\n***No formatters available for this buffer.***"
	end

	KobraVim[enabled and "info" or "warn"](
		table.concat(lines, "\n"),
		{ title = "KobraFormat (" .. (enabled and "enabled" or "disabled") .. ")" }
	)
end

function M.enabled(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local gaf = vim.g.autoformat
	local baf = vim.b[buf].autoformat

	-- use buffer setting if it exists
	if baf ~= nil then
		return baf
	end

	-- use global setting or true by default
	return gaf == nil or gaf
end

function M.enable(enable, buf)
	if enable == nil then
		enable = true
	end

	if buf then
		vim.b.autoformat = enable
	else
		vim.g.autoformat = enable
		vim.b.autoformat = nil
	end

	M.info()
end

function M.format(opts)
	opts = opts or {}
	local buf = opts.buf or vim.api.nvim_get_current_buf()
	if not ((opts and opts.force) or M.enabled(buf)) then
		return
	end

	local done = false
	for _, formatter in ipairs(M.resolve(buf)) do
		if formatter.active then
			done = true
			KobraVim.try(function()
				return formatter.format(buf)
			end, { msg = "Formatter `" .. formatter.name .. "` failed" })
		end
	end

	if not done and opts and opts.force then
		KobraVim.warn("No formatter available", { title = "KobraVim" })
	end
end

function M.health()
	local Config = require("lazy.core.config")
	local has_plugin = Config.spec.plugins["none-ls.nvim"]
	local has_extra = vim.tbl_contains(Config.spec.modules, "kobravim.plugins.extras.lsp.none-ls")
	if has_plugin and not has_extra then
		KobraVim.warn({
			"`conform.nvim` and `nvim-lint` are now the default formatters and linters in KobraVim.",
			"",
			"You can use those plugins together with `none-ls.nvim`,",
			"but you need to enable the `kobravim.plugins.extras.lsp.none-ls` extra,",
			"for formatting to work correctly.",
			"",
			"In case you no longer want to use `none-ls.nvim`, just remove the spec from your config.",
		})
	end
end

function M.setup()
	M.health()

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("KobraFormat", {}),
		callback = function(event)
			M.format({ buf = event.buf })
		end,
	})

	vim.api.nvim_create_user_command("KobraFormat", function()
		M.format({ force = true })
	end, { desc = "Format selection or buffer" })

	vim.api.nvim_create_user_command("KobraFormatInfo", function()
		M.info()
	end, { desc = "Show info about the formatters for the current buffer" })
end

return M
