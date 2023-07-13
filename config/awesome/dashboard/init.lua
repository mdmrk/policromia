local wid = require("dashboard.wid")
local sli = require("dashboard.sli")
local top = require('dashboard.oth')
local play = require("dashboard.play")

local sep = wibox.widget {
  {
    forced_height = dpi(2),
    shape = gears.shape.line,
    widget = wibox.widget.separator
  },
  top = dpi(10),
  bottom = dpi(10),
  widget = wibox.container.margin
}

local sliders = wibox.widget {
  {
    {
      {
        {
          font = beautiful.icofont,
          markup = help.fg('\u{f6a8}', beautiful.pri, "normal"),
          forced_width = dpi(25),
          widget = wibox.widget.textbox,
          align = "center"
        },
        sli.vol,
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal
      },
      {
        {
          font = beautiful.icofont,
          markup = help.fg('\u{f130}', beautiful.pri, "normal"),
          forced_width = dpi(25),
          widget = wibox.widget.textbox,
          align = "center"
        },
        sli.mic,
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal
      },
      spacing = dpi(10),
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = dpi(20),
  },
  bg = beautiful.bg2,
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

local buttons = wibox.widget
    {
      {
        wid.net,
        wid.vol,
        wid.mic,
        wid.nig,
        wid.wal,
        wid.scr,
        spacing = dpi(10),
        layout = wibox.layout.flex.horizontal,
      },
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(10),
    }


local themeswitcher = wibox.widget {
  {
    {
      wid.darktheme,
      wid.lighttheme,
      wid.cyberpunktheme,
      spacing = dpi(10),
      layout = wibox.layout.flex.horizontal,
    },
    margins = dpi(0),
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
}

local tray = wibox.widget {
  forced_height = dpi(0),
  widget = wibox.widget.systray,
}

local dashboard = awful.popup {
  widget = {
    {
      top.ses,
      {
        top.cal,
        top.wth,
        spacing = dpi(15),
        forced_height = dpi(120),
        layout = wibox.layout.flex.horizontal,
      },
      play,
      {
        sliders,
        wid.bat,
        spacing = dpi(15),
        layout = wibox.layout.flex.horizontal,
      },
      buttons,
      themeswitcher,
      spacing = dpi(15),
      layout = wibox.layout.fixed.vertical,
    },
    margins = dpi(20),
    forced_width = beautiful.dashboard_width,
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.br),
  visible = false,
  bg = beautiful.bg,
  ontop = true,
  placement = function(c)
    (awful.placement.bottom_left)(c,
          { margins = { left = beautiful.bar_width + (beautiful.useless_gap * 4), bottom = beautiful.useless_gap * 2 } })
  end,
}

dashboard.toggle = function()
  dashboard.visible = not dashboard.visible
end

return dashboard
