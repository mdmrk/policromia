-- a minimal bar
-- ~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helpers   = require("helpers")
local dpi       = beautiful.xresources.apply_dpi



-- misc/vars
-- ~~~~~~~~~





-- connect to screen
-- ~~~~~~~~~~~~~~~~~
awful.screen.connect_for_each_screen(function(s)

    -- screen width
    local screen_height = s.geometry.height




    -- widgets
    -- ~~~~~~~

    -- taglist
    local taglist = require("layout.bar.taglist")(s)


    -- launcher {{
    local launcher = wibox.widget {
        widget = wibox.widget.textbox,
        markup = helpers.colorize_text("", beautiful.fg_color),
        font = beautiful.icon_var .. "14",
        align = "center",
        valign = "center",
    }

    launcher:buttons(gears.table.join({
        awful.button({}, 1, function()
            awful.spawn.with_shell(require("misc").rofiCommand, false)
        end)

    }))
    -- }}


    -- cc
    local cc_ic = wibox.widget {
        markup = "",
        font = beautiful.icon_var .. "17",
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox
    }




    cc_ic:buttons { gears.table.join(
        awful.button({}, 1, function()
            cc_toggle(s)
        end)
    ) }



    -- clock
    ---------------------------
    local clock = wibox.widget {
        {
            widget = wibox.widget.textclock,
            format = "%H",
            font = beautiful.font_var .. "Bold 12",
            valign = "center",
            align = "center"
        },
        {
            widget = wibox.widget.textclock,
            format = "%M",
            font = beautiful.font_var .. "Medium 12",
            valign = "center",
            align = "center"
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(3)
    }
    -- Eo clock
    ------------------------------------------

    -- wibar
    s.wibar_wid = awful.wibar({
        screen  = s,
        visible = true,
        ontop   = false,
        type    = "dock",
        width   = dpi(beautiful.bar_size),
        shape   = helpers.rrect(beautiful.rounded),
        bg      = beautiful.bg_color,
        height  = screen_height - beautiful.useless_gap * 4
    })


    -- wibar placement
    awful.placement.left(s.wibar_wid, { margins = beautiful.useless_gap * 2 })
    s.wibar_wid:struts { left = s.wibar_wid.width + beautiful.useless_gap * 2 }


    -- bar setup
    s.wibar_wid:setup {
        {
            launcher,
            {
                taglist,
                margins = { left = dpi(8), right = dpi(8) },
                widget = wibox.container.margin
            },
            {
                {
                    margins = { left = dpi(8), right = dpi(8) },
                    widget = wibox.container.margin
                },
                {
                    cc_ic,
                    clock,
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(20)
                },
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(20)
            },
            layout = wibox.layout.align.vertical,
            expand = "none"
        },
        layout = wibox.container.margin,
        margins = { top = dpi(14), bottom = dpi(14) }
    }

end)
