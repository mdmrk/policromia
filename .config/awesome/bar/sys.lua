local M = {}

-- Wifi
M.net = wibox.widget {
  font = beautiful.icofont,
  align = 'center',
  widget = wibox.widget.textbox,
}

-- Volume
M.vol = wibox.widget {
  font = beautiful.icofont,
  align = 'center',
  widget = wibox.widget.textbox,
}

-- Bluethooth
M.blu = wibox.widget {
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

awesome.connect_signal("blu::value", function(stat)
  if stat:match("no") then
    M.blu.opacity = 0.25
    M.blu.markup = ""
  else
    M.blu.opacity = 1
    M.blu.markup = ""
  end
end)

awesome.connect_signal("net::value", function(stat)
  if stat:match("up") then
    M.net.opacity = 1
    M.net.markup = ""
  else
    M.net.opacity = 0.25
    M.net.markup = ""
  end
end)

awesome.connect_signal("bat::value", function(charge)
  local icon = "\u{e19c}"
  if charge >= 95 then
    icon = "\u{e1a4}"
  elseif charge >= 75 and charge < 95 then
    icon = "\u{ebd4}"
  elseif charge >= 50 and charge < 75 then
    icon = "\u{ebe2}"
  elseif charge >= 25 and charge < 50 then
    icon = "\u{ebdd}"
  elseif charge >= 5 and charge < 25 then
    icon = "\u{ebe0}"
  else
    icon = "\u{ebd9}"
  end
  M.battery.markup = icon
end)

awesome.connect_signal('vol::value', function(mut, val)
  if mut:match("no") then
    M.vol.opacity = 1
    if val > 70 then
      M.vol.markup = ""
    elseif val > 30 then
      M.vol.markup = ""
    else
      M.vol.markup = ""
    end
  else
    M.vol.opacity = 0.25
    M.vol.markup = ""
  end
end)

return M
