local screen = {}

local alpha_ok, alpha = pcall(require, 'alpha')
if not alpha_ok then
  return
end

local startify_ok, startify = pcall(require, 'alpha.themes.startify')
if not startify_ok then
  return
end

local utils_ok, utils = pcall(require, 'possession.utils')
if not utils_ok then
  return
end

local query_ok, query = pcall(require, 'possession.query')
if not query_ok then
  return
end

local workspaces = {
  {
    'Project Sessions',
    'p',
    '~/Projects/',
  },
  {
    'Dotfile Sessions',
    'd',
    '~/dot-files/',
  },
}

local kobra = {
  [[                                                                             ]],
	[[ █████  ████     ████             █████                             ]],
	[[ █████ ████      █████              █████      ██                     ]],
	[[  ████████       █████               █████                             ]],
	[[  ███████  ███ █████   ██ █ ██ ███████ ███   ███████████   ]],
	[[  █████████ ███████████ █████████████████ █████ ██████████████   ]],
	[[ █████████ ████ ██ ██████  ███ ███████ █████ █████ ████ █████   ]],
	[[ ████ ████ ████ ██ ████ ██  █████████ █████ █████ ████ █████  ]],
	[[ ██████  ██████████████████ ██████████████ █████ █████ ████ ██████ ]],
  [[                                                                             ]],
}

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

local get_projects = function()
  local files = scandir('~/Projects/')

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
    local cd_cmd = ' | cd %:p:h'
    local file_button_el = startify.button(tostring(i), ico_txt .. short_fn, '<cmd>e ' .. fn .. cd_cmd .. '<cr>')
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
  return query.alpha_workspace_layout(workspaces, startify.button, {
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

function screen.opts()
  startify.section.header = {
    type = 'text',
    val = kobra,
    opts = {
      hl = 'Type',
      shrink_margin = false,
    }
  }

  startify.section.top_buttons.val = {
    startify.button('f', 'New file', ':ene <BAR> startinsert <CR>'),
    startify.button('df', 'Dot Files', '<cmd>e ~/dot-files/ | cd %:p:h<cr>')
  }

  startify.section.mru.val[2].val = 'Recent Files'
  startify.section.mru.val[4].val = function()
    return { get_mru() }
  end

  -- disable MRU cwd
  startify.section.mru_cwd.val = {{ type = 'padding', val = 0 }}

  startify.section.bottom_buttons.val = {
    startify.button('q', 'Quit NVIM', ':qa<CR>'),
  }

  startify.section.footer = {
    { type = 'text', val = 'footer' },
  }

  local config = startify.config
  config.layout[2] = {
    type = 'text',
    val = kobra,
    opts = {
      hl = 'Type',
      shrink_margin = false,
    }
  }

  table.insert(config.layout, 5, {
    type = 'group',
    val = {
      { type = 'padding', val = 1 },
      { type = 'text', val = 'Projects', opts = { hl = 'SpecialComment' } },
      { type = 'padding', val = 1 },
      {
        type = 'group',
        val = function()
          return { get_projects() }
        end,
      },
    },
  })

  table.insert(config.layout, 6, {
    type = 'group',
    val = utils.throttle(get_sessions, 5000),
  })

  return config
end

screen.fun = {
  scandir = scandir,
  get_projects = get_projects,
  get_sessions = get_sessions,
}

return screen
