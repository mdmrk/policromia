-- FontAwesome
local function make_fa_icon(code)
    return wibox.widget {
        font   = theme.icon_font .. theme.icon_size,
        markup = ' <span color="' .. icon_color .. '">' .. code .. '</span> ',
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end
