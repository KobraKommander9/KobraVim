require('kobra.core').init()

local M = {}

local init = require('kobra.config.core.initialize')
local keys = require('kobra.config.core.keys')
local opts = require('kobra.config.core.opts')
local conf = require('kobra.config.core.config')

M[#M+1] = { 'folke/lazy.nvim', version = '*' }

M[#M+1] = {
  'nvim-treesittter/nvim-treesitter',
  version = false,
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      init = init.treesitter_textobjects,
    },
  },
  keys = keys.treesitter(),
  opts = opts.treesitter(),
  config = conf.treesitter,
}

return M
