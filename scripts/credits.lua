ctimer = Timer.new()
y = 0
finished = false
while not finished do
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	pad = Controls.read()
	if Timer.getTime(ctimer) > 100 then
		Timer.reset(ctimer)
		y = y + 2
	end
	c_y = y
	i = 1
	while c_y >= 0 do
		if i > #credits then
			c_y = -1
		else
			if c_y > 220 then
				if c_y > 240 and c_y < 460 then
					Font.print(def_font, 45, 460 - c_y, credits[i][1], credits[i][2], TOP_SCREEN)
				end
			else
				Font.print(def_font, 5, 220 - c_y, credits[i][1], credits[i][2], BOTTOM_SCREEN)
			end
			i = i + 1
			c_y = c_y - 20
		end
	end
	if Controls.check(pad, KEY_START) then
		Timer.destroy(ctimer)
		finished = true
	end
	Screen.flip()
	Screen.waitVblankStart()
end