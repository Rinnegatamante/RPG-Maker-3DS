-- PROTOTYPE! Enemy I.A.
function IA(enemy)
	if #enemy > 14 then -- TODO: Custom IA
	else
		if #enemy.spells > 0 then -- TODO: Enemy spells support
		else
			action = "attack"
			target = math.random(1, #battle_party)
		end
	end
end

-- PROTOTYPE! Battle System function (TODO: Music, transitions, gameplay)
function CallBattle(enemies,is_boss_fight)
	
	-- Battle Transition
	tdir = System.listDirectory(System.currentDirectory().."/battle_transitions")
	h,m,s = System.getTime()
	math.randomseed(h*3600+m*60+s)
	dofile(System.currentDirectory().."/battle_transitions/"..tdir[math.random(1, #tdir)].name)
	
	-- Initializing battle
	order_game = {}
	order_stats = {}
	
	-- Selecting Battleground
	h,m,s = System.getTime()
	math.randomseed(h*3600+m*60+s)
	bg_id = bgs[math.random(1,#bgs)]
	bg_img = Graphics.loadImage(System.currentDirectory().."/battlegrounds/"..bg_id..".png")
	
	-- Loading party info
	battle_party = party_chars
	for i, hero in pairs(party_stats) do
		if #order_game == 0 then
			table.insert(order_game, party[i])
			table.insert(order_stats, party_stats[i])
		else
			if hero.speed > order_stats[i-1].speed then
				order_stats[i] = order_stats[i-1]
				order_game[i] = order_game[i-1]
				order_stats[i-1] = hero
				order_game[i-1] = party[i]
			end
		end
	end
	
	-- Loading enemies info
	battle_enemies = {}
	for i,enemy in pairs(enemies) do
		dofile(System.currentDirectory().."/monsters/"..enemy..".lua")
		enemy_img = Graphics.loadImage(System.currentDirectory().."/sprites/"..sprite..".png")
		monster_info = {
			["name"] = name,
			["attack_type"] = attack_type, 
			["attack_min"] = attack_min,
			["attack_max"] = attack_max,
			["spells"] = spells,
			["defense"]	= defense,
			["level"] = level,
			["hp"] = hp,
			["mp"] = mp,
			["experience"] = experience,
			["loot"] = loot,
			["immunity"] = immunity,
			["weakness"] = weakness,
			["resistence"] = resistence
		}
		table.insert(battle_enemies,{enemy_img,monster_info})
		if custom_ia then -- TODO: Custom IA for Boss fights or particular fights (like tutorials)
		end
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
		
		-- 3D Setup
		if (Screen.get3DLevel() == 0) and three then
			Screen.disable3D()
			three = nil
		elseif three == nil and (Screen.get3DLevel > 0) then
			Screen.enable3D()
			three = true
		end
		
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
		
		-- Animations (TODO)
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