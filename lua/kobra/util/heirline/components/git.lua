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
			hl = "kobra_default_git_add_rv",
		},
		{
			provider = function(self)
				local count = self.status_dict.removed or 0
				return count > 0 and ("-" .. count)
			end,
			hl = "kobra_default_git_del_rv",
		},
		{
			provider = function(self)
				local count = self.status_dict.changed or 0
				return count > 0 and ("~" .. count)
			end,
			hl = "kobra_default_git_change_rv",
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
			local git_summary = vim.b.minigit_summary or {}
			local diff_summary = vim.b.minidiff_summary or {}

			self.status_dict = {
				head = git_summary.head_name or "",
				added = diff_summary.add or 0,
				removed = diff_summary.delete or 0,
				changed = diff_summary.change or 0,
			}
			self.has_changes = self.status_dict.added ~= 0
				or self.status_dict.removed ~= 0
				or self.status_dict.changed ~= 0
		end,
		hl = "kobra_default_purple_rv",
		M.branch(),
		M.diff(),
	}
end

return M
