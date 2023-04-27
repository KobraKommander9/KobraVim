local M = {}

local ts_ensure_installed = {
  'bash',
  'go',
  'css',
  'html',
  'javascript',
  'typescript',
  'jsdoc',
  'json',
  'c',
  'java',
  'toml',
  'tsx',
  'lua',
  'cpp',
  'python',
  'rust',
  'jsonc',
  'yaml',
  'sql',
  'vue',
  'vim',
  'fish',
  'markdown',
  'proto',
}

M.treesitter = function()
  return {
    highlight = { enable = true },
    indent = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
    ensure_installed = ts_ensure_installed,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
  }
end

return M
