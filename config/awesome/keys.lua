local signals = require("signals")
local popup = require("popup")

-- Variables
local keys = {}

local mod = 'Mod4'
local tags = 5
keys.tags = tags

-- Keybindings
keys.globalkeys = gears.table.join(
-- Awesome
  awful.key({ mod, 'Shift' }, 'r', awesome.restart),
  awful.key({ mod }, 'd', function() dashboard.toggle() end),

  --Hardware ( Laptop Users )
  awful.key({}, 'XF86MonBrightnessUp', function() awful.spawn.with_shell('brightnessctl set 5%+ -q') end),
  awful.key({}, 'XF86MonBrightnessDown', function() awful.spawn.with_shell('brightnessctl set 5%- -q') end),
  awful.key({}, 'XF86AudioRaiseVolume', function()
    awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ +5%')
    signals.vol()
  end)
  ,
  awful.key({}, 'XF86AudioLowerVolume', function()
    awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ -5%')
    signals.vol()
  end)
  ,
  awful.key({}, "XF86AudioMute", function()
    signals.toggle_vol_mute()
  end),

  -- Window management
  awful.key({ 'Mod1' }, 'Tab', function() awful.client.focus.byidx(1) end),
  awful.key({ mod }, 't', function(c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" }),
  awful.key({ mod }, 'Right', function() awful.tag.incmwfact(0.025) end),
  awful.key({ mod }, 'Left', function() awful.tag.incmwfact(-0.025) end),
  awful.key({ mod }, 'Up', function() awful.client.incwfact(0.05) end),
  awful.key({ mod }, 'Down', function() awful.client.incwfact(-0.05) end),

  -- Applications
  awful.key({ mod }, 'Return', function() awful.util.spawn('kitty') end),
  awful.key({ mod }, 'e', function() awful.util.spawn('rofi -show drun -show-icons -theme apps') end),
  awful.key({ mod, "Shift" }, 'e',
    function() awful.util.spawn("rofi -modi emoji -show emoji -emoji-format '<span size=\"20pt\">{emoji}</span>' -emoji-mode copy -theme emoji") end)
  ,

  -- Screenshots
  awful.key({ mod, "Shift" }, 's',
    function() awful.util.spawn("scrot -s -e 'xclip -selection clipboard -t image/png -i $f' /home/" ..
        os.getenv('USER') .. "/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H.%M.%S.png")
    end)
)

-- Keyboard Control
keys.clientkeys = gears.table.join(
  awful.key({ mod }, 'q', function(c) c:kill() end),
  awful.key({ mod }, 'm', function(c) c.minimized = true end),
  awful.key({ mod }, 'space', function(c) c.fullscreen = not c.fullscreen; c:raise() end),
  awful.key({ mod }, 'Tab', function() awful.client.floating.toggle() end)
)

-- Mouse controls
keys.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c) client.focus = c end),
  awful.button({ mod }, 1, function() awful.mouse.client.move() end),
  awful.button({ mod }, 2, function(c) c:kill() end),
  awful.button({ mod }, 3, function() awful.mouse.client.resize() end)
)

for i = 1, tags do
  keys.globalkeys = gears.table.join(keys.globalkeys,

    -- View tag
    awful.key({ mod }, '#' .. i + 9,
      function()
        local tag = awful.screen.focused().tags[i]
        if tag then
          tag:view_only()
        end
      end),

    -- Move window to tag
    awful.key({ mod, 'Shift' }, '#' .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end))
end

-- Set globalkeys
root.keys(keys.globalkeys)

return keys
