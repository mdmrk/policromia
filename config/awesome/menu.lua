local system = {
	{
		"Lock screen",
		function()
			awful.spawn("betterlockscreen -l", false)
		end,
	},
	{
		"Log out",
		function()
			awesome.quit()
		end,
	},
	{
		"Reboot",
		function()
			awful.spawn("systemctl reboot")
		end,
	},
	{
		"Suspend",
		function()
			awful.spawn("systemctl suspend")
		end,
	},
	{
		"Hibernate",
		function()
			awful.spawn("systemctl hibernate")
		end,
	},
	{
		"Shut down",
		function()
			awful.spawn("systemctl poweroff")
		end,
	},
}

local awesome = {
	{ "Refresh", awesome.restart },
}

awful.menu.original_new = awful.menu.new
function awful.menu.new(...)
	local ret = awful.menu.original_new(...)
	ret.wibox.shape = help.rrect(beautiful.br)
	return ret
end

local main = awful.menu({
	items = {
		{ "System", system },
		{
			"Awesome",
			awesome,
		},
		{ "Terminal", "kitty" },
		{ "Browser", "firefox" },
		{ "Editor", "kitty -e nvim" },
		{ "Files", "thunar" },
	},
})

root.buttons(gears.table.join(awful.button({}, 3, function()
	main:toggle()
end)))
