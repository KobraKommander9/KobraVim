local utils = require('heirline.utils')

local bufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. ': '
  end,
  hl = 'Comment',
}

local file_icon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon(filename, extension, { default = true })
  end,
  provider = function(self)
    return ' ' .. self.icon and (self.icon .. ' ')
  end,
  hl = 'UserDir',
}

local file_name = {
  provider = function(self)
    local filename = self.filename
    filename = filename == '' and '[No Name]'
      or vim.fn.fnamemodify(filename, ':t')
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

local file_flags = {
  {
    condition = function(self)
      return vim.api.nvim_buf_get_option(self.bufnr, 'modified')
    end,
    provider = '[+]',
    hl = { fg = 'UserGreen' },
  },
  {
    condition = function(self)
      return not vim.api.nvim_buf_get_option(self.bufnr, 'modifiable')
        or vim.api.nvim_buf_get_option(self.bufnr, 'readonly')
    end,
    provider = function(self)
      if vim.api.nvim_buf_get_option(self.bufnr, 'buftype') == 'terminal' then
        return '  '
      end
      return ''
    end,
    hl = { fg = 'UserRed' },
  },
}

local file_name_block = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return 'TabLineSel'
    else
      return 'TabLine'
    end
  end,
  bufnr,
  file_icon,
  file_name,
  file_flags,
}

local buffer_block = utils.surround({ '', '' },
  function(self)
    if self.is_active then
      return utils.get_highlight('TabLineSel').bg
    end
    return utils.get_highlight('TabLine').bg
  end,
  file_name_block
)

return utils.make_buflist(
  buffer_block,
  { provider = '', hl = { fg = 'UserGray' } },
  { provider = '', hl = { fg = 'UserGray' } }
)
