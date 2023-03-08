local power, confirmation
local command = ""

local run_comm = function(comm)
    if type(comm) == "string" then
        awful.spawn(comm, false)
    else
        comm()
    end
end

local create_button = function(icon, comm, act, requires_confirmation)
    local button = wibox.widget {
        {
            {
                widget = wibox.widget.textbox,
                font = beautiful.icofontname .. "14",
                markup = help.fg(icon, beautiful.fg, "normal"),
                halign = "center",
                align = 'center',
            },
            margins = dpi(20),
            widget = wibox.container.margin,
        },
        bg = beautiful.bg2,
        buttons = { awful.button({}, 1, function()
            if requires_confirmation then
                command = comm
                confirmation.toggle()
                power.toggle()
            else
                run_comm(comm)
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

confirmation = awful.popup {
    widget    = {
        {
            {
                id = "txt",
                widget = wibox.widget.textbox,
                font = beautiful.barfont,
                markup = help.fg("Are you sure?", beautiful.fg, "normal"),
                halign = "center",
                align = 'center',
            },
            margins = dpi(20),
            widget = wibox.container.margin,
            {
                create_button("\u{58}", function()
                    confirmation.toggle()
                end, false),
                create_button("\u{f00c}", function()
                    confirmation.toggle()
                    run_comm(command)
                end
                , false),
                spacing = dpi(15),
                layout = wibox.layout.fixed.horizontal,
            },
            spacing = dpi(15),
            layout = wibox.layout.fixed.vertical,
        },
        margins = dpi(20),
        widget = wibox.container.margin
    },
    shape     = help.rrect(beautiful.br),
    bg        = beautiful.bg,
    visible   = false,
    ontop     = true,
    placement = function(c)
        (awful.placement.bottom)(c,
                { margins = { bottom = beautiful.useless_gap * 2 } })
    end,
}

power = awful.popup {
    widget    = {
        {
            create_button("\u{f011}", "shutdown now", "Shutdown?", true),
            create_button("\u{f01e}", "reboot", "Reboot?", true),
            create_button("\u{f2f5}", awesome.quit, "Quit Awesome?", true),
            spacing = dpi(15),
            layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(20),
        widget = wibox.container.margin
    },
    shape     = help.rrect(beautiful.br),
    bg        = beautiful.bg,
    visible   = false,
    ontop     = true,
    placement = function(c)
        (awful.placement.bottom)(c,
                { margins = { bottom = beautiful.useless_gap * 2 } })
    end,
}

local key_grabber = awful.keygrabber {
    auto_start = true,
    stop_event = 'release',
    keypressed_callback = function(self, mod, key, command)
        if key == 'Escape' or key == 'q' then
            if confirmation.visible then
                confirmation.toggle()
            else
                power.toggle()
            end
        end
    end
}

power.toggle = function()
    power.visible = not power.visible
    if power.visible then
        key_grabber:start()
    else
        key_grabber:stop()
    end
end

confirmation.toggle = function()
    confirmation.visible = not confirmation.visible
    if confirmation.visible then
        key_grabber:start()
    else
        key_grabber:stop()
    end
end

return power
