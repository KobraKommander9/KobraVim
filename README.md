<img width="1792" alt="image" src="https://user-images.githubusercontent.com/118004611/236312846-acfe9254-d6ac-497b-bba3-f01d3bf153b9.png">

KobraVim is heavily inspired by [LazyVim](https://github.com/LazyVim/LazyVim) and powered by 💤[lazy.nvim](https://github.com/folke/lazy.nvim). You can get started with the [starter](https://github.com/KobraKommander9/KobraVim-starter).

This is configured the same way as LazyVim, except there are a few different values or options, as this comes with sensible defaults for [colemak](https://colemak.com/) users. The defaults:

```lua
local defaults = {
  colorscheme = 'carbonfox',
  ui = {
    background = 'transparent', -- set this to anything but 'transparent' for it to use your colorscheme background
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
    colemak = false, -- set this to true if a colemak user
  },
  start_screen = {
    dot_files = '~/dot-files', -- the location of your dot files
    folders = { -- folders you want to have show up on the start screen
      { 'Projects', '~/Projects' }, -- each value should be of the format: { title, path }
      { 'Matrix', 'm', '~/Matrix' }, -- or of the format: { title, prefix, path }
    },
    workspaces = { -- workspaces for start screen session display
      { -- each should be of the format: { title, key, path }
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

## Troubleshooting

If something isn't working correctly, first try running `:checkhealth kobra`. If the issue persists, open a ticket.
