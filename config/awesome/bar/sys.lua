local help = require("help")
local M = {}

-- Net
M.net = wibox.widget {
  font = beautiful.icofontname .. "12",
  align = 'center',
  markup = "\u{f1eb}",
  widget = wibox.widget.textbox,
}

-- Volume
M.vol = wibox.widget {
  font = beautiful.icofontname .. "12",
  align = 'center',
  widget = wibox.widget.textbox,
}

-- Battery
M.battery = wibox.widget {
  font = beautiful.icofontname .. "12",
  align = 'center',
  widget = wibox.widget.textbox,
}

-- Clock
M.clock = wibox.widget {
  font = beautiful.barfont,
  format = help.fg("%H\n%M", beautiful.fg, "bold"),
  refresh = 1,
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textclock
}

local cal_btn = function(icon, comm, margin)
  local button = wibox.widget {
    {
      {
        widget = wibox.widget.textbox,
        font = beautiful.icofont,
        markup = help.fg(icon, beautiful.fg, "normal"),
        halign = "center",
        align = 'center',
      },
      margins = margin,
      widget = wibox.container.margin,
    },
    bg = beautiful.bg2,
    buttons = { awful.button({}, 1, function()
      comm()
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

local day = tonumber(os.date('%d'))
local month = tonumber(os.date('%m'))
local year = tonumber(os.date('%Y'))
local function deco_cell(widget, flag, date)
  if flag == "header" then
    widget:set_markup(help.fg(widget:get_text(), beautiful.pri, "bold"))
    return wibox.widget {
      nil, --cal_btn("\u{f0d9}", nil, { left = dpi(8), right = dpi(8) }),
      widget,
      nil, --cal_btn("\u{f0da}", nil, { left = dpi(8), right = dpi(8) }),
      layout = wibox.layout.align.horizontal
    }
  elseif flag == "month" then
    return widget
  elseif flag == "weekday" then
    local ret = wibox.widget {
      markup = help.fg(widget:get_text(), beautiful.fg, "bold"),
      halign = "center",
      widget = wibox.widget.textbox
    }
    return ret
  end
  local today = date.day == day and date.month == month and date.year == year
  local ret = wibox.widget {
    {
      {
        nil,
        {
          markup = today and help.fg(widget:get_text(), beautiful.bg, "bold") or
              help.fg(widget:get_text(), beautiful.fg, "normal"),
          halign = "center",
          widget = wibox.widget.textbox
        },
        nil,
        layout = wibox.layout.align.horizontal
      },
      widget = wibox.container.margin,
      margins = dpi(5),
    },
    bg     = today and beautiful.pri or beautiful.bg,
    shape  = help.rrect(dpi(5)),
    widget = wibox.container.background
  }
  return ret
end

M.cal = awful.popup {
  widget    = {
    {
      date         = os.date('*t'),
      font         = beautiful.font,
      week_numbers = false,
      start_sunday = false,
      spacing      = dpi(5),
      fn_embed     = deco_cell,
      widget       = wibox.widget.calendar.month,
    },
    margins = dpi(20),
    widget = wibox.container.margin
  },
  shape     = help.rrect(beautiful.br),
  bg        = beautiful.bg,
  fg        = beautiful.fg,
  visible   = false,
  ontop     = true,
  placement = function(c)
    (awful.placement.bottom_left)(c,
          { margins = { left = beautiful.bar_width + (beautiful.useless_gap * 4), bottom = beautiful.useless_gap * 2 } })
  end,
}

awful.placement.bottom_left(pop,
  { margins = { left = beautiful.bar_width + (beautiful.useless_gap * 4), bottom = beautiful.useless_gap * 2 } })


M.cal.toggle = function()
  M.cal.visible = not M.cal.visible
end

M.clock:buttons(gears.table.join(
  awful.button({}, 1, function()
    M.cal.toggle()
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

  if charge >= 90 then
    icon = "\u{f240}"
  elseif charge >= 70 and charge < 90 then
    icon = "\u{f241}"
  elseif charge >= 40 and charge < 70 then
    icon = "\u{f242}"
  elseif charge >= 10 and charge < 40 then
    icon = "\u{f243}"
  else
    icon = "\u{f244}"
  end
  if status == "Charging" or status == "Full" then
    icon = help.fg(icon, beautiful.ok, "normal")
    if charge >= 90 then
      naughty.notify({
        title = "Battery charged",
        text = charge .. "% full",
        timeout = 4
      })
    end
  elseif charge < 20 and status == "Discharging" then
    icon = help.fg(icon, beautiful.err, "normal")
    naughty.notify({
      title = "Low battery",
      text = charge .. "% battery remaining",
      preset = naughty.config.presets.critical,
      timeout = 4
    })
  end
  M.battery.markup = icon
end)

awesome.connect_signal('vol::value', function(mut, vol)
  if mut == 0 then
    M.vol.opacity = 1
    M.vol.markup = "\u{f6a8}"
  else
    M.vol.opacity = 0.25
    M.vol.markup = "\u{f6a9}"
  end
end)

return M
