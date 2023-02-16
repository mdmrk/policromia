local M = {}

-- Separator
M.sep = wibox.widget {
  {
    forced_height = dpi(2),
    shape = gears.shape.line,
    widget = wibox.widget.separator
  },
  top = dpi(15),
  left = dpi(5),
  right = dpi(5),
  bottom = dpi(15),
  widget = wibox.container.margin
}

M.launch = wibox.widget {
  {
    markup = "\u{f6e2}",
    font = beautiful.icofontname .. "12",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  },
  widget = wibox.container.background,
}

M.search = wibox.widget {
  {
    markup = "\u{f002}",
    font = beautiful.icofontname .. "12",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  },
  widget = wibox.container.background,
}

M.search:buttons(gears.table.join(
  awful.button({}, 1, function()
    awful.spawn.with_shell("rofi -show drun -show-icons -theme apps")
  end)
))

M.launch:buttons(gears.table.join(
  awful.button({}, 1, function()
    dashboard.toggle()
  end)
))

return M
