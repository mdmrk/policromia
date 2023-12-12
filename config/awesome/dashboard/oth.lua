local json = require("lib.json")
local env = require("env")

local M = {}

local create_button = function(icon, comm)
	local button = wibox.widget({
		{
			{
				widget = wibox.widget.textbox,
				font = beautiful.icofont,
				markup = help.fg(icon, beautiful.fg, "normal"),
			},
			margins = dpi(20),
			widget = wibox.container.margin,
		},
		bg = beautiful.bg2,
		buttons = {
			awful.button({}, 1, function()
				if type(comm) == "string" then
					awful.spawn(comm, false)
				else
					comm()
				end
			end),
		},
		shape = help.rrect(beautiful.br),
		widget = wibox.container.background,
	})
	return button
end

local create_stat = function(id, icon)
	local stat = {
		{
			markup = help.fg(icon, beautiful.fg, "bold"),
			font = beautiful.icofontname .. "12",
			widget = wibox.widget.textbox,
		},
		{
			id = id,
			markup = "-",
			font = beautiful.fontname .. "10",
			widget = wibox.widget.textbox,
		},
		spacing = dpi(4),
		layout = wibox.layout.fixed.horizontal,
	}
	return stat
end

M.ses = wibox.widget({
	{
		{
			{
				{
					{
						image = beautiful.img_dir .. "profile.png",
						resize = true,
						clip_shape = gears.shape.circle,
						widget = wibox.widget.imagebox,
					},
					forced_height = dpi(110),
					forced_width = dpi(110),
					widget = wibox.container.background,
				},
				{
					{
						{
							markup = help.fg(os.getenv("USER") or "foo", beautiful.pri, "1000"),
							font = beautiful.fontname .. "18",
							widget = wibox.widget.textbox,
						},
						{
							markup = help.fg(awesome.hostname or "arch", beautiful.fg, "bold"),
							font = beautiful.fontname .. "10",
							widget = wibox.widget.textbox,
						},
						spacing = dpi(4),
						layout = wibox.layout.fixed.vertical,
					},
					valign = "center",
					widget = wibox.container.place,
				},
				spacing = dpi(16),
				layout = wibox.layout.fixed.horizontal,
			},
			nil,
			{
				{
					create_button("\u{eb0a}", function()
						awful.spawn.easy_async_with_shell(
							"sh "
								.. beautiful.scripts_dir
								.. "wallpaper.sh -R -f -d "
								.. beautiful.theme_dir
								.. beautiful.activetheme
								.. "/wallpapers"
						)
					end),
					create_button("\u{eb0d}", function()
						awful.spawn.easy_async_with_shell(
							"rofi -show p -modi p:'"
								.. beautiful.scripts_dir
								.. "/power.sh"
								.. ' --symbols-font "tabler-icons"\' -theme Paper -theme power'
						)
					end),
					spacing = dpi(15),
					layout = wibox.layout.fixed.horizontal,
				},
				valign = "center",
				widget = wibox.container.place,
			},
			spacing = dpi(16),
			layout = wibox.layout.align.horizontal,
		},
		spacing = dpi(16),
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.margin,
	margins = { bottom = dpi(10), top = dpi(10), left = dpi(20), right = dpi(20) },
})

M.cal = wibox.widget({
	{
		{
			{
				format = help.fg("%a, %B %e", beautiful.pri, "bold"),
				refresh = 1,
				widget = wibox.widget.textclock,
				font = beautiful.fontname .. "10",
				align = "center",
			},
			{
				format = help.fg("%H:%M:%S", beautiful.pri, "1000"),
				refresh = 1,
				fg = beautiful.bg2,
				font = beautiful.fontname .. "18",
				align = "center",
				widget = wibox.widget.textclock,
			},
			spacing = dpi(10),
			layout = wibox.layout.flex.vertical,
		},
		widget = wibox.container.margin,
		margins = { top = dpi(30), bottom = dpi(30), right = dpi(20), left = dpi(20) },
	},
	shape = help.rrect(beautiful.br),
	bg = beautiful.bg2,
	fg = beautiful.pri,
	widget = wibox.container.background,
})

M.wth = wibox.widget({
	{
		{
			{
				id = "icn",
				align = "left",
				font = beautiful.fontname .. "36",
				widget = wibox.widget.textbox,
			},
			{

				{
					markup = "...",
					id = "wth",
					align = "right",
					font = beautiful.fontname .. "18",
					widget = wibox.widget.textbox,
				},
				{
					id = "wnd",
					align = "right",
					font = beautiful.fontname .. "10",
					widget = wibox.widget.textbox,
				},
				spacing = dpi(10),
				layout = wibox.layout.flex.vertical,
			},
			layout = wibox.layout.flex.horizontal,
		},
		widget = wibox.container.margin,
		margins = { top = dpi(30), bottom = dpi(30), right = dpi(20), left = dpi(20) },
	},
	shape = help.rrect(beautiful.br),
	bg = beautiful.bg2,
	fg = beautiful.fg2,
	widget = wibox.container.background,
})

local function wth_fch()
	-- m = ºC, km/h
	-- u = ºF, mph
	local unit = "m"
	-- empty: auto location
	local city = "alicante"
	-- seconds
	local interval = 60 * 30
	local com = "curl 'wttr.in/" .. city .. "?" .. unit .. "&format=%c+%t+%w'"

	awful.widget.watch(com, interval, function(_, out)
		local val = gears.string.split(out, " ")
		local sign = val[2]:sub(1, 1)

		M.wth:get_children_by_id("icn")[1].markup = val[1]
		M.wth:get_children_by_id("wth")[1].markup =
			help.fg((sign == "-" and "-" or "") .. val[2]:sub(2), beautiful.pri, "1000")
		M.wth:get_children_by_id("wnd")[1].markup = help.fg(val[3]:sub(1, -2), beautiful.fg2, "bold")
	end)
end

gears.timer({
	timeout = 10,
	single_shot = true,
	autostart = true,
	callback = function()
		wth_fch()
	end,
})

return M
