local statusline = {}

statusline.statusline = function()
  local utils = require('heirline.utils')
  local colors = require('kobra.core.config.ui.lines.colors')

  require('heirline').load_colors(colors.colors())

  vim.api.nvim_create_augroup('Heirline', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      utils.on_colorscheme(colors.colors)
    end,
    group = 'Heirline',
  })

  local components = require('kobra.core.config.ui.lines.components')
  return vim.tbl_extend('force', components.parent(), components.statusline())
end

return statusline
