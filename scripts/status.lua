in_status = true
to_render = true
while in_status do
	Screen.refresh()
	
	pad = Controls.read()
	
	-- Render Scene
	if to_render then
		OneshotPrint(RenderStatusMenu)
		to_render = false
	end
	
	-- Controls Triggering
	if (Controls.check(pad, KEY_B) and not  Controls.check(oldpad, KEY_B)) or (Controls.check(pad, KEY_START) and not  Controls.check(oldpad, KEY_START)) then
		in_status = false
	elseif (Controls.check(pad, KEY_L) and not  Controls.check(oldpad, KEY_L)) then
		char_i = char_i - 1
		if char_i == 0 then
			char_i = #party
		end
		to_render = true
	elseif (Controls.check(pad, KEY_R) and not  Controls.check(oldpad, KEY_R)) then
		char_i = char_i + 1
		if char_i > #party then
			char_i = 1
		end
		to_render = true
	end
	
	oldpad = pad
	Screen.flip()
	Screen.waitVblankStart()
end