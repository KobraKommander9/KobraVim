require('kobra.core').init()

return {
  { 'folke/lazy.nvim', version = '*' },
  { 'KobraKommander9/KobraVim', priority = 10000, lazy = false, config = true, cond = true, version = '*' },
}
