local menu = {
  { "\u{f021} Refresh",  awesome.restart },
  { "\u{f2f5} Logout",   function() awesome.quit() end },
  { "\u{f01e} Restart",  function() awful.spawn.with_shell('reboot') end },
  { "\u{f011} Shutdown", function() awful.spawn.with_shell('shutdown now') end },
}

local main = awful.menu {
  items = {
    {
      "Awesome",
      menu,
    },
    { "\u{f120} Terminal", "kitty" },
    { "\u{f0ac} Browser",  "firefox" },
    { "\u{f15b} Editor",   "kitty -e nvim" },
    { "\u{f07b} Files",    "thunar" },
  }
}

root.buttons(gears.table.join(
  awful.button({}, 3, function() main:toggle() end)
))
