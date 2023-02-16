local M = {}

M.vol_sli = wibox.widget {
  bar_shape = help.rrect(beautiful.br),
  bar_height = dpi(20),
  handle_width = 0,
  forced_height = dpi(20),
  maximum = 100,
  bar_color = "#00000000",
  widget = wibox.widget.slider,
}

M.vol = wibox.widget {
  {
    id = 'prg',
    max_value = 100,
    value = M.vol_sli.value,
    forced_height = dpi(20),
    shape = help.rrect(beautiful.br),
    color = beautiful.pri,
    background_color = beautiful.bg3,
    widget = wibox.widget.progressbar,
  },
  M.vol_sli,
  layout = wibox.layout.stack,
}

M.mic_sli = wibox.widget {
  bar_shape = help.rrect(beautiful.br),
  bar_height = dpi(20),
  handle_width = 0,
  forced_height = dpi(20),
  maximum = 100,
  bar_color = "#00000000",
  widget = wibox.widget.slider,
}

M.mic = wibox.widget {
  {
    id = 'prg',
    max_value = 100,
    value = M.mic_sli.value,
    forced_height = dpi(20),
    shape = help.rrect(beautiful.br),
    color = beautiful.pri,
    background_color = beautiful.bg3,
    widget = wibox.widget.progressbar,
  },
  M.mic_sli,
  layout = wibox.layout.stack,
}

awesome.connect_signal('vol::value', function(mut, vol)
  local prg = M.vol:get_children_by_id('prg')[1]
  if mut == 0 then
    M.vol_sli.handle_color = beautiful.pri
    prg.color = beautiful.pri
  else
    M.vol_sli.handle_color = beautiful.fg2
    prg.color = beautiful.fg2
  end
  M.vol_sli.value = vol
  prg.value = vol
end)

M.vol_sli:connect_signal('property::value', function(val)
  M.vol:get_children_by_id('prg')[1].value = val.value
  sig.set_vol(val.value)
end)

awesome.connect_signal('mic::value', function(mut, vol)
  if mut == 0 then
    M.mic_sli.handle_color = beautiful.pri
    M.mic:get_children_by_id('prg')[1].color = beautiful.pri
  else
    M.mic_sli.handle_color = beautiful.fg2
    M.mic:get_children_by_id('prg')[1].color = beautiful.fg2
  end
  M.mic_sli.value = vol
  M.mic:get_children_by_id('prg')[1].value = vol
end)

M.mic_sli:connect_signal('property::value', function(val)
  sig.set_mic(val.value)
  M.mic:get_children_by_id('prg')[1].value = val.value
end)

return M
