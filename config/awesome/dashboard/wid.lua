local signals = require("signals")

local M = {}
local on = beautiful.pri
local off = beautiful.fg2

local create_button = function(id, icon, comm, state)
	local button = wibox.widget({
		{
			{
				id = id,
				widget = wibox.widget.textbox,
				font = beautiful.icofont,
				markup = icon,
				align = "center",
			},
			widget = wibox.container.margin,
			top = dpi(20),
			bottom = dpi(20),
		},
		bg = beautiful.bg2,
		fg = state or on,
		buttons = {
			awful.button({}, 1, function()
				comm()
			end),
		},
		shape = help.rrect(dpi(99)),
		widget = wibox.container.background,
	})
	return button
end

local nig = false
local nig_callback = function()
	nig = not nig
	if nig then
		M.nig.fg = on
		awful.spawn.with_shell("redshift -x && redshift -O 5000K")
	else
		M.nig.fg = off
		awful.spawn.with_shell("redshift -x")
	end
end

M.vol = create_button("vol", "\u{eb51}", signals.toggle_vol_mute)
M.mic = create_button("mic", "\u{eaf0}", signals.toggle_mic_mute)
M.nig = create_button("nig", "\u{ea51}", nig_callback, off)

M.emp = wibox.widget({
	fg = on,
	bg = beautiful.bg2,
	shape = help.rrect(beautiful.br),
	widget = wibox.container.background,
})

M.bat = wibox.widget({
	{
		id = "prg",
		max_value = 100,
		value = 0.5,
		shape = help.rrect(beautiful.br),
		background_color = beautiful.bg2,
		forced_height = 20,
		widget = wibox.widget.progressbar,
	},
	{
		{
			{
				id = "txt",
				font = beautiful.barfontname .. "18",
				widget = wibox.widget.textbox,
			},
			{
				id = "ico",
				font = beautiful.icofont,
				widget = wibox.widget.textbox,
			},
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(5),
		},
		margins = dpi(20),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.stack,
})

M.tra = wibox.widget({
	base_size = beautiful.systray_base_size,
	widget = wibox.widget.systray,
})

awesome.connect_signal("vol::value", function(mut, vol)
	if mut == 0 then
		M.vol.fg = on
	else
		M.vol.fg = off
	end
end)

awesome.connect_signal("mic::value", function(mut, vol)
	if mut == 0 then
		M.mic.fg = on
	else
		M.mic.fg = off
	end
end)

awesome.connect_signal("bat::value", function(status, charge)
	local prg = M.bat:get_children_by_id("prg")[1]

	prg.value = charge
	if charge < 20 and status == "Discharging" then
		prg.color = beautiful.err
	else
		prg.color = beautiful.ok
	end
	if status == "Charging" then
		M.bat:get_children_by_id("ico")[1].markup = help.fg("\u{ea38}", beautiful.bg, "1000")
	else
		M.bat:get_children_by_id("ico")[1].markup = ""
	end
	M.bat:get_children_by_id("txt")[1].markup = help.fg(charge .. "%", beautiful.bg, "1000")
end)

return M
