local help = require("help")
local M = {}

-- Net
M.net = wibox.widget {
  font = beautiful.icofont,
  align = 'center',
  markup = "\u{f0ac}",
  widget = wibox.widget.textbox,
}

-- Volume
M.vol = wibox.widget {
  font = beautiful.icofont,
  align = 'center',
  widget = wibox.widget.textbox,
}

-- Clock
M.clock = wibox.widget {
  font = beautiful.barfont,
  format = "%H\n%M",
  refresh = 1,
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textclock
}

-- Battery
M.battery = wibox.widget {
  font = beautiful.icofont,
  align = 'center',
  widget = wibox.widget.textbox,
}

local function cal_deco(widget, flag, date)
  local d = { year = date.year, month = (date.month or 1), day = (date.day or 1) }
  local weekday = tonumber(os.date('%w', os.time(d)))
  local today = tonumber(os.date('%d'))
  local month = tonumber(os.date('%m'))
  local ret = wibox.widget {
    widget,
    fg = (date.day == today and date.month == month) and beautiful.ok or
        (weekday == 0 or weekday == 6) and beautiful.pri or beautiful.fg,
    widget = wibox.container.background
  }
  return ret
end

local cal_m = awful.popup {
  widget =
  wibox.widget { {
    date         = os.date('*t'),
    font         = beautiful.barfont,
    spacing      = 6,
    fn_embed     = cal_deco,
    week_numbers = false,
    start_sunday = false,
    widget       = wibox.widget.calendar.month,
  },
    margins = dpi(20),
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.br),
  visible = false,
  bg = beautiful.bg,
  ontop = true,
  placement = function(c)
    (awful.placement.bottom_left)(c, { margins = { left = 60, bottom = 10 } })
  end
}

local cal_y = awful.popup {
  widget =
  wibox.widget { {
    date         = os.date('*t'),
    font         = beautiful.barfont,
    spacing      = 6,
    fn_embed     = cal_deco,
    week_numbers = false,
    start_sunday = false,
    widget       = wibox.widget.calendar.year,
  },
    margins = dpi(20),
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.br),
  visible = false,
  bg = beautiful.bg,
  ontop = true,
  placement = function(c)
    (awful.placement.bottom_left)(c, { margins = { left = 60, bottom = 10 } })
  end
}

cal_m.toggle = function()
  cal_m.visible = not cal_m.visible
end
cal_y.toggle = function()
  cal_y.visible = not cal_y.visible
end

M.clock:buttons(gears.table.join(
  awful.button({}, 1, function()
    if cal_y.visible then
      cal_y.toggle()
    end
    cal_m.toggle()
  end),
  awful.button({}, 3, function()
    if cal_m.visible then
      cal_m.toggle()
    end
    cal_y.toggle()
  end)
))

awesome.connect_signal("net::value", function(status)
  if status == 1 then
    M.net.opacity = 1
  else
    M.net.opacity = 0.25
  end
end)

awesome.connect_signal("bat::value", function(status, charge)
  local icon = "\u{e19c}"

  if charge >= 95 then
    icon = "\u{f240}"
  elseif charge >= 75 and charge < 95 then
    icon = "\u{f241}"
  elseif charge >= 50 and charge < 75 then
    icon = "\u{f242}"
  elseif charge >= 25 and charge < 50 then
    icon = "\u{f243}"
  elseif charge >= 5 and charge < 25 then
    icon = "\u{f243}"
  else
    icon = "\u{f244}"
  end
  if status == "Charging" then
    icon = help.fg(icon, beautiful.ok)
    if charge >= 95 then
      naughty.notify({
        title = "Battery charged",
        text = charge .. "% full",
        timeout = 4
      })
    end
  elseif charge < 15 and status == "Discharging" then
    icon = help.fg(icon, beautiful.err)
    naughty.notify({
      title = "Low battery",
      text = charge .. "% battery remaining",
      preset = naughty.config.presets.critical,
      timeout = 4
    })
  end
  M.battery.markup = icon
end)

awesome.connect_signal('vol::value', function(mut, val)
  if mut == 0 then
    M.vol.opacity = 1
    M.vol.markup = "\u{f6a8}"
  else
    M.vol.opacity = 0.25
    M.vol.markup = "\u{f6a9}"
  end
end)

return M
