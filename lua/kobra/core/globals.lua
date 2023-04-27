local globals = {}

local defaults = {
  paths = {
    home = os.getenv('HOME'),
    data = string.format('%s/site', vim.fn.stdpath('data')),
    config = vim.fn.stdpath('config'),
    cache = vim.fn.stdpath('cache'),
  },
  layout = {
    colemak = true,
  },
}
local options

function globals.setup(opts)
  options = vim.tbl_deep_extend('force', defaults, opts or {})
end

setmetatable(globals, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    return options[key]
  end,
})

return globals
