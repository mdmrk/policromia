local width = 48
local height = 100

local vol = wibox({
  screen = awful.screen.focused(),
  x = awful.screen.geometry.width,
  y = (awful.screen.geometry.height / 2) - height / 2,
  width = dpi(width),
  height = height,
  bg = beautiful.bg,
  shape = gears.shape.rounded_rect,
  visible = false,
  ontop = true
})

local vol_bar = wibox.widget {
  widget = wibox.widget.progressbar,
  shape = gears.shape.rounded_bar,
  color = beautiful.fg,
  background_color = beautiful.fg,
  max_value = 100,
  value = 0
}

vol:setup {
  layout = wibox.layout.align.vertical,
  {
    wibox.container.margin(
      vol_bar, dpi(14), dpi(20), dpi(20), dpi(20)
    ),
    forced_height = height * 0.75,
    direction = "east",
    layout = wibox.container.rotate
  },
}

local function run(popup)
  popup.visible = true
  gears.timer {
    timeout = 4,
    autostart = true,
    callback = function()
      popup.visible = false
    end
  }
end
