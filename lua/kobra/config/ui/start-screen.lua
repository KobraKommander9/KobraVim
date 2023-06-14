local screen = {}

local function scandir(dir)
  local t = {}
  local i = 0
  for fn in vim.fs.dir(dir) do
    if fn == '.' or fn == '..' or fn == '.DS_Store' then goto continue end

    i = i + 1
    t[i] = dir .. fn

    ::continue::
  end

  return t
end

local function exists(file)
  file = vim.fn.expand(file)
  local ok, _, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
    return false
  end
  return true
end

local function isdir(path)
  return exists(path..'/')
end

local telescope_cmd = function(path)
  if isdir(path) then
    return '<cmd>cd ' .. path .. ' | Telescope file_browser hidden=true path=%:p:h<cr>'
  end
  return '<cmd>e ' .. path
end

local get_folders = function(prefix, dir)
  local startify = require('alpha.themes.startify')
  local files = scandir(dir .. '/')

  local buttons = {}
  for i, fn in ipairs(files) do
    local ico_txt
    local fb_hl = {}

    local ico, hl = startify.icon(fn)
    local hl_option_type = type(startify.nvim_web_devicons.highlight)

    if hl_option_type == 'boolean' then
      if hl and startify.nvim_web_devicons.highlight then
        table.insert(fb_hl, { hl, 0, #ico })
      end
    end

    if hl_option_type == 'string' then
      table.insert(fb_hl, { startify.nvim_web_devicons.highlight, 0, #ico })
    end

    ico_txt = ico .. ' '

    local short_fn = vim.fn.fnamemodify(fn, ':~')
    local file_button_el = startify.button(prefix .. tostring(i), ico_txt .. short_fn, telescope_cmd(fn))
    local fn_start = short_fn:match('.*[/\\]')
    if fn_start ~= nil then
      table.insert(fb_hl, { 'Comment', #ico_txt, #fn_start + #ico_txt })
    end

    file_button_el.opts.hl = fb_hl
    buttons[i] = file_button_el
  end

  return {
    type = 'group',
    val = buttons,
  }
end

local get_sessions = function()
  local startify = require('alpha.themes.startify')
  local query = require('possession.query')
  return query.alpha_workspace_layout(require('kobra.core').start_screen.workspaces, startify.button, {
    others_name = 'Other Sessions',
  })
end

local get_extension = function(fn)
  local match = fn:match('^.+(%..+)$')
  local ext = ''
  if match ~= nil then
    ext = match:sub(2)
  end
  return ext
end

local get_mru = function()
  local startify = require('alpha.themes.startify')

  local opts = startify.mru_opts
  local items_number = 5
  local old_files = {}
  for _, v in pairs(vim.v.oldfiles) do
    if #old_files == items_number then
      break
    end

    local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
    if (vim.fn.filereadable(v) == 1) and not ignore then
      old_files[#old_files+1] = v
    end
  end

  local tbl = {}
  for i, fn in ipairs(old_files) do
    local short_fn = vim.fn.fnamemodify(fn, ':~')
    local file_button_el = startify.file_button(fn, 'r' .. tostring(i), short_fn, opts.autocd)
    tbl[i] = file_button_el
  end

  return {
    type = 'group',
    val = tbl,
    opts = {},
  }
end

local kobra = {
  [[ █████  ████     ████             █████                              ]],
  [[ █████ ████      █████              █████      ██                     ]],
  [[  ████████       █████               █████                             ]],
  [[  ███████  ███ █████   ██ █ ██ ███████ ███   ███████████   ]],
  [[  █████████ ███████████ █████████████████ █████ ██████████████   ]],
  [[ █████████ ████ ██ ██████  ███ ███████ █████ █████ ████ █████   ]],
  [[ ████ ████ ████ ██ ████ ██  █████████ █████ █████ ████ █████  ]],
  [[ ██████  ██████████████████ ██████████████ █████ █████ ████ ██████ ]],
}

local header = {
  type = 'text',
  val = function()
    local h = require("kobra.core").start_screen.header
    if h ~= false then
      return h
    end
    return ""
  end,
  opts = {
    hl = 'Type',
    shrink_margin = false,
  },
}

local get_buttons = function(buttons)
  local startify = require('alpha.themes.startify')
  local tbl = {}

  if type(buttons) == "table" then
    local opts = buttons
    local ordered = {}
    for button, _ in pairs(opts) do
      if type(button) == "string" then
        table.insert(ordered, button)
      end
    end
    table.sort(ordered)

    for _, key in ipairs(ordered) do
      local data = opts[key]

      if type(data) == "string" and data == "new_file" then
        table.insert(tbl, startify.button(key, 'New file', ':ene <BAR> startinsert <CR>'))
      elseif type(data) == "string" and data == "quit" then
        table.insert(tbl, startify.button(key, "Quit NVIM", ":qa<CR>"))
      elseif type(data) == "table" and #data == 2 and (exists(data[2]) or isdir(data[2])) then
        table.insert(tbl, startify.button(key, data[1], telescope_cmd(data[2])))
      end
    end
  end

  return tbl
end

local top_buttons = function()
  return get_buttons(require("kobra.core").start_screen.buttons)
end

local bottom_buttons = function()
  return get_buttons(require("kobra.core").start_screen.bottom_buttons)
end

local function folder_groups()
  local groups = {}

  for _, folder in ipairs(require('kobra.core').start_screen.folders) do
    if #folder == 2 and isdir(folder[2]) then
      table.insert(groups, {
        type = 'group',
        val = {
          { type = 'padding', val = 1 },
          { type = 'text', val = folder[1], opts = { hl = 'SpecialComment' } },
          { type = 'padding', val = 1 },
          {
            type = 'group',
            val = function()
              return { get_folders('', folder[2]) }
            end,
          },
        },
      })
    end

    if #folder == 3 and isdir(folder[3]) then
      table.insert(groups, {
        type = 'group',
        val = {
          { type = 'padding', val = 1 },
          { type = 'text', val = folder[1], opts = { hl = 'SpecialComment' } },
          { type = 'padding', val = 1 },
          {
            type = 'group',
            val = function()
              return { get_folders(folder[2], folder[3]) }
            end,
          },
        },
      })
    end
  end

  table.insert(groups, {
    type = 'group',
    val = require('possession.utils').throttle(get_sessions, 5000),
  })

  return groups
end

local section = {
  header = header,
  top_buttons = {
    type = 'group',
    val = top_buttons,
  },
  folders = {
    type = 'group',
    val = folder_groups,
  },
  mru = {
    type = 'group',
    val = {
      { type = 'padding', val = 1 },
      { type = 'text', val = 'Recent Files', opts = { hl = 'SpecialComment' } },
      { type = 'padding', val = 1 },
      {
        type = 'group',
        val = function()
          return { get_mru() }
        end,
      },
    },
  },
  bottom_buttons = {
    type = 'group',
    val = bottom_buttons,
  },
  footer = {
    type = 'text',
    val = '',
  },
}

local config = {
  layout = {
    { type = 'padding', val = 1 },
    section.header,
    { type = 'padding', val = 1 },
    section.top_buttons,
    section.folders,
    section.mru,
    { type = 'padding', val = 1 },
    section.bottom_buttons,
    { type = 'padding', val = 1 },
    section.footer,
  },
  opts = {
    margin = 3,
    redraw_on_size = false,
    setup = function()
      vim.api.nvim_create_autocmd('DirChanged', {
        pattern = '*',
        group = 'alpha_temp',
        callback = function () require('alpha').redraw() end,
      })
    end,
  },
}

screen.fun = {
  scandir = scandir,
  get_folders = get_folders,
  get_sessions = get_sessions,
}
screen.kobra = kobra
screen.section = section
screen.config = config

return screen
