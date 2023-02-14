local M = {}

local vol =
[[ str=$( pactl get-sink-volume @DEFAULT_SINK@ | awk -F' ' '{print $5}' | xargs | tr -d '[%]' ); printf "$(pactl get-sink-mute @DEFAULT_SINK@ | awk -F' ' '{print $2}' | xargs) ${str% *}\n" ]]
local mic =
[[ str=$( pactl get-source-volume @DEFAULT_SOURCE@ | awk -F' ' '{print $5}' | xargs | tr -d '[%]' ); printf "$(pactl get-source-mute @DEFAULT_SOURCE@ | awk -F' ' '{print $2}' | xargs) ${str% *}\n" ]]
local net = [[ nmcli -c no networking connectivity check ]]
local bat =
[[ charge=$(acpi | awk -F' ' '{print $4}' | xargs | tr -d '[%,]'); printf "$(acpi | awk -F' ' '{print $3}' | xargs | tr -d '[,]') ${charge% *}\n" ]]

M.vol = function()
  awful.spawn.easy_async_with_shell(vol, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('vol::value', val[1]:match("yes") and 1 or 0, tonumber(val[2]))
  end)
end

M.mic = function()
  awful.spawn.easy_async_with_shell(mic, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('mic::value', val[1]:match("yes") and 1 or 0, tonumber(val[2]))
  end)
end

M.net = function()
  awful.spawn.easy_async_with_shell(net, function(out)
    awesome.emit_signal('net::value', (out:match("full") or out:match("portal")) and 1 or 0)
  end)
end

M.bat = function()
  awful.spawn.easy_async_with_shell(bat, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('bat::value', val[1], tonumber(val[2]))
  end)
end

gears.timer {
  timeout = 30,
  call_now = true,
  autostart = true,
  callback = function()
    M.net()
    M.bat()
  end
}

M.set_vol = function(val)
  awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ ' .. val .. "%")
end

M.set_mic = function(val)
  awful.spawn.with_shell('pactl set-source-volume @DEFAULT_SOURCE@ ' .. val .. "%")
end

M.toggle_vol_mute = function()
  awful.spawn.with_shell('pactl set-sink-mute @DEFAULT_SINK@ toggle')
  M.vol()
end

M.toggle_mic_mute = function()
  awful.spawn.with_shell('pactl set-source-mute @DEFAULT_SOURCE@ toggle')
  M.mic()
end

return M
