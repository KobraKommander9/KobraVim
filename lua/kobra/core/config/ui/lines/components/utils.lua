local utils = {}

local h_utils = require('heirline.utils')

local enclose = function(delimiters, color1, color2, component)
  component = h_utils.clone(component)

  local surround_color1 = function(self)
    if type(color1) == 'function' then
      return color1(self)
    else
      return color1
    end
  end

  local surround_color2 = function(self)
    if type(color2) == 'function' then
      return color2(self)
    else
      return color2
    end
  end

  return {
    {
      provider = delimiters[1],
      hl = function(self)
        local s_color = surround_color1(self)
        if s_color then
          return s_color
        end
      end,
    },
    component,
    {
      provider = delimiters[2],
      hl = function(self)
        local s_color = surround_color2(self)
        if s_color then
          return s_color
        end
      end,
    },
  }
end

local surround = function(delimiters, color, component)
  return enclose(delimiters, color, color, component)
end

utils.surround_mode = function(delimiters, component)
  return surround(delimiters, function(self) return self:mode_sep_color() end, component)
end

utils.surround = function(delimiters, color, component)
  return surround(delimiters, color, component)
end

utils.enclose = function(delimiters, lcolor, rcolor, component)
  return enclose(delimiters, lcolor, rcolor, component)
end

return utils
