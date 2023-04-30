local M = {}

M[#M+1] = {
  'ray-x/go.nvim',
  ft = { 'go', 'go.mod' },
  opts = {
    fillstruct = 'gopls',
    dap_debug = true,
    goimport = 'gopls',
    dap_debug_vt = 'true',
    dap_debug_gui = true,
    test_runner = 'go',
    luasnip = true,
  },
}

M[#M+1] = {
  'nvim-treesitter/nvim-treesitter',
  opts = function(_, opts)
    if type(opts.ensure_installed) == 'table' then
      vim.list_extend(opts.ensure_installed, { 'go', 'proto' })
    end
  end,
}

M[#M+1] = {
  'neovim/nvim-lspconfig',
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            directoryFilters = {
              '-**/plz-out',
              '-**/node_modules',
            },
          },
        },
        init_options = {
          completeUnimported = true,
        },
      },
    },
  },
}

return M
