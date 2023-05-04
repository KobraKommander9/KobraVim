KobraVim is heavily inspired by [LazyVim](https://github.com/LazyVim/LazyVim) and powered by 💤[lazy.nvim](https://github.com/folke/lazy.nvim). You can get started with the [starter](https://github.com/KobraKommander9/KobraVim-starter).

This is configured the same way as LazyVim, except there are a few different values or options, as this comes with sensible defaults for [colemak](https://colemak.com/) users. The defaults:
```
local defaults = {
  colorscheme = 'carbonfox',
  ui = {
    background = 'transparent',
  },
  defaults = {
    autocmds = true,
    keymaps = true,
  },
  paths = {
    home = os.getenv('HOME'),
    data = vim.fn.stdpath('data') .. '/site',
    config = vim.fn.stdpath('config'),
    cache = vim.fn.stdpath('cache'),
  },
  layouts = {
    colemak = false,
  },
  start_screen = {
    dot_files = '~/dot-files',
    folders = {
      { 'Projects', '~/Projects' },
    },
    workspaces = {
      {
        'Project Sessions',
        'p',
        '~/Projects',
      },
      {
        'Dotfile Sessions',
        'd',
        '~/dotfiles',
      },
    },
  },
  icons = {
    diagnostics = {
      Error = ' ',
      Warn = ' ',
      Hint = ' ',
      Info = ' ',
    },
    git = {
      added = ' ',
      modified = ' ',
      removed = ' ',
    },
    kinds = {
      Array = ' ',
      Boolean = ' ',
      Class = ' ',
      Color = ' ',
      Constant = ' ',
      Constructor = ' ',
      Copilot = ' ',
      Enum = ' ',
      EnumMember = ' ',
      Event = ' ',
      Field = ' ',
      File = ' ',
      Folder = ' ',
      Function = ' ',
      Interface = ' ',
      Key = ' ',
      Keyword = ' ',
      Method = ' ',
      Module = ' ',
      Namespace = ' ',
      Null = ' ',
      Number = ' ',
      Object = ' ',
      Operator = ' ',
      Package = ' ',
      Property = ' ',
      Reference = ' ',
      Snippet = ' ',
      String = ' ',
      Struct = ' ',
      Text = ' ',
      TypeParameter = ' ',
      Unit = ' ',
      Value = ' ',
      Variable = ' ',
    },
  },
}
```
