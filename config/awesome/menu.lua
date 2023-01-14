local menu = {
  { "Refresh", awesome.restart },
  { "\u{f2f5} Logout", function() awesome.quit() end },
  { "\u{f2ea} Restart", function() awful.spawn.with_shell('reboot') end },
  { "\u{f011} Shutdown", function() awful.spawn.with_shell('shutdown now') end },
}

local main = awful.menu {
  items = {
    {
      "Awesome",
      menu,
    },
    { "Terminal", "kitty" },
    { "Browser", "firefox" },
    { "Editor", "kitty -e nvim" },
    { "Files", "thunar" },
  }
}

main.wibox.shape = help.rrect(beautiful.br)

root.buttons(gears.table.join(
  awful.button({}, 3, function() main:toggle() end)
))
