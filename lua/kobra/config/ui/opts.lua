local opts = {}

opts.notify = function()
  return {
    stages = 'slide',
    render = 'minimal',
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  }
end

opts.noice = function()
  return {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  }
end

opts.alpha = function()
  return require('kobra.plugins.config.ui.start_screen').opts()
end

opts.navic = function()
  return {
    separator = ' ',
    highlight = true,
    depth_limit = 5,
    icons = require('kobra.core').icons.kinds,
  }
end

return opts
