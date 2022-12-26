-- requirements
-- ~~~~~~~~~~~~
local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helpers   = require("helpers")
local dpi       = beautiful.xresources.apply_dpi


-- widgets
-- ~~~~~~~


-- clock
local clock = wibox.widget {
    widget = wibox.widget.textclock,
    format = "%a, %d %b",
    font = beautiful.font_var .. "Medium 13",
    valign = "center",
    align = "center"
}


-- extra control icon
local extras = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "",
    font = beautiful.icon_var .. "14",
    valign = "center",
    align = "center"
}

-- weather
local weather = wibox.widget {
    markup = "",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox
}


local extra_shown = false


awesome.connect_signal("controlCenter::extras", function(update)
    extra_shown = update
    if update then extras.markup = "" end
end)

awesome.connect_signal("signal::weather", function(icon, temp)
    weather.markup = icon .. " " .. temp
end)

extras:buttons { gears.table.join(
    awful.button({}, 1, function()
        if extra_shown then
            show_extra_control_stuff()
            extra_shown = false
            extras.markup = ""
        else
            extras.markup = ""
            extra_shown = true
            show_extra_control_stuff(true)
        end
    end)
) }

return wibox.widget {
    clock,
    extras,
    weather,
    layout = wibox.layout.align.horizontal
}
