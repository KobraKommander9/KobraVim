local colors = {}

local fmt = string.format
local utils = require('heirline.utils')

local hex = function(n)
  if n then
    return fmt('#%06x', n)
  end
end

local function parse_style(style)
  if not style or style == 'NONE' then
    return {}
  end

  local result = {}
  for token in string.gmatch(style, '([^,]+)') do
    result[token] = true
  end

  return result
end

local function get_highlight(name)
  local hl = vim.api.nvim_get_hl_by_name(name, true)
  if hl.link then
    return get_highlight(hl.link)
  end

  local result = parse_style(hl.style)
  result.fg = hl.foreground and hex(hl.foreground)
  result.bg = hl.background and hex(hl.background)
  result.sp = hl.special and hex(hl.special)

  return result
end

local function generate_pallet_from_colorscheme()
  local color_map = {
    black   = { index = 0,  default = '#393b44' },
    red     = { index = 1,  default = '#c94f6d' },
    green   = { index = 2,  default = '#81b29a' },
    yellow  = { index = 3,  default = '#dbc074' },
    blue    = { index = 4,  default = '#719cd6' },
    magenta = { index = 5,  default = '#9d79d6' },
    cyan    = { index = 6,  default = '#63cdcf' },
    white   = { index = 7,  default = '#dfdfe0' },
    gray    = { index = 8,  default = '#484848' },
    pink    = { index = 9,  default = '#f16da6' },
    teal    = { index = 10, default = '#45c880' },
    purple  = { index = 13, default = '#c8a5ff' },
  }

  local diagnostic_map = {
    hint = { hl = 'DiagnosticHint', default = color_map.green.default },
    info = { hl = 'DiagnosticInfo', default = color_map.blue.default },
    warn = { hl = 'DiagnosticWarn', default = color_map.yellow.default },
    error = { hl = 'DiagnosticError', default = color_map.red.default },
  }

  local pallet = {}
  for name, value in pairs(color_map) do
    local global_name = 'terminal_color_' .. value.index
    pallet[name] = vim.g[global_name] and vim.g[global_name] or value.default
  end

  for name, value in pairs(diagnostic_map) do
    pallet[name] = get_highlight(value.hl).fg or value.default
  end

  pallet.sl = get_highlight('StatusLine')
  pallet.sel = get_highlight('TabLineSel')
  pallet.dir = get_highlight('Directory')

  return pallet
end

local create_highlights = function()
  local pal = generate_pallet_from_colorscheme()

  local sl_colors = {
    Black   = { fg = pal.black,   bg = pal.white },
    Red     = { fg = pal.red,     bg = pal.sl.bg },
    Green   = { fg = pal.green,   bg = pal.sl.bg },
    Yellow  = { fg = pal.yellow,  bg = pal.sl.bg },
    Blue    = { fg = pal.blue,    bg = pal.sl.bg },
    Magenta = { fg = pal.magenta, bg = pal.sl.bg },
    Cyan    = { fg = pal.cyan,    bg = pal.sl.bg },
    White   = { fg = pal.white,   bg = pal.black },
    Gray    = { fg = pal.gray,    bg = pal.sl.bg },
    Pink    = { fg = pal.pink,    bg = pal.sl.bg },
    Teal    = { fg = pal.teal,    bg = pal.sl.bg },
    Purple  = { fg = pal.purple,  bg = pal.sl.bg },
  }

  local status = vim.o.background == 'dark' and { fg = pal.black, bg = pal.white } or { fg = pal.white, bg = pal.black }

  local res = {}
  for name, value in pairs(sl_colors) do
    res['User' .. name] = { fg = value.fg, bg = value.bg, bold = true }
    res['User' .. name .. 'N'] = { fg = value.fg, bg = value.bg }
    res['User' .. name .. 'Sep'] = { fg = value.fg, bg = pal.sel.fg, bold = true }
    res['UserRv' .. name] = { fg = value.bg, bg = value.fg, bold = true }
    res['User' .. name .. 'Gray'] = { fg = value.fg, bg = pal.gray, bold = true }
  end

  local groups = {
    UserDir = { fg = pal.blue, bg = pal.gray, bold = true },
    UserDirSep = { fg = pal.gray, bg = pal.sl.bg },
    UserSL = { fg = pal.sel.fg, bg = pal.sl.bg },

    UserLSPSep = { fg = sl_colors.White.fg, bg = pal.sl.bg },
    UserLSP = { fg = pal.error, bg = sl_colors.White.fg },
    UserLSPError = { fg = pal.warn, bg = pal.error },
    UserLSPWarn = { fg = pal.info, bg = pal.warn },
    UserLSPInfo = { fg = pal.hint, bg = pal.info },
    UserLSPHint = { fg = pal.sel.bg, bg = pal.hint },

    UserSLHint = { fg = pal.sl.bg, bg = pal.hint, bold = true },
    UserSLInfo = { fg = pal.sl.bg, bg = pal.info, bold = true },
    UserSLWarn = { fg = pal.sl.bg, bg = pal.warn, bold = true },
    UserSLError = { fg = pal.sl.bg, bg = pal.error, bold = true },
    UserSLStatus = { fg = status.fg, bg = status.bg, bold = true },

    UserSLFtHint = { fg = pal.sel.bg, bg = pal.hint },
    UserSLHintInfo = { fg = pal.hint, bg = pal.info },
    UserSLInfoWarn = { fg = pal.info, bg = pal.warn },
    UserSLWarnError = { fg = pal.warn, bg = pal.error },
    UserSLErrorStatus = { fg = pal.error, bg = status.bg },
    UserSLStatusBg = { fg = status.bg, bg = pal.sl.bg },
    UserSLStatusBgSep = { fg = status.bg, bg = pal.sel.fg },

    UserSLAlt = { fg = pal.sel.fg, bg = pal.sel.bg, bold = true },
    UserSLAltSep = { fg = pal.sel.bg, bg = pal.sl.bg },
    UserSLGitBranch = { fg = pal.yellow, bg = pal.sl.bg },
  }

  return vim.tbl_extend('force', res, groups)
end

colors.colors = function()
  local highlights = create_highlights()
  local gen = {}
  for name, value in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, value)
    gen[name] = value.fg
    gen[name .. 'Bg'] = value.bg
  end

  local default = {
    bright_bg = utils.get_highlight('Folded').bg,
    bright_fg = utils.get_highlight('Folded').fg,
    red = utils.get_highlight('DiagnosticError').fg,
    dark_red = utils.get_highlight('DiffDelete').bg,
    green = utils.get_highlight('String').fg,
    blue = utils.get_highlight('Function').fg,
    gray = utils.get_highlight('NonText').fg,
    orange = utils.get_highlight('Constant').fg,
    purple = utils.get_highlight('Statement').fg,
    cyan = utils.get_highlight('Special').fg,
    diag_warn = utils.get_highlight('DiagnosticWarn').fg,
    diag_error = utils.get_highlight('DiagnosticError').fg,
    diag_hint = utils.get_highlight('DiagnosticHint').fg,
    diag_info = utils.get_highlight('DiagnosticInfo').fg,
  }

  return vim.tbl_extend('force', default, gen)
end

return colors
