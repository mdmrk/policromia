-- Importing libraries
gears = require('gears')
awful = require('awful')
wibox = require('wibox')
naughty = require("naughty")
beautiful = require('beautiful')
dpi = beautiful.xresources.apply_dpi

beautiful.init('~/.config/awesome/theme/init.lua')
keys = require('keys')
help = require('help')
dashboard = require("dashboard")
sig = require('signals')

local signals = require("signals")
local req = {
  'notif',
  'bar',
  'menu',
  'rule',
  'titlebar',
  'client',
  'awful.autofocus',
}

for _, x in pairs(req) do
  require(x)
end

local function set_wallpaper(s)
  if beautiful.wall then
    local wall = beautiful.wall
    if type(wall) == "function" then
      wall = wall(s)
    end
    gears.wallpaper.maximized(wall, s, true)
  end
end

screen.connect_signal("property::geometry", set_wallpaper)

-- Layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
}

-- Virtual desktops/ Tabs
awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
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
