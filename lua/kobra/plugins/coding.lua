local M = {}

local conf = require('kobra.config.coding.config')
local opts = require('kobra.config.coding.opts')
local keys = require('kobra.config.coding.keys')

M[#M+1] = {
  'L3MON4D3/LuaSnip',
  build = (not jit.os:find('Windows'))
    and 'echo -e "NOTE: jsregexp is optional, so not a big deal if it fails to build\n"; make install_jsregexp'
    or nil,
  dependencies = {
    'rafamadriz/friendly-snippets',
    config = conf.friendly_snippets,
  },
  opts = opts.luasnip(),
  keys = keys.luasnip(),
}

M[#M+1] = {
  'hrsh7th/nvim-cmp',
  version = false,
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-calc',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-emoji',
    'ray-x/cmp-treesitter',
    'f3fora/cmp-spell',
    'octaltree/cmp-look',
  },
  opts = opts.cmp,
}

M[#M+1] = {
  'echasnovski/mini.pairs',
  event = 'VeryLazy',
  config = conf.mini_pairs,
}

M[#M+1] = {
  'echasnovski/mini.surround',
  keys = keys.mini_surround,
  opts = opts.mini_surround(),
  config = conf.mini_surround,
}

M[#M+1] = {
  'JoosepAlviste/nvim-ts-context-commentstring',
  lazy = true,
}

M[#M+1] = {
  'echasnovski/mini.comment',
  event = 'VeryLazy',
}

return M
