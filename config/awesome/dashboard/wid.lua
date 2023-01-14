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
    top = dpi(15),
    bottom = dpi(15),
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
    top = dpi(15),
    bottom = dpi(15),
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
    top = dpi(15),
    bottom = dpi(15),
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
    top = dpi(15),
    bottom = dpi(15),
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
    top = dpi(15),
    bottom = dpi(15),
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

awesome.connect_signal('vol::value', function(mut, val)
  if mut == 0 then
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
  if mut == 0 then
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

local net = true

awesome.connect_signal("net::value", function(status)
  net = status == 1 and true or false
  if net then
    M.net.fg = on
  else
    M.net.fg = off
  end
end)

M.net:buttons(gears.table.join(
  awful.button({}, 1, function()
    net = not net
    if net then
      awful.spawn.easy_async_with_shell("nmcli networking on")
    else
      awful.spawn.easy_async_with_shell("nmcli networking off")
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
  help.write_to_file(beautiful.theme_dir .. "activetheme", theme)
  awful.spawn.easy_async_with_shell("cp " ..
    beautiful.theme_dir .. theme .. "/colors.conf ~/.config/kitty/colors.conf")
  awful.spawn.easy_async_with_shell("cp " ..
    beautiful.theme_dir .. theme .. "/colors.rasi ~/.config/rofi/colors.rasi")
  awful.spawn.easy_async_with_shell("pkill -USR1 kitty")
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
