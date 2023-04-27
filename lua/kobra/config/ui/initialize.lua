local initialize = {}

initialize.notify = function()
  local util = require('kobra.util')
  if not util.has('noice.nvim') then
    util.on_very_lazy(function()
      vim.notify = require('notify')
    end)
  end
end

initialize.dressing = function()
  vim.ui.select = function(...)
    require('lazy').load({ plugins = { 'dressing.nvim' } })
    return vim.ui.select(...)
  end
  vim.ui.input = function(...)
    require('lazy').load({ plugins = { 'dressing.nvim' } })
    return vim.ui.input(...)
  end
end

initialize.navic = function()
  vim.g.navic_silence = true
  require('kobra.util').on_attach(function(client, buffer)
    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, buffer)
    end
  end)
end

return initialize
