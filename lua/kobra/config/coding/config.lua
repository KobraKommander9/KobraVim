local M = {}

M.friendly_snippets = function()
  require('luasnip.loaders.from_vscode').lazy_load()
end

M.mini_pairs = function(_, opts)
  require('mini.pairs').setup(opts)
end

M.mini_surround = function(_, opts)
  require('mini.surround').setup(opts)
end

return M
