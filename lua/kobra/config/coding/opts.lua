local M = {}

M.luasnip = function()
  return {
    history = true,
    delete_check_events = 'TextChanged',
  }
end

M.cmp = function()
  local cmp = require('cmp')

  local opts = {
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expang(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
      { name = 'rg', keyword_length = 4 },
      { name = 'nvim_lua' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'calc' },
      { name = 'spell', keyword_length = 5 },
      { name = 'buffer', keyword_length = 5 },
      { name = 'path' },
    },
    formatting = {
      format = function(_, item)
        local icons = require('kobra.core').icons.kinds
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end
        return item
      end,
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
  }

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    })
  })

  return opts
end

M.mini_surround = function()
  return {
    mappings = {
      add = 'gza', -- Add surrounding in Normal and Visual modes
      delete = 'gzd', -- Delete surrounding
      find = 'gzf', -- Find surrounding (to the right)
      find_left = 'gzF', -- Find surrounding (to the left)
      highlight = 'gzh', -- Highlight surrounding
      replace = 'gzr', -- Replace surrounding
      update_n_lines = 'gzn', -- Update `n_lines`
    },
  }
end

return M
