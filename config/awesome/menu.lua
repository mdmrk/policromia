local menu = {
  { "Refresh", awesome.restart },
  { "Logout", function() awesome.quit() end },
  { "Restart", function() awful.spawn.with_shell('reboot') end },
  { "Shutdown", function() awful.spawn.with_shell('shutdown now') end },
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
    { "Music", "kitty -e ncmpcpp" },
    { "Files", "thunar" },
  }
}

main.wibox.shape = help.rrect(beautiful.br)

root.buttons(gears.table.join(
  awful.button({ }, 3, function () main:toggle() end)
))
