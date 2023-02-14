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
  if status == "Charging" then
    icon = help.fg(icon, beautiful.ok, "normal")
    if charge >= 95 then
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
