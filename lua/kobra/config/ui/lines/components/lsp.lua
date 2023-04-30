local utils = require('kobra.config.ui.lines.components.utils')
local conditions = require('heirline.conditions')

local get_diag = function(icon, str)
  local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[str] })
  local count = #diagnostics

  return (count > 0) and icon .. ' ' .. count .. ' ' or ''
end

local lsp_status = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },
  provider = function()
    local lsp_val = ' LSP'
    -- local progress_ok, progress = pcall(require, 'lsp-progress')
    -- if progress_ok then
    --   lsp_val = progress.progress()
    -- end
    return lsp_val
  end,
  hl = 'UserRvWhite',
}

local lsp_error = {
  provider = function()
    return get_diag('', 'ERROR')
  end,
  hl = 'UserSLError',
}

local lsp_warn = {
  provider = function()
    return get_diag('', 'WARN')
  end,
  hl = 'UserSLWarn',
}

local lsp_info = {
  provider = function()
    return get_diag('', 'INFO')
  end,
  hl = 'UserSLInfo',
}

local lsp_hint = {
  provider = function()
    return get_diag('', 'HINT')
  end,
  hl = 'UserSLHint',
}

return {
  utils.enclose({ '', '' }, 'UserLSPSep', 'UserLSP', lsp_status),
  utils.surround({ '', '' }, 'UserLSPError', lsp_error),
  utils.surround({ '', '' }, 'UserLSPWarn', lsp_warn),
  utils.surround({ '', '' }, 'UserLSPInfo', lsp_info),
  utils.surround({ '', '' }, 'UserLSPHint', lsp_hint),
}
