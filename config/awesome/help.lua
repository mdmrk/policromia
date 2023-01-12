local help = {}

help.rrect = function(rad)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, rad)
  end
end

help.fg = function(text, color)
  return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

help.merge = function(first_table, second_table)
  for k, v in pairs(second_table) do first_table[k] = v end
end

help.write_to_file = function(path, content)
  local activethemefile = io.open(path, "w")
  if not activethemefile then
    return
  end
  activethemefile:write(content .. '\n')
  activethemefile:close()
end

help.randomize_wallpaper = function()
  awful.spawn.easy_async_with_shell("feh --bg-fill --randomize " ..
    beautiful.theme_dir .. beautiful.activetheme .. "/wallpapers/*")
end

return help
