local M = {}

M.pfl = wibox.widget {
  {
    {
      {
        format = "%A, %B %e",
        refresh = 1,
        widget = wibox.widget.textclock,
        align = "center"
      },
      {
        format = "%H:%M:%S",
        refresh = 1,
        fg = beautiful.bg2,
        font = beautiful.fontname .. "14",
        align = "center",
        widget = wibox.widget.textclock
      },
      layout = wibox.layout.flex.vertical,
    },
    widget = wibox.container.margin,
    margins = dpi(20),
  },
  shape = help.rrect(beautiful.br),
  bg = beautiful.bg2,
  fg = beautiful.pri,
  widget = wibox.container.background,
}

M.cal = wibox.widget {
  {
    {
      {
        format = help.fg("%A, %B %e", beautiful.pri, "bold"),
        refresh = 1,
        widget = wibox.widget.textclock,
        align = "center"
      },
      {
        format = help.fg("%H:%M:%S", beautiful.pri, "1000"),
        refresh = 1,
        fg = beautiful.bg2,
        font = beautiful.fontname .. "16",
        align = "center",
        widget = wibox.widget.textclock
      },
      layout = wibox.layout.flex.vertical,
    },
    widget = wibox.container.margin,
    margins = dpi(20),
  },
  shape = help.rrect(beautiful.br),
  bg = beautiful.bg2,
  fg = beautiful.pri,
  widget = wibox.container.background,
}

M.wth = wibox.widget {
  {
    {
      {
        id = "icn",
        align = "left",
        font = beautiful.fontname .. "40",
        widget = wibox.widget.textbox
      },
      {
        {
          id = "wth",
          align = "right",
          font = beautiful.fontname .. "20",
          widget = wibox.widget.textbox
        },
        {
          id = "wnd",
          align = "right",
          font = beautiful.fontname .. "12",
          widget = wibox.widget.textbox
        },
        spacing = dpi(5),
        layout = wibox.layout.fixed.vertical,
      },
      layout = wibox.layout.flex.horizontal
    },
    widget = wibox.container.margin,
    margins = dpi(20),
  },
  shape = help.rrect(beautiful.br),
  bg = beautiful.bg2,
  fg = beautiful.fg2,
  widget = wibox.container.background,
}

awful.widget.watch("curl 'wttr.in/alicante?format=%c+%t+%w'", 600, function(widget, out)
  local val = gears.string.split(out, " ")
  local sign = val[2]:sub(1, 1)

  M.wth:get_children_by_id("icn")[1].markup = val[1]
  M.wth:get_children_by_id("wth")[1].markup = help.fg(
    (sign == "-" and "-" or "") .. val[2]:sub(2),
    beautiful.pri, "1000")
  M.wth:get_children_by_id("wnd")[1].markup = help.fg(val[3]:sub(1, -2), beautiful.fg2, "bold")
end)


return M
