--[[
    A random rice. i guess.
    source: https://github.com/saimoomedits/dotfiles
]]


pcall (require, "luarocks.loader")


-- home variable 🏠
home_var        = os.getenv("HOME")


-- user preferences ⚙️
user_likes      = {

    -- aplications
    term        = "kitty",
    editor      = "kitty -e " .. "nvim",
    code        = "codium",
    web         = "firefox",
    files       = "thunar",


    -- your profile
    username = os.getenv("USER"),
    userdesc = "arch",

    -- misc
    city = "alicante"
}



-- theme 🖌️
require("theme")

-- configs ⚙️
require("config")

-- miscallenous ✨
require("misc")

-- signals 📶
require("signal")

-- ui elements 💻
require("layout")