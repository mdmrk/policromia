local help = {}

help.rrect = function(rad)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, rad)
	end
end

help.fg = function(text, color, thickness)
	return "<span foreground='" .. color .. "' font-weight='" .. thickness .. "'>" .. text .. "</span>"
end

help.merge = function(first_table, second_table)
	for k, v in pairs(second_table) do
		first_table[k] = v
	end
end

help.write_to_file = function(path, content)
	local activethemefile = io.open(path, "w")
	if not activethemefile then
		return
	end
	activethemefile:write(content .. "\n")
	activethemefile:close()
end

help.screenshot = function()
	awful.spawn.easy_async_with_shell(
		"scrot -s -l mode=edge -e 'xclip -selection clipboard -t image/png -i $f' /home/"
			.. os.getenv("USER")
			.. "/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H.%M.%S.png"
	)
end

help.truncate = function(count)
	local COUNT_ABBRS = { "", "K", "M", "B", "T" }
	if count < 1000 then
		return count
	end

	local i = math.floor(math.log(count) / math.log(1000))
	local result = count / (1000 ^ i)
	local digits = math.floor(math.log(result) / math.log(10)) + 1
	local decimals = math.max(0, 3 - digits)

	result = string.format("%." .. decimals .. "f", result)
	result = result .. COUNT_ABBRS[i + 1]

	return result
end

return help
