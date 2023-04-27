local conditions = require('heirline.conditions')

local shorten = function(head)
  if string.find(head, '/') then
    return string.sub(head, string.find(head, '/') + 1)
  end

  if not string.find(head, '-') then
    return head
  end

  local parts = vim.split(head, '-')
  if #parts > 2 then
    return parts[1] .. '-' .. parts[#parts-1]
  end

  return parts[1]
end

return {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0
      or self.status_dict.removed ~= 0
      or self.status_dict.changed ~= 0
  end,
  hl = 'UserPurpleN',
  {
    provider = function(self)
      return ' ' .. shorten(self.status_dict.head)
    end,
    hl = { bold = true },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = '(',
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ('+' .. count)
    end,
    hl = { fg = 'UserGreen' },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ('-' .. count)
    end,
    hl = { fg = 'UserRed' },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ('~' .. count)
    end,
    hl = { fg = 'UserYellow' },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ')',
  },
}
