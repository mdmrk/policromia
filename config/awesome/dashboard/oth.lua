local power = require("power")

local M = {}

local create_button = function(icon, comm)
  local button = wibox.widget {
    {
      {
        widget = wibox.widget.textbox,
        font = beautiful.icofont,
        markup = help.fg(icon, beautiful.fg, "normal"),
        halign = "center",
        align = 'center',
      },
      margins = dpi(20),
      widget = wibox.container.margin,
    },
    bg = beautiful.bg2,
    buttons = { awful.button({}, 1, function()
      if type(comm) == "string" then
        awful.spawn(comm, false)
      else
        comm()
      end
    end) },
    shape = gears.shape.circle,
    widget = wibox.container.background,
  }
  button:connect_signal("mouse::enter", function()
    button.bg = beautiful.bg3
  end)
  button:connect_signal("mouse::leave", function()
    button.bg = beautiful.bg2
  end)
  return button
end

M.ses = wibox.widget {
  {
    {
      image = beautiful.theme_dir .. "profile.png",
      resize = true,
      opacity = 0.8,
      forced_height = dpi(100),
      clip_shape = gears.shape.circle,
      widget = wibox.widget.imagebox
    },
    {
      {
        {
          markup = help.fg(os.getenv('USER'), beautiful.pri, "normal"),
          font = beautiful.fontname .. "14",
          widget = wibox.widget.textbox
        },
        {
          markup = help.fg("arch", beautiful.fg, "normal"),
          font = beautiful.fontname .. "10",
          widget = wibox.widget.textbox
        },
        spacing = dpi(5),
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.place,
      valign = "center",
      halign = "left"
    },
    spacing = dpi(20),
    layout = wibox.layout.flex.horizontal
  },
  {
    {
      create_button("\u{f023}", function()
        dashboard.toggle()
        awful.spawn("betterlockscreen -l", false)
      end),
      create_button("\u{f011}", function()
        power.toggle()
        dashboard.toggle()
      end),
      spacing = dpi(15),
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.place,
    halign = "right",
  },
  layout = wibox.layout.flex.horizontal,
}

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
          markup = "...",
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
        layout = wibox.layout.flex.vertical,
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

gears.timer {
  timeout = 10,
  single_shot = true,
  autostart = true,
  callback = function()
    -- m = ºC, km/h
    -- u = ºF, mph
    local unit = "m"
    local city
    local fallback_city = "alicante"
    awful.spawn.easy_async_with_shell("curl -s https://ipinfo.io/$(curl -s ifconfig.me) | jq -r .city",
      function(out)
        out = out:sub(1, -2)
        if out == "" then
          city = fallback_city
        else
          city = out
        end
        city = city:gsub(" ", "-")
        local com = "curl 'wttr.in/" .. city .. "?" .. unit .. "&format=%c+%t+%w'"

        awful.widget.watch(com, 600, function(widget, out)
          local val = gears.string.split(out, " ")
          local sign = val[2]:sub(1, 1)

          M.wth:get_children_by_id("icn")[1].markup = val[1]
          M.wth:get_children_by_id("wth")[1].markup = help.fg(
            (sign == "-" and "-" or "") .. val[2]:sub(2),
            beautiful.pri, "1000")
          M.wth:get_children_by_id("wnd")[1].markup = help.fg(val[3]:sub(1, -2), beautiful.fg2, "bold")
        end)
      end)
  end
}

return M
