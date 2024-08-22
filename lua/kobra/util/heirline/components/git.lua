local M = {}

local shorten = function(head)
	if string.find(head, "/") then
		return string.sub(head, string.find(head, "/") + 1)
	end

	if not string.find(head, "-") then
		return head
	end

	return vim.split(head, "-")[1]
end

function M.branch()
	return {
		provider = function(self)
			return Kobra.config.icons.kinds.Control .. shorten(self.status_dict.head)
		end,
	}
end

function M.diff()
	return {
		{
			condition = function(self)
				return self.has_changes
			end,
			provider = "(",
		},
		{
			provider = function(self)
				local count = self.status_dict.added or 0
				return count > 0 and ("+" .. count)
			end,
			hl = { fg = "kobra_default_git_add" },
		},
		{
			provider = function(self)
				local count = self.status_dict.removed or 0
				return count > 0 and ("-" .. count)
			end,
			hl = { fg = "kobra_default_git_del" },
		},
		{
			provider = function(self)
				local count = self.status_dict.changed or 0
				return count > 0 and ("~" .. count)
			end,
			hl = { fg = "kobra_default_git_change" },
		},
		{
			condition = function(self)
				return self.has_changes
			end,
			provider = ")",
		},
	}
end

function M.component()
	return {
		condition = function()
			return vim.b.minigit_summary or vim.b.minidiff_summary
		end,
		init = function(self)
			self.status_dict = {
				head = vim.b.minigit_summary.head_name,
				added = vim.b.minidiff_summary.add,
				removed = vim.b.minidiff_summary.delete,
				changed = vim.b.minidiff_summary.change,
			}
			self.has_changes = self.status_dict.added ~= 0
				or self.status_dict.deleted ~= 0
				or self.status_dict.changed ~= 0
		end,
		hl = "kobra_default_purple_rv",
		M.branch(),
		M.diff(),
	}
end

return M
