local sys = require("bar.sys")
local oth = require("bar.oth")

local main = wibox.widget {
  {
    oth.launch,
    oth.search,
    spacing = dpi(20),
    layout = wibox.layout.fixed.vertical,
  },
  widget = wibox.container.margin,
  margins = { top = dpi(20) },
}

local tags = function(s)
  return wibox.widget {
    require("bar.tag")(s),
    widget = wibox.container.margin,
    margins = dpi(18)
  }
end

local sys = wibox.widget {
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
  widget = wibox.container.margin,
  margins = { bottom = dpi(20) },
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
    main,
    tags(s),
    sys,
    expand = "none",
    layout = wibox.layout.align.vertical,
  }
end)
