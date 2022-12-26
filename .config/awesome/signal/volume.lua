-- volume signal
----------------

-- ("signal::volume"), function(percentage(int), muted(bool))


local awful = require("awful")

local volume_old = 0
local muted_old = false
local function emit_volume_info()
    -- Get volume info of the currently active sink
    -- The currently active sink has a star `*` in front of its index
    -- In the output of `pacmd list-sinks`, lines +7 and +11 after "* index:"
    -- contain the volume level and muted state respectively
    -- This is why we are using `awk` to print them.
    awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@ | awk -F' ' '{print $5}' | xargs | tr -d '[%]'"
        , function(stdout)
        local volume = stdout
        local volume_int = tonumber(volume)
        if volume_int ~= volume_old then
            awesome.emit_signal("signal::volume", volume_int, muted_old)
            volume_old = volume_int
        end
    end)
    awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@ | awk -F' ' '{print $2}' | xargs",
        function(stdout)
            local muted = stdout
            local muted_bool = string.find(muted, "yes") and 1 or 0
            if muted_bool ~= muted_old then
                awesome.emit_signal("signal::volume", volume_old, muted_bool)
                muted_old = muted_bool
            end
        end)
    -- Only send signal if there was a change
    -- We need this since we use `pactl subscribe` to detect
    -- volume events. These are not only triggered when the
    -- user adjusts the volume through a keybind, but also
    -- through `pavucontrol` or even without user intervention,
    -- when a media file starts playing.
end

-- Run once to initialize widgets
emit_volume_info()

-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local volume_script = [[
    bash -c "
    LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"
    "]]


-- Kill old pactl subscribe processes
awful.spawn.easy_async({ "pkill", "--full", "--uid", os.getenv("USER"), "^pactl subscribe" }, function()
    -- Run emit_volume_info() with each line printed
    awful.spawn.with_line_callback(volume_script, {
        stdout = function(line)
            emit_volume_info()
        end
    })
end)
