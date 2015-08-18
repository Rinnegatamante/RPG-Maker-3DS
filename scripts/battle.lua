-- PROTOTYPE! Battle System function (TODO: Music, transitions, gameplay)
function CallBattle(enemies,is_boss_fight)
	
	-- Selecting Battleground
	h,m,s = System.getTime()
	math.randomseed(h*3600+m*60+s)
	bg_id = bgs[math.random(1,#bgs)]
	tmp = Screen.loadImage(System.currentDirectory().."/battlegrounds/"..bg_id..".png")
	bg = Screen.createImage(1,1,Color.new(0,0,0))
	Screen.flipImage(tmp, bg)
	bg_img = Graphics.loadImage(bg)
	
	-- Loading party charsets
	battle_party = party_chars
	
	-- Loading enemies info
	battle_enemies = {}
	for i,enemy in pairs(enemies) do
		dofile(System.currentDirectory().."/monsters/"..enemy..".lua")
		tmp = Screen.loadImage(System.currentDirectory().."/sprites/"..sprite..".png")
		enm = Screen.createImage(1,1,Color.new(0,0,0))
		Screen.flipImage(tmp, enm)
		enemy_img = Graphics.loadImage(enm)
		table.insert(battle_enemies,{enemy_img,monster_info})
	end
		
	-- Battle System
	end_battle = false
	selected_voice = 1
	battle_timer = Timer.new()
	Timer.pause(battle_timer)
	action = "null"
	-- DEBUG
		turn = "hero"
		battle_status = turn .. "'s turn. What you want to do?"
	-- END DEBUG
	while not end_battle do
		Screen.refresh()
		Screen.clear(BOTTOM_SCREEN)
		pad = Controls.read()
		
		-- Drawing Scene
		RenderBattleScene()
		
		-- Commands Scene
		buttons = {"Attack","Spells","Items","Defense"}
		if not is_boss_fight then
			table.insert(buttons, "Escape")
		end
		RenderCommandsMenu(buttons,selected_voice)
		
		-- Controls Triggering
		if Controls.check(pad,KEY_DUP) and not Controls.check(oldpad,KEY_DUP) then
			selected_voice = selected_voice - 1
		elseif Controls.check(pad,KEY_DDOWN) and not Controls.check(oldpad,KEY_DDOWN) then
			selected_voice = selected_voice + 1
		end
		if selected_voice == 0 then
			selected_voice = 1
		end
		if selected_voice > #buttons then
			selected_voice = #buttons
		end
		if Controls.check(pad,KEY_A) and not Controls.check(oldpad,KEY_A) then
			if selected_voice == 5 then -- Escape (TODO: Check if escape fails or not)
				battle_status = "Escaped succesfully!"
				Timer.resume(battle_timer)
				action = "escape"
			end
		end
		
		-- Animations
		if action == "escape" then
			if Timer.getTime(battle_timer) > 2500 then
				end_battle = true
				Timer.destroy(battle_timer)
			end
		end
		
		-- DEBUG
		if Controls.check(pad,KEY_SELECT) then
			System.takeScreenshot("/bs.bmp",false)
		end
		-- END DEBUG
		
		oldpad = pad
		Screen.flip()
		Screen.waitVblankStart()
	end
end