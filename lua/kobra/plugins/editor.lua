local M = {}

local util = require('kobra.util')

-- better escape
M[#M+1] = {
  'max397574/better-escape.nvim',
  keys = { 'jk', 'qn' },
  opts = {
    mapping = { 'jk', 'qn' },
  }
}

-- global search and replace
M[#M+1] = {
  'nvim-pack/nvim-spectre',
  keys = {
    { '<leader>sr', function() require('spectre').open() end, desc = 'Replace in files (Spectre)' },
  },
}

-- fuzzy finder
M[#M+1] = {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  version = false,
  dependencies = {
    'nvim-telescope/telescope-live-grep-args.nvim',
  },
  keys = {
    { '<leader>/', util.telescope('live_grep'), desc = 'Grep (root dir)' },
    { '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
    -- find
    { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
    { '<leader>ff', util.telescope('files'), desc = 'Find Files (root dir)' },
    { '<leader>fF', util.telescope('files', { cwd = false }), desc = 'Find Files (cwd)' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent' },
    { '<leader>fR', util.telescope('oldfiles', { cwd = vim.loop.cwd() }), desc = 'Recent (cwd)' },
    -- git
    { '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'Commits' },
    { '<leader>gs', '<cmd>Telescope git_status<cr>', desc = 'Status' },
    -- search
    { '<leader>sa', '<cmd>Telescope autocommands<cr>', desc = 'Auto Commands' },
    { '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Buffer' },
    { '<leader>sc', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
    { '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
    { '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document Diagnostics' },
    { '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace Diagnostics' },
    { '<leader>sg', util.telescope('live_grep'), desc = 'Grep (root dir)' },
    { '<leader>sG', util.telescope('live_grep', { cwd = false }), desc = 'Grep (cwd)' },
    { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
    { '<leader>sH', '<cmd>Telescope highlights<cr>', desc = 'Search Highlight Groups' },
    { '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
    { '<leader>sM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
    { '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to Mark' },
    { '<leader>so', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
    { '<leader>sR', '<cmd>Telescope resume<cr>', desc = 'Resume' },
    { '<leader>sw', util.telescope('grep_string'), desc = 'Word (root dir)' },
    { '<leader>sW', util.telescope('grep_string', { cwd = false }), desc = 'Word (cwd)' },
    { '<leader>uC', util.telescope('colorscheme', { enable_preview = true }), desc = 'Colorscheme with preview' },
    {
      '<leader>ss',
      util.telescope('lsp_document_symbols', {
        symbols = {
          'Class',
          'Function',
          'Method',
          'Constructor',
          'Interface',
          'Module',
          'Struct',
          'Trait',
          'Field',
          'Property',
        },
      }),
      desc = 'Goto Symbol',
    },
    {
      '<leader>sS',
      util.telescope('lsp_dynamic_workspace_symbols', {
        symbols = {
          'Class',
          'Function',
          'Method',
          'Constructor',
          'Interface',
          'Module',
          'Struct',
          'Trait',
          'Field',
          'Property',
        },
      }),
      desc = 'Goto Symbol (Workspace)',
    },
    { '<leader>st', '<cmd>lua require"telescope".extensions.live_grep_args.live_grep_args{}<cr>', 'Text (args)' },
  },
  opts = function(_, opts)
    opts.defaults = {
      prompt_prefix = ' ',
      selection_caret = ' ',
    }

    local layouts = require('kobra.core').layouts
    local n, p, j, k
    if layouts.colemak then
      n, p, j, k = 'j', 'k', 'n', 'e'
    else
      n, p, j, k = 'n', 'p', 'j', 'k'
    end

    opts.mappings = {
      i = {
        ['<c-' .. n .. '>'] = function(...)
          return require('telescope.actions').cycle_history_next(...)
        end,
        ['<c-' .. p .. '>'] = function(...)
          return require('telescope.actions').cycle_history_prev(...)
        end,
        ['<c-' .. j .. '>'] = function(...)
          return require('telescope.actions').move_selection_next(...)
        end,
        ['<c-' .. k .. '>'] = function(...)
          return require('telescope.actions').move_selection_previous(...)
        end,
        ['<c-b>'] = function(...)
          return require('telescope.actions').file_split(...)
        end,
        ['<c-x>'] = function(...)
          return require('telescope.actions').delete_buffer(...)
        end,
        ['<c-i>'] = function()
          return require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' --iglob ' })
        end,
      },
      n = {
        q = function(...)
          return require('telescope.actions').close(...)
        end,
      },
    }

    return opts
  end
}

-- file browser
M[#M+1] = {
  'telescope.nvim',
  event = { 'DirChangedPre', 'BufNewFile' },
  dependencies = {
    {
      'nvim-telescope/telescope-file-browser.nvim',
      event = 'VeryLazy',
      config = function()
        require('telescope').load_extension('file_browser')
      end,
      keys = {
        { '<leader>ff', '<cmd>Telescope file_browser path=%:p:h hidden=true<cr>', 'Find Browser' },
      },
    },
  },
  opts = function(_, opts)
    local extensions = opts.extensions or {}

    extensions.file_browser = {
      hijack_netrw = true,
      grouped = true,
      display_stat = false,
      hidden = true,
    }
    opts.extensions = extensions

    if require('kobra.core').layouts.colemak then
      local actions = require('telescope').extensions.file_browser.actions
      opts.extensions.file_browser.mappings = {
        i = {
          ['<C-a>'] = actions.create,
          ['<C-r>'] = actions.rename,
          ['<C-y>'] = actions.copy,
          ['<C-x>'] = actions.remove,
          ['<C-h>'] = actions.toggle_hidden,
        },
      }
    end

    return opts
  end,
}

-- easily jump to any location and enhanced f/t motions for leap
M[#M+1] = {
  'ggandor/flit.nvim',
  keys = function()
    local ret = {}
    for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
      ret[#ret+1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
    end
    return ret
  end,
  opts = { labeled_modes = 'nx' },
}

M[#M+1] = {
  'ggandor/leap.nvim',
  keys = {
    { 's', mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
    { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
    { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
  },
  config = function(_, opts)
    local leap = require('leap')
    for k, v in pairs(opts) do
      leap.opts[k] = v
    end

    leap.add_default_mappings(true)
    vim.keymap.del({ 'x', 'o' }, 'x')
    vim.keymap.del({ 'x', 'o' }, 'X')
  end,
}

-- which key
M[#M+1] = {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { 'n', 'v' },
      ['g'] = { name = '+goto' },
      ['gz'] = { name = '+surround' },
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      ['<leader>a'] = { name = '+tabs' },
      ['<leader>b'] = { name = '+buffer' },
      ['<leader>c'] = { name = '+code' },
      ['<leader>f'] = { name = '+file/find' },
      ['<leader>g'] = { name = '+git' },
      ['<leader>gh'] = { name = '+hunks' },
      ['<leader>q'] = { name = '+quit/session' },
      ['<leader>s'] = { name = '+search' },
      ['<leader>u'] = { name = '+ui' },
      ['<leader>w'] = { name = '+windows' },
      ['<leader>x'] = { name = '+diagnostics/quickfix' },
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}

-- git signs
M[#M+1] = {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      map('n', ']h', gs.next_hunk, 'Next Hunk')
      map('n', '[h', gs.prev_hunk, 'Prev Hunk')
      map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
      map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
      map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
      map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
      map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
      map('n', '<leader>ghp', gs.preview_hunk, 'Preview Hunk')
      map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, 'Blame Line')
      map('n', '<leader>ghd', gs.diffthis, 'Diff This')
      map('n', '<leader>ghD', function() gs.diffthis('~') end, 'Diff This ~')
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
    end,
  },
}

-- references
M[#M+1] = {
  'RRethy/vim-illuminate',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = { delay = 200 },
  config = function(_, opts)
    require('illuminate').configure(opts)

    local function map(key, dir, buffer)
      vim.keymap.set('n', key, function()
        require('illuminate')['goto_' .. dir .. '_reference'](false)
      end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
    end

    map(']]', 'next')
    map('[[', 'prev')

    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        map(']]', 'next', buffer)
        map('[[', 'prev', buffer)
      end
    })
  end,
  keys = {
    { ']]', desc = 'Next Reference' },
    { '[[', desc = 'Prev Reference' },
  },
}

-- todo comments
M[#M+1] = {
  'folke/todo-comments.nvim',
  cmd = { 'TodoTelescope' },
  event = { 'BufReadPost', 'BufNewFile' },
  config = true,
  keys = {
    { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
    { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
    { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
    { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
  },
}

return M
