local M = {}

local height = 120
local width = 48

local vol_sli = wibox.widget {
  bar_shape = help.rrect(beautiful.br),
  bar_height = dpi(20),
  handle_width = 0,
  forced_height = dpi(20),
  maximum = 100,
  bar_color = "#00000000",
  widget = wibox.widget.slider,
}

local vol = wibox.widget {
  {
    id = 'prg',
    max_value = 100,
    value = vol_sli.value,
    forced_height = dpi(20),
    shape = help.rrect(beautiful.br),
    color = beautiful.pri,
    visible = false,
    background_color = beautiful.bg3,
    widget = wibox.widget.progressbar,
  },
  vol_sli,
  layout = wibox.layout.stack,
}

local run = gears.timer {
  timeout = 4,
  callback = function()
    vol.visible = false
  end
}

M.vol = function()
  if vol.visible then
    run:again()
  else
    vol.visible = true
    run:start()
  end
end

return M
