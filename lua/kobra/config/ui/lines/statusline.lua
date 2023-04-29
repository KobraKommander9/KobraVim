local statusline = {}

local utils = require('heirline.utils')
local colors = require('kobra.config.ui.lines.colors')

statusline.statusline = function()
  require('heirline').load_colors(colors.colors())

  vim.api.nvim_create_augroup('Heirline', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      utils.on_colorscheme(colors.colors)
    end,
    group = 'Heirline',
  })

  local components = require('kobra.config.ui.lines.components')
  return vim.tbl_extend('force', components.parent(), components.statusline())
end

return statusline
