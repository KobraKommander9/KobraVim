return {
	condition = function()
		return vim.b.minigit_summary ~= nil
	end,

	init = function(self)
		local summary = vim.b.minigit_summary
		self.head = summary and summary.head_name or ""

		local diff_summary = vim.b.minidiff_summary
		if diff_summary then
			self.added = diff_summary.add or 0
			self.changed = diff_summary.change or 0
			self.removed = diff_summary.delete or 0
		end

		self.has_changes = diff_summary and (self.added + self.changed + self.removed) > 0
	end,

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
		},
		{
			provider = function(self)
				return self.added > 0 and ("+" .. self.added)
			end,
			hl = "added",
		},
		{
			provider = function(self)
				return self.removed > 0 and ("-" .. self.removed)
			end,
			hl = "removed",
		},
		{
			provider = function(self)
				return self.changed > 0 and ("~" .. self.changed)
			end,
			hl = "changed",
		},
		{
			provider = ") ",
		},
	},
}
