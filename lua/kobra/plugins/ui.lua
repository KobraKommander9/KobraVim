local M = {}

local keys = require('kobra.config.ui.keys')
local opts = require('kobra.config.ui.opts')
local init = require('kobra.config.ui.initialize')
local conf = require('kobra.config.ui.config')

M[#M+1] = {
  'rcarriga/nvim-notify',
  keys = keys.notify(),
  opts = opts.notify(),
  init = init.notify,
}

M[#M+1] = {
  'stevearc/dressing.nvim',
  lazy = true,
  init = init.dressing,
}

M[#M+1] = {
  'rebelot/heirline.nvim',
  event = 'VeryLazy',
  config = conf.heirline,
}

M[#M+1] = {
  'nanozuki/tabby.nvim',
  event = 'VeryLazy',
  keys = keys.tabby(),
  config = conf.tabby,
}

M[#M+1] = {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    {
      'folke/which-key.nvim',
      opts = require('kobra.plugins.config.core.opts').which_key,
    },
  },
  opts = opts.noice(),
  keys = keys.noice(),
}

M[#M+1] = {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  opts = opts.alpha,
  config = conf.alpha,
}

M[#M+1] = {
  'SmiteshP/nvim-navic',
  lazy = true,
  init = init.navic,
  opts = opts.navic,
}

M[#M+1] = {
  'nvim-tree/nvim-web-devicons',
  lazy = true,
}

M[#M+1] = {
  'MunifTanjim/nui.nvim',
  lazy = true,
}

return M
