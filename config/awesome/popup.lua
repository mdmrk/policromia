local M = {}

local height = dpi(300)
local width = dpi(60)

local vol_cont = wibox.widget {
  bar_shape = help.rrect(beautiful.br),
  bar_height = height,
  handle_width = 0,
  forced_height = width,
  forced_width = height,
  maximum = 100,
  value = 50,
  bar_color = "#00000000",
  widget = wibox.widget.slider,
}

local vol_sli = {
  {
    id = 'prg',
    max_value = 100,
    value = vol_cont.value,
    forced_height = width,
    forced_width = height,
    shape = help.rrect(beautiful.br),
    color = beautiful.pri,
    background_color = beautiful.bg3,
    widget = wibox.widget.progressbar,
  },
  vol_cont,
  layout = wibox.layout.stack,
}

local vol_popup = awful.popup {
  widget  = {
    {
      vol_sli,
      widget = wibox.container.rotate,
      direction = "east"
    },
    {
      markup = help.fg("\u{f6a8}", beautiful.bg3, "normal"),
      font   = beautiful.icofont,
      align  = 'center',
      valign = 'bottom',
      widget = wibox.widget.textbox
    },
    widget = wibox.layout.stack,
  },
  shape   = gears.shape.rounded_rect,
  x       = awful.screen.focused().geometry.width - width - dpi(50),
  y       = (awful.screen.focused().geometry.height / 2) - (height / 2),
  ontop   = true,
  visible = false,
}

local run = gears.timer {
  timeout = 4,
  callback = function()
    vol_popup.visible = false
  end
}

M.vol = function()
  if vol_popup.visible then
    run:again()
  else
    vol_popup.visible = true
    run:start()
  end
end

return M
