local wid = require("dashboard.wid")
local sli = require("dashboard.sli")

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
          text = '\u{f6a8}',
          forced_width = dpi(20),
          widget = wibox.widget.textbox
        },
        sli.vol,
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal
      },
      {
        {
          font = beautiful.icofont,
          text = '\u{f130}',
          forced_width = dpi(20),
          widget = wibox.widget.textbox,
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

local buttons = wibox.widget {
  { {
    {
      wid.vol,
      wid.mic,
      wid.nig,
      spacing = dpi(10),
      layout = wibox.layout.flex.horizontal,
    },
    {
      wid.wal,
      wid.mic,
      wid.nig,
      spacing = dpi(10),
      layout = wibox.layout.flex.horizontal,
    },
    layout = wibox.layout.flex.vertical,
    spacing = dpi(10),
  },
    widget = wibox.container.margin,
    margins = dpi(20),
  },
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
  bg = beautiful.bg2,
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
    margins = dpi(20),
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.br),
  widget = wibox.container.background,
  bg = beautiful.bg2,
}

local dashboard = awful.popup {
  widget = {
    {
      {
        -- require('dashboard.oth').clock,
        require('dashboard.oth').cal,
        layout = wibox.layout.flex.vertical,
        spacing = dpi(20),
      },
      require("dashboard.play"),
      sliders,
      buttons,
      themeswitcher,
      spacing = dpi(15),
      layout = wibox.layout.fixed.vertical,
    },
    margins = dpi(20),
    -- forced_height = awful.screen.focused().geometry.height - 20,
    forced_width = dpi(265),
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.br),
  visible = false,
  bg = beautiful.bg,
  ontop = true,
  placement = function(c)
    (awful.placement.bottom_left)(c, { margins = { left = 60, bottom = 10 } })
  end,
}

dashboard.toggle = function()
  dashboard.visible = not dashboard.visible
end

return dashboard
