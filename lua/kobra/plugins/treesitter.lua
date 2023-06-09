local M = {}

M[#M+1] = {
  'nvim-treesitter/nvim-treesitter',
  version = false,
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      init = function()
        local plugin = require('lazy.core.config').spec.plugins['nvim-treesitter']
        local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
        local enabled = false
        if opts.textobjects then
          for _, mod in ipairs({ 'move', 'select', 'swap', 'lsp_interop' }) do
            if opts.textobjects[mod] and opts.textobjects[mod].enable then
              enabled = true
              break
            end
          end
        end
        if not enabled then
          require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
        end
      end,
    },
  },
  keys = {
    { '<c-space>', desc = 'Increment selection' },
    { '<bs>', desc = 'Decrement selection', mode = 'x' },
  },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
    ensure_installed = {
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
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
  },
  config = function(_, opts)
    if type(opts.ensure_installed) == 'table' then
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then
          return false
        end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end
    require('nvim-treesitter.configs').setup(opts)
  end,
}

return M
