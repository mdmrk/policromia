-- Importing libraries
help = require('help')
gears = require('gears')
awful = require('awful')
wibox = require('wibox')
naughty = require("naughty")
beautiful = require('beautiful')
dpi = beautiful.xresources.apply_dpi

beautiful.init('~/.config/awesome/theme/init.lua')
keys = require('keys')
dashboard = require("dashboard")
sig = require('signals')

local signals = require("signals")
local req = {
  'notifications',
  'bar',
  'menu',
  'rules',
  'titlebar',
  'client',
  'awful.autofocus',
}

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
  help.randomize_wallpaper()
  local tagTable = {}
  for i = 1, keys.tags do
    table.insert(tagTable, tostring(i))
  end
  awful.tag(tagTable, s, awful.layout.layouts[1])
end)


-- Garbage Collection
collectgarbage('setpause', 110)
collectgarbage('setstepmul', 1000)

-- Signals
signals.vol()
signals.mic()

-- Autostart
awful.spawn("picom -b")