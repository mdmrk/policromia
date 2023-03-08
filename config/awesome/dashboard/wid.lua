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
      markup = "\u{f1eb}",
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
    id = "wal",
    widget = wibox.widget.textbox,
    font = beautiful.icofont,
    markup = "\u{f03e}",
    halign = "center",
    align = 'center',
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

M.bat = wibox.widget {
  {
    id               = "prg",
    max_value        = 100,
    value            = 0.5,
    shape            = help.rrect(beautiful.br),
    background_color = beautiful.bg2,
    forced_height    = 20,
    widget           = wibox.widget.progressbar,
  },
  {
    {
      {
        id     = "ico",
        font   = beautiful.icofont,
        widget = wibox.widget.textbox,
      },
      {
        id     = "txt",
        font   = beautiful.barfontname .. "20",
        widget = wibox.widget.textbox,
      },
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(15),
    },
    margins = dpi(20),
    widget = wibox.container.margin,
  },
  layout = wibox.layout.stack
}

awesome.connect_signal('vol::value', function(mut, vol)
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

awesome.connect_signal('mic::value', function(mut, vol)
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

awesome.connect_signal("bat::value", function(status, charge)
  local prg = M.bat:get_children_by_id("prg")[1]

  prg.value = charge
  if charge < 20 and status == "Discharging" then
    prg.color = beautiful.err
  else
    prg.color = beautiful.ok
  end
  if status == "Charging" then
    M.bat:get_children_by_id("ico")[1].markup = help.fg('\u{f0e7}',
      beautiful.bg3, "1000")
  else
    M.bat:get_children_by_id("ico")[1].markup = ''
  end
  M.bat:get_children_by_id("txt")[1].markup = help.fg(charge .. "%",
    beautiful.bg3, "1000")
end)

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

local function create_theme(name, markup, btn_fg, btn_bg1, btn_bg2)
  local register_name = name .. "theme"

  M[register_name] = wibox.widget {
    {
      {
        id = register_name,
        widget = wibox.widget.textbox,
        font = beautiful.icofont,
        markup = markup,
        halign = "center",
        align = 'center',
      },
      widget = wibox.container.margin,
      top = dpi(15),
      bottom = dpi(15),
    },
    fg = btn_fg,
    bg = {
      type = "linear",
      from = { 0, 0, 0 },
      to = { 100, 0, 100 },
      stops = { { 0, btn_bg1 }, { 1, btn_bg2 } }
    },
    shape = help.rrect(beautiful.br),
    widget = wibox.container.background,
  }

  M[register_name]:buttons(gears.table.join(
    awful.button({}, 1, function()
      if beautiful.activetheme ~= name then
        switch_theme(name)
      end
    end)
  ))
end

create_theme("dark", "\u{f186}", "#e8e3e3", "#121212", "#1e1e1e")
create_theme("light", "\u{f185}", "#51576d", "#d9def2", "#e5eafe")
create_theme("cyberpunk", "\u{f54c}", "#fb007a", "#070219", "#130e25")

return M
