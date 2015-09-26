-- PROTOTYPE! Enemy I.A.
function IA(enemy)
	if #enemy > 14 then -- TODO: Custom IA
	else
		if #enemy.spells > 0 then -- TODO: Enemy spells support
		else
			action = "attack"
			atk_type = "melee"
			target = party_stats[math.random(1, #battle_party)]
			target_name = party[math.random(1, #battle_party)]
		end
	end
end

-- Damage Calculation Algorithm
function DamageCalculation(owner, target, name_own, name_target, atk_type)
	crit_try = math.random(1, 100)
	if crit_try <= crit_hit then
		is_critical = true
	else
		is_critical = false
	end
	if atk_type == "melee" or atk_type == "ranged" then
		real_dmg = math.random(owner.attack_min, owner.attack_max)
		real_def = target.defense
	else
		real_dmg = owner.magic_attack
		real_def = target.magic_defense
	end
	final_dmg = math.max(real_dmg - real_def, 1)
	if target.resistence[atk_type] ~= 0 then
		extra = math.floor((final_dmg * target.resistence[atk_type]) / 100)
		final_dmg = final_dmg - extra
	end
	if is_critical then
		final_dmg = final_dmg * 2
	end
	battle_status = name_own .. "inflicted " .. final_dmg .. " HP damages to " .. name_target
	return final_dmg
end

-- PROTOTYPE! Battle System function (TODO: Music, refine gameplay)
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
		table.insert(order_game, party[i])
		table.insert(order_stats, party_stats[i])
	end
	
	-- Loading enemies info
	battle_enemies = {}
	for i, enemy in pairs(enemies) do
		dofile(System.currentDirectory().."/monsters/"..enemy..".lua")
		enemy_img = Graphics.loadImage(System.currentDirectory().."/sprites/"..sprite..".png")
		monster_info = {
			["id"] = i,
			["name"] = name,
			["attack_type"] = attack_type, 
			["attack_min"] = attack_min,
			["attack_max"] = attack_max,
			["magic_attack"] = magic_attack,
			["spells"] = spells,
			["defense"]	= defense,
			["magic_defense"] = magic_defense,
			["level"] = level,
			["speed"] = speed,
			["crit_hit"] = crit_hit,
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
	
	-- Calculating battle order
	z = 0
	while z < #party do
		j = 1
		while j < #party - z do
			if order_stats[j].speed < order_stats[j+1].speed then
				tmp = order_stats[j]
				order_stats[j] = order_stats[j+1]
				order_stats[j+1] = order_stats[j]
				tmp = order_game[j]
				order_game[j] = order_game[j+1]
				order_game[j+1] = order_game[j]
			end
			j = j + 1
		end
		z = z + 1
	end
	for i, enemy in pairs(battle_enemies) do
		z = 1
		while z <= #order_stats do
			if enemy[2].speed < order_stats[z].speed then
				table.insert(order_stats, z, enemy[2])
				table.insert(order_game, z, enemy[2].name)
				break
			else
				z = z  + 1
			end
		end
		if z > #order_stats then
			table.insert(order_stats, enemy[2])
			table.insert(order_game, enemy[2].name)
		end
	end
	
	-- Battle System
	end_battle = false
	selected_voice = 1
	order_idx = 1
	battle_timer = Timer.new()
	Timer.pause(battle_timer)
	action = "null"
	turn = order_game[1]
	if order_stats[1].id == nil then
		battle_status = turn .. "'s turn. What you want to do?"
	else
		IA(order_stats[1])
	end
	
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
		if action == "null" then
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
		end
		
		-- Animations (TODO)
		if action == "escape" then
			if Timer.getTime(battle_timer) > 2500 then
				end_battle = true
				Timer.destroy(battle_timer)
			end
		elseif action == "attack" then
			if not executed then
				DamageCalculation(order_stats[order_idx], target, order_game[order_idx], target_name, atk_type)
				Timer.resume(battle_timer)
				executed = true
			else
				if Timer.getTime(battle_timer) > 2500 then
					action = "null"
					order_idx = order_idx + 1
					if order_idx > #order_stats then
						order_idx = 1
					end
					Timer.reset(battle_timer)
					Timer.pause(battle_timer)
					executed = false
					if order_stats[order_idx].id ~= nil then
						IA(order_stats[order_idx])
					end
				end
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