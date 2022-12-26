-- weather signal
--~~~~~~~~~~~~~~~~~~~~
-- taken from elenapan
-- not in use, as of now


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local helpers = require("helpers")


-- Configuration
local city = user_likes.city


-- Don't update too often, because your requests might get blocked for 24 hours
local update_interval = 1600
local temp_file = "/tmp/weather-" .. city

local weather_details_script = [[
    bash -c 'curl "wttr.in/Alicante?format=1"']]

helpers.remote_watch(weather_details_script, update_interval, temp_file, function(stdout)
    local tokens = {}
    local i = 0
    for v in stdout:gmatch("%S+") do
        tokens[i] = v
        i = i + 1
    end

    local icon = tokens[0]
    local temp = tokens[1]

    if icon == "..." then
        awful.spawn.with_shell("rm " .. temp_file)
        awesome.emit_signal("signal::weather", "", "Weather unavailable")
    else
        awesome.emit_signal("signal::weather", icon, temp)
    end
end)
