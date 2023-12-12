local help = require("help")
local gfs = require("gears.filesystem")
local theme_path = gfs.get_configuration_dir() .. "theme/"
local scripts_path = gfs.get_configuration_dir() .. "scripts/"
local img_path = gfs.get_configuration_dir() .. "img/"

local theme = {}

theme.theme_dir = theme_path
theme.img_dir = img_path
theme.scripts_dir = scripts_path
local activethemefile = io.open(theme.theme_dir .. "activetheme", "r")
if not activethemefile then
	return
end
theme.activetheme = activethemefile:read()
activethemefile:close()
help.merge(theme, require("theme." .. theme.activetheme .. ".colors"))
theme.fontname = "JetBrainsMono NF" .. " "
theme.barfontname = "JetBrainsMono NF" .. " "
theme.icofontname = "tabler-icons" .. " "
theme.fontsize = "10"
theme.barfontsize = "12"
theme.icofontsize = "15"
theme.font = theme.fontname .. theme.fontsize
theme.barfont = theme.barfontname .. theme.barfontsize
theme.icofont = theme.icofontname .. theme.icofontsize
theme.br = dpi(24)
theme.wall = ""

theme.dashboard_width = dpi(500)
theme.bar_width = dpi(50)
theme.fg_focus = theme.fg
theme.fg_normal = theme.fg .. "40"
theme.fg_minimize = theme.fg2

theme.bg_normal = theme.bg2
theme.bg_urgent = theme.err .. "40"
theme.bg_minimize = theme.fg .. "10"
theme.bg_focus = theme.fg2 .. "cc"

theme.useless_gap = dpi(4)
theme.snap_bg = theme.fg2
theme.border_width = dpi(0)
theme.border_color = theme.bg

theme.titlebar_fg = theme.fg .. "40"
theme.titlebar_fg_normal = theme.fg2
theme.titlebar_fg_focus = theme.fg
theme.titlebar_bg = theme.bg
theme.titlebar_bg_normal = theme.bg
theme.titlebar_font = theme.font

theme.taglist_bg = theme.bg
theme.taglist_bg_focus = theme.pri
theme.taglist_font = theme.barfont

theme.menu_bg_normal = theme.bg
theme.menu_bg_focus = theme.bg2
theme.menu_fg_normal = theme.fg
theme.menu_font = theme.font
theme.menu_border_color = theme.bg
theme.menu_height = dpi(32)
theme.menu_width = dpi(200)
theme.menu_border_width = dpi(12)

theme.tasklist_plain_task_name = true

theme.bg_systray = theme.bg
theme.systray_icon_spacing = dpi(10)
theme.systray_base_size = dpi(26)

theme.notification_bg = theme.bg
theme.notification_fg = theme.fg
theme.max_notification_width = dpi(225)
theme.notification_width = dpi(225)
theme.notification_max_height = dpi(100)
theme.notification_icon_size = dpi(50)

theme.separator_color = theme.fg2

theme.titlebar_minimize_button_focus = gears.color.recolor_image(img_path .. "circle.svg", theme.ok)
theme.titlebar_minimize_button_normal = gears.color.recolor_image(img_path .. "circle.svg", theme.fg2)
theme.titlebar_close_button_normal = gears.color.recolor_image(img_path .. "circle.svg", theme.fg2)
theme.titlebar_close_button_focus = gears.color.recolor_image(img_path .. "circle.svg", theme.err)
theme.tag = img_path .. "tag.svg"
theme.tag_sel = img_path .. "tag_sel.svg"
theme.yt = img_path .. "yt.svg"

return theme
