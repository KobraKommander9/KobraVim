local M = {}

local conf = require('kobra.config.util.config')

M[#M+1] = {
  'dstein64/vim-startuptime',
  cmd = 'StartupTime',
  config = conf.startup_time,
}

M[#M+1] = {
  'jedrzejboczar/possession.nvim',
  cmd = {
    'PossessionSave',
    'PossessionLoad',
    'PossessionClose',
    'PossessionDelete',
    'PossessionShow',
    'PossessionList',
    'PossessionMigrate',
  },
  config = conf.possession,
}

M[#M+1] = {
  'nvim-lua/plenary.nvim',
  lazy = true,
}

M[#M+1] = {
  'tpope/vim-repeat',
  event = 'VeryLazy',
}

return M
