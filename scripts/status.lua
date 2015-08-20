in_status = true
while in_status do
	Screen.refresh()
	Screen.clear(BOTTOM_SCREEN)
	
	pad = Controls.read()
	
	-- Render Scene
	RenderStatusMenu()
	
	-- Controls Triggering
	if (Controls.check(pad, KEY_B) and not  Controls.check(oldpad, KEY_B)) or (Controls.check(pad, KEY_START) and not  Controls.check(oldpad, KEY_START)) then
		in_status = false
	end
	oldpad = pad
	Screen.flip()
	Screen.waitVblankStart()
end