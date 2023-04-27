local type_hl = function()
  return {
    File = 'Directory',
    Module = '@include',
    Namespace = '@namespace',
    Package = '@include',
    Class = '@structure',
    Method = '@method',
    Property = '@property',
    Field = '@field',
    Constructor = '@constructor',
    Enum = '@field',
    Interface = '@type',
    Function = '@function',
    Variable = '@variable',
    Constant = '@constant',
    String = '@string',
    Number = '@number',
    Boolean = '@boolean',
    Array = '@field',
    Object = '@type',
    Key = '@keyword',
    Null = '@comment',
    EnumMember = '@field',
    Struct = '@structure',
    Event = '@keyword',
    Operator = '@operator',
    TypeParameter = '@type',
  }
end

return {
  condition = function() return require('nvim-navic').is_available() end,
  static = {
    type_hl = type_hl(),
    enc = function(line, col, winnr)
      return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
    end,
    dec = function(c)
      local line = bit.rshift(c, 16)
      local col = bit.band(bit.rshift(c, 6), 1023)
      local winnr = bit.band(c,  63)
      return line, col, winnr
    end,
  },
  init = function(self)
    local data = require('nvim-navic').get_data() or {}
    local children = {}

    for i, d in ipairs(data) do
      local child = {
        { provider = d.icon, hl = self.type_hl[d.type] },
        { provider = d.name:gsub('%%', '%%%%'):gsub('%s*->%s*', '') },
      }

      if #data > 1 and i < #data then
        table.insert(child, {
          provider = ' > ',
          hl = { fg = 'bright_fg' },
        })
      end
      table.insert(children, child)
    end

    self.child = self:new(children, 1)
  end,
  provider = function(self)
    return self.child:eval()
  end,
  hl = { fg = 'bright_fg' },
  update = 'CursorMoved',
}
