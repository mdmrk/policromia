local height = dpi(250)
local width = dpi(50)

local prg = wibox.widget({
	max_value = 100,
	forced_height = width,
	forced_width = height,
	value = 25,
	shape = help.rrect(dpi(999)),
	color = beautiful.pri,
	background_color = beautiful.bg3,
	widget = wibox.widget.progressbar,
})

local icon = wibox.widget({
	font = beautiful.icofont,
	align = "center",
	valign = "bottom",
	widget = wibox.widget.textbox,
})

local pop = wibox({
	type = "popup",
	height = height,
	width = width,
	shape = help.rrect(dpi(999)),
	halign = "center",
	valign = "center",
	ontop = true,
	visible = false,
})

awful.placement.right(pop, { margins = { right = beautiful.useless_gap * 4 } })

pop:setup({
	{
		prg,
		widget = wibox.container.rotate,
		direction = "east",
	},
	{
		icon,
		margins = { bottom = dpi(12) },
		widget = wibox.container.margin,
	},
	layout = wibox.layout.stack,
})

local run = gears.timer({
	timeout = 4,
	callback = function()
		pop.visible = false
	end,
})

local timed = rubato.timed({
	duration = 1 / 4,
	easing = rubato.quadratic,
	subscribed = function(pos)
		prg.value = pos
	end,
})

awesome.connect_signal("vol::value", function(mut, vol)
	if mut == 0 then
		prg.color = beautiful.pri
		icon.markup = help.fg("\u{eb51}", beautiful.bg3, "normal")
	else
		prg.color = beautiful.err
		icon.markup = help.fg("\u{f1c3}", beautiful.bg3, "normal")
	end
	timed.target = vol
	if pop.visible then
		run:again()
	else
		pop.visible = true
		run:start()
	end
end)
