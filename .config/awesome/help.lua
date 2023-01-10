local help = {}

help.rrect = function(rad)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, rad)
  end
end

help.fg = function(text, color)
  if color == nil then
    color = '#000000'
  end
  return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

return help
