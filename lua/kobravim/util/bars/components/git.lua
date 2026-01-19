local bars = KobraVim.bars
local palette = bars.palette

return {
	condition = function()
		return vim.b.minidiff_summary ~= nil
	end,

	init = function(self)
		local summary = vim.b.minidiff_summary
		self.head = summary.source_name or ""
		self.added = summary.add or 0
		self.changed = summary.change or 0
		self.removed = summary.delete or 0
		self.has_changes = (self.added + self.changed + self.removed) > 0
	end,

	hl = { fg = palette.magenta },

	{ -- branch name
		provider = function(self)
			local name = self.head ~= "" and self.head or ""
			if name == "" then
				return ""
			end

			return "  " .. (name:len() > 20 and name:sub(1, 17) .. "..." or name)
		end,
		hl = { bold = true },
	},

	{ -- diff counts
		condition = function(self)
			return self.has_changes
		end,
		{
			provider = " (",
			hl = { fg = palette.blue },
		},
		{
			provider = function(self)
				return self.added > 0 and ("+" .. self.added)
			end,
			hl = { fg = "DiffAdd" },
		},
		{
			provider = function(self)
				return self.removed > 0 and ("-" .. self.removed)
			end,
			hl = { fg = "DiffDelete" },
		},
		{
			provider = function(self)
				return self.changed > 0 and ("~" .. self.changed)
			end,
			hl = { fg = "DiffChange" },
		},
		{
			provider = ")",
			hl = { fg = palette.blue },
		},
	},
}
