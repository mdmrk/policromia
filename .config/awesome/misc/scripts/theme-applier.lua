-- a lua script that changes theme based on variable
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- source: https://github.com/saimoomedits/dotfiles
-- idk.
-- this will be improved later, maybe.
-- for now it works fine. :/


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local readwrite = require("misc.scripts.read_writer")



-- misc/vars
-- ~~~~~~~~~

-- current theme state file
local output = readwrite.readall("theme_state")

-- apply light/dark theme
-- ~~~~~~~~~~~~~~~~~~~~~~
if require("theme.ui_vars").color_scheme == "light" then

    if output == "light" then
        return
    else
        readwrite.write("theme_state", "light")
        awful.spawn.easy_async_with_shell([[

            # gtk theme / icon theme
            sed -i '2s/.*/gtk-theme-name=Materia-light/g' ~/.config/gtk-3.0/settings.ini
            sed -i '3s/.*/gtk-icon-theme-name=Papirus-light/g' ~/.config/gtk-3.0/settings.ini

            ]], function()
            require("layout.ding.extra.short")("", "Dark mode disabled")
        end)
    end
else

    if output == "dark" then
        return
    else
        readwrite.write("theme_state", "dark")
        awful.spawn.easy_async_with_shell([[

            # gtk theme / icon theme
            sed -i '2s/.*/gtk-theme-name=Materia-dark/g' ~/.config/gtk-3.0/settings.ini
            sed -i '3s/.*/gtk-icon-theme-name=Papirus-dark/g' ~/.config/gtk-3.0/settings.ini
            
            ]], function()
            require("layout.ding.extra.short")("", "Dark mode enabled")
        end)
    end
end
