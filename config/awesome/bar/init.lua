local sys = require("bar.sys")
local oth = require("bar.oth")

local main = wibox.widget {
  {
    {
      oth.launch,
      oth.search,
      spacing = dpi(20),
      layout = wibox.layout.fixed.vertical,
    },
    left = dpi(2),
    right = dpi(2),
    bottom = dpi(10),
    top = dpi(10),
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.bar_br),
  bg = beautiful.bg2,
  widget = wibox.container.background,
}

local sys = wibox.widget {
  {
    {
      {
        sys.net,
        sys.vol,
        sys.battery,
        spacing = dpi(20),
        layout = wibox.layout.fixed.vertical,
      },
      oth.sep,
      sys.clock,
      layout = wibox.layout.fixed.vertical,
    },
    left = dpi(2),
    right = dpi(2),
    bottom = dpi(10),
    top = dpi(10),
    widget = wibox.container.margin
  },
  shape = help.rrect(beautiful.bar_br),
  bg = beautiful.bg2,
  widget = wibox.container.background,
}

awful.screen.connect_for_each_screen(function(s)
  awful.wibar({
    position = "left",
    bg = beautiful.bg,
    fg = beautiful.fg,
    width = beautiful.bar_width,
    height = s.geometry.height - beautiful.useless_gap * 4,
    margins = { left = beautiful.useless_gap * 2 },
    shape = help.rrect(beautiful.bar_br),
    screen = s
  }):setup {
    layout = wibox.layout.align.vertical,
    { -- Top
      main,
      margins = dpi(5),
      widget = wibox.container.margin,
    },
    { -- Middle
      {
        {
          {
            require('bar.tag')(s),
            require('bar.task')(s),
            layout = wibox.layout.fixed.vertical,
          },
          bg = beautiful.bg2,
          shape = help.rrect(dpi(100)),
          widget = wibox.container.background
        },
        margins = dpi(5),
        widget = wibox.container.margin,
      },
      layout = wibox.layout.flex.vertical,
    },
    { -- Bottom
      {
        sys,
        layout = wibox.layout.fixed.vertical,
      },
      margins = dpi(5),
      widget = wibox.container.margin,
    },
  }
end)
