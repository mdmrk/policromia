local M = {}
local signals = require("signals")

local on = beautiful.pri
local off = beautiful.fg2

M.vol = wibox.widget {
  {
    {
      id = "vol",
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f6a8}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    margins = dpi(5)
  },
  fg = beautiful.pri,
  bg = beautiful.bg3,
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.mic = wibox.widget {
  {
    {
      id = "mic",
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f130}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    margins = dpi(5),
  },
  fg = beautiful.pri,
  bg = beautiful.bg3,
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.net = wibox.widget {
  {
    {
      id = 'wifi',
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f0ac}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    margins = dpi(5),
  },
  fg = off,
  bg = beautiful.bg3,
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.nig = wibox.widget {
  {
    {
      id = "nig",
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f06e}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    margins = dpi(5),
  },
  fg = off,
  bg = beautiful.bg3,
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.wal = wibox.widget {
  {
    {
      id = "wal",
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f03e}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    margins = dpi(5),
  },
  fg = on,
  bg = beautiful.bg3,
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.emp = wibox.widget {
  fg = on,
  bg = beautiful.bg2,
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.blu = wibox.widget {
  {
    {
      id = 'blu',
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f293}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    margins = dpi(5),
  },
  fg = on,
  bg = beautiful.bg3,
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

local blue = true

M.blu:buttons(gears.table.join(
  awful.button({}, 1, function()
    blue = not blue
    if blue then
      awful.spawn.with_shell("bluetoothctl power on")
      M.blu.fg = on
    else
      awful.spawn.with_shell("bluetoothctl power off")
      M.blu.fg = off
    end
  end)
))

awesome.connect_signal('vol::value', function(mut, val)
  if mut:match("no") then
    M.vol.fg = on
  else
    M.vol.fg = off
  end
end)

M.vol:buttons(gears.table.join(
  awful.button({}, 1, function()
    signals.toggle_vol_mute()
  end)
))

awesome.connect_signal('mic::value', function(mut, val)
  if mut:match("no") then
    M.mic.fg = on
  else
    M.mic.fg = off
  end
end)

M.mic:buttons(gears.table.join(
  awful.button({}, 1, function()
    signals.toggle_mic_mute()
  end)
))

awesome.connect_signal("net::value", function(status)
  if status:match("full") or status:match("portal") then
    M.net.fg = on
  else
    M.net.fg = off
  end
end)

M.net:buttons(gears.table.join(
  awful.button({}, 1, function()
    wifi = not wifi
    if wifi then
      M.net.fg = on
      awful.spawn.with_shell("nmcli radio wifi on")
    else
      M.net.fg = off
      awful.spawn.with_shell("nmcli radio wifi off")
    end
  end)
))

local nig = false

M.nig:buttons(gears.table.join(
  awful.button({}, 1, function()
    nig = not nig
    if nig then
      M.nig.fg = on
      awful.spawn.with_shell("redshift -x && redshift -O 4000K")
    else
      M.nig.fg = off
      awful.spawn.with_shell("redshift -x")
    end
  end)
))

M.wal:buttons(gears.table.join(
  awful.button({}, 1, function()
    help.randomize_wallpaper()
  end)
))

-- Theme switcher

local function switch_theme(theme)
  beautiful.activetheme = theme
  help.write_to_file(beautiful.activethemepath .. "activetheme", beautiful.activetheme)
  awful.spawn.easy_async_with_shell("cp " ..
    beautiful.activethemepath .. beautiful.activetheme .. "/colors.conf ~/.config/kitty/colors.conf")
  awful.spawn.easy_async_with_shell("cp " ..
    beautiful.activethemepath .. beautiful.activetheme .. "/colors.rasi ~/.config/rofi/colors.rasi")
  awful.spawn.easy_async_with_shell("pkill -USR1 kitty")
  help.randomize_wallpaper()
  awesome.restart()
end

M.darktheme = wibox.widget {
  {
    {
      id = 'darktheme',
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f186}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    top = dpi(15),
    bottom = dpi(15),
  },
  fg = "#e8e3e3",
  bg = {
    type = "linear",
    from = { 0, 0, 0 },
    to = { 100, 0, 100 },
    stops = { { 0, "#121212" }, { 1, "#1e1e1e" } }
  },
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.darktheme:buttons(gears.table.join(
  awful.button({}, 1, function()
    if beautiful.activetheme ~= "dark" then
      switch_theme("dark")
    end
  end)
))

M.lighttheme = wibox.widget {
  {
    {
      id = 'lighttheme',
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f185}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    top = dpi(15),
    bottom = dpi(15),
  },
  fg = "#51576d",
  bg = {
    type = "linear",
    from = { 0, 0, 0 },
    to = { 100, 0, 100 },
    stops = { { 0, "#d9def2" }, { 1, "#e5eafe" } }
  },
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.lighttheme:buttons(gears.table.join(
  awful.button({}, 1, function()
    if beautiful.activetheme ~= "light" then
      switch_theme("light")
    end
  end)
))

M.cyberpunktheme = wibox.widget {
  {
    {
      id = 'cyberpunktheme',
      widget = wibox.widget.textbox,
      font = beautiful.icofont,
      markup = "\u{f54c}",
      halign = "center",
      align = 'center',
    },
    widget = wibox.container.margin,
    top = dpi(15),
    bottom = dpi(15),
  },
  fg = "#fb007a",
  bg = {
    type = "linear",
    from = { 0, 0, 0 },
    to = { 100, 0, 100 },
    stops = { { 0, "#070219" }, { 1, "#130e25" } }
  },
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

M.cyberpunktheme:buttons(gears.table.join(
  awful.button({}, 1, function()
    if beautiful.activetheme ~= "cyberpunk" then
      switch_theme("cyberpunk")
    end
  end)
))

return M
