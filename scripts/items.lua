in_items = true
to_render = true
items_i = 1
while in_items do
	Screen.refresh()
	
	pad = Controls.read()
	
	-- Render Scene
	if to_render then
		OneshotPrint(RenderItemsMenu)
		to_render = false
	end
	
	-- Controls Triggering
	if (Controls.check(pad, KEY_B) and not  Controls.check(oldpad, KEY_B)) or (Controls.check(pad, KEY_START) and not  Controls.check(oldpad, KEY_START)) then
		in_items = false
	elseif (Controls.check(pad, KEY_DUP) and not  Controls.check(oldpad, KEY_DUP)) and #inventory > 0 then
		items_i = items_i - 1
		if items_i == 0 then
			items_i = #inventory
		end
		to_render = true
	elseif (Controls.check(pad, KEY_DDOWN) and not  Controls.check(oldpad, KEY_DDOWN)) and #inventory > 0 then
		items_i = items_i + 1
		if items_i > #inventory then
			items_i = 1
		end
		to_render = true
	end
	
	oldpad = pad
	Screen.flip()
	Screen.waitVblankStart()
end