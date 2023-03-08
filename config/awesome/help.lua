local help = {}

help.rrect = function(rad)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, rad)
  end
end

help.fg = function(text, color, thickness)
  return "<span foreground='" .. color .. "' font-weight='" .. thickness .. "'>" .. text .. "</span>"
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

help.screenshot = function()
  awful.spawn.easy_async_with_shell("scrot -s -l mode=edge -e 'xclip -selection clipboard -t image/png -i $f' /home/" ..
    os.getenv('USER') .. "/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H.%M.%S.png")
end

return help
