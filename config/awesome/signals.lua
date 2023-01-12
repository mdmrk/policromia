local M = {}

local vol = [[ str=$( pactl get-sink-volume @DEFAULT_SINK@ | awk -F' ' '{print $5}' | xargs | tr -d '[%]' ); printf "$(pactl get-sink-mute @DEFAULT_SINK@ | awk -F' ' '{print $2}' | xargs) ${str% *}\n" ]]
local mic = [[ str=$( pactl get-source-volume @DEFAULT_SOURCE@ | awk -F' ' '{print $5}' | xargs | tr -d '[%]' ); printf "$(pactl get-source-mute @DEFAULT_SOURCE@ | awk -F' ' '{print $2}' | xargs) ${str% *}\n" ]]
local net = [[ printf "$(nmcli networking connectivity check)" ]]
local blue = [[ bluetoothctl show | grep "Powered:" ]]
local fs = [[ df -h --output=used,size / | sed 's/G//g' ]]
local temp = [[ cat /sys/class/thermal/thermal_zone0/temp ]]
local mem = [[   
  while IFS=':k ' read -r mem1 mem2 _; do
    case "$mem1" in
      MemTotal)
        memt="$(( mem2 / 1024 ))";;
      MemAvailable)
        memu="$(( memt - mem2 / 1024))";;
    esac;
  done < /proc/meminfo;
  printf "%d %d" "$memu" "$memt"; ]]
local bat = [[ charge=$(acpi | awk -F' ' '{print $4}' | xargs  | tr -d '[%,]'); printf "$(acpi | awk -F' ' '{print $3}' | xargs | tr -d '[,]') ${charge% *}\n" ]]

M.mem = function()
  awful.spawn.easy_async_with_shell(mem, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('mem::value', tonumber(val[1]), tonumber(val[2]))
  end)
end

M.fs = function()
  awful.spawn.easy_async_with_shell(fs, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('fs::value', tonumber(val[6]), tonumber(val[8]))
  end)
end

M.temp = function()
  awful.spawn.easy_async_with_shell(temp, function(out)
    awesome.emit_signal('temp::value', tonumber(out))
  end)
end

M.vol = function()
  awful.spawn.easy_async_with_shell(vol, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('vol::value', val[1], tonumber(val[2]))
  end)
end

M.mic = function()
  awful.spawn.easy_async_with_shell(mic, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('mic::value', val[1], tonumber(val[2]))
  end)
end

M.net = function()
  awful.spawn.easy_async_with_shell(net, function(out)
    awesome.emit_signal('net::value', out)
  end)
end

M.blu = function()
  awful.spawn.easy_async_with_shell(blue, function(out)
    if out == "" then
      awesome.emit_signal('blu::value', "no")
    else
      local val = gears.string.split(out, " ")
      awesome.emit_signal('blu::value', val[2])
    end
  end)
end

M.bat = function()
  awful.spawn.easy_async_with_shell(bat, function(out)
    local val = gears.string.split(out, " ")
    awesome.emit_signal('bat::value', val[1], tonumber(val[2]))
  end)
end

gears.timer {
  timeout = 60,
  call_now = true,
  autostart = true,
  callback = function()
    M.mem()
    M.temp()
    M.bat()
  end
}

M.set_vol = function(val)
  awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ ' .. tonumber(val) .. "%")
end

M.set_mic = function(val)
  awful.spawn.with_shell('pactl set-source-volume @DEFAULT_SOURCE@ ' .. tonumber(val) .. "%")
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
