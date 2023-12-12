-- Importing libraries
help = require("help")
gears = require("gears")
awful = require("awful")
wibox = require("wibox")
naughty = require("naughty")
beautiful = require("beautiful")
rubato = require("lib.rubato")
dpi = beautiful.xresources.apply_dpi
beautiful.init("~/.config/awesome/theme/init.lua")
keys = require("keys")
dashboard = require("dashboard")
sig = require("signals")
local signals = require("signals")
local req = {
	"notifications",
	"bar",
	"menu",
	"rules",
	"titlebar",
	"client",
	"awful.autofocus",
}
require("popup")

for _, x in pairs(req) do
	require(x)
end

-- Layouts
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
}

-- Virtual desktops/ Tabs
awful.screen.connect_for_each_screen(function(s)
	local tagTable = {}
	for i = 1, keys.tags do
		table.insert(tagTable, tostring(i))
	end
	awful.tag(tagTable, s, awful.layout.layouts[1])
end)

-- Signals
gears.timer({
	timeout = 10,
	single_shot = true,
	autostart = true,
	call_now = true,
	callback = function()
		signals.vol()
		signals.mic()
	end,
})

-- Autostart
awful.spawn("picom -b", false)
awful.spawn.with_shell("~/.fehbg")
