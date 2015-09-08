function OneshotPrint(my_func)
	my_func()
	Screen.flip()
	Screen.refresh()
	my_func()
end

function FormatTime(seconds)
	minute = math.floor(seconds/60)
	seconds = math.floor(seconds%60)
	hours = math.floor(minute/60)
	minute = minute%60
	if minute < 10 then
		minute = "0"..minute
	end
	if seconds < 10 then
		seconds = "0"..seconds
	end
	if hours < 10 then
		hours = "0"..hours
	end
	return hours..":"..minute..":"..seconds
end

function RenderMapScene()
	Graphics.initBlend(TOP_SCREEN)	
	lind = 1
	while lind <= 3 do
		int_x = deboard_x
		int_y = deboard_y
		int_tile_x = start_draw_x
		int_tile_y = start_draw_y
		int_width = draw_width
		int_height = draw_height
		if lind == 3 then
			Graphics.drawPartialImage(math.tointeger(200 - (hero_width / 2)), math.tointeger(120 - (hero_height / 2)), hero_tile_x, hero_tile_y, hero_width, hero_height, hero) -- Hero
		end
		while int_y < deboard_y + int_height do
			t_dbd_y = int_tile_y % 32
			while int_x < deboard_x + int_width do
				t_dbd_x = int_tile_x % 32
				layer_index = 1 + math.floor(int_tile_x / 32) + math.floor(int_tile_y / 32) * map_length
				id = layers[lind][layer_index]
				if id ~= -1 then
					id_y = math.floor(id / tileset_length) * 32
					id_x = math.floor((id % tileset_length) * 32)
					Graphics.drawPartialImage(int_x - t_dbd_x, int_y - t_dbd_y, id_x, id_y, 32, 32, t)
				end
				int_x = int_x + 32 - t_dbd_x
				int_tile_x = int_tile_x + 32 - t_dbd_x
			end
			int_y = int_y + 32 - t_dbd_y
			int_tile_y = int_tile_y + 32 - t_dbd_y
			int_tile_x = start_draw_x
			int_x = deboard_x
		end
		lind = lind + 1
	end
	Graphics.termBlend()
end

function RenderBattleScene()
	x = 30
	y = 50
	ch_x = x
	ch_y = y
	Graphics.initBlend(TOP_SCREEN)
	Graphics.drawImage(0,0,bg_img)
	for i,hero in pairs(battle_party) do
		Graphics.drawPartialImage(x, y, 32, 64, 32, 32, hero)
		x = x + 5
		y = y + 50
	end
	-- TODO: Better enemies auto-locator
	x = 300
	y = 100
	for i,enemy in pairs(battle_enemies) do
		Graphics.drawImage(x, y, enemy[1])
		x = x + 5
		y = y + 50
	end
	Graphics.termBlend()
	Screen.fillEmptyRect(5, 395, 5, 25, black, TOP_SCREEN)
	Screen.fillRect(6, 394, 6, 24, window, TOP_SCREEN)
	Font.print(def_font, 10, 7, battle_status, black, TOP_SCREEN)
	for i,sel in pairs(party) do
		if turn == sel then
			x_s = ch_x + (5 * (i - 1))
			y_s = ch_y * i
			Screen.drawLine(x_s + 8, x_s + 24, y_s - 14, y_s - 14, black, TOP_SCREEN)
			Screen.drawLine(x_s + 8, x_s + 16, y_s - 14, y_s - 4, black, TOP_SCREEN)
			Screen.drawLine(x_s + 24, x_s + 16, y_s - 14, y_s - 4, black, TOP_SCREEN)
		end
	end
end

function RenderCommandsMenu(items_list,selected)
	x = 5
	y = 10
	for i,voice in pairs(items_list) do
		Screen.fillEmptyRect(x,x + 80, y, y + 20, white, BOTTOM_SCREEN)
		if i == selected then
			Screen.fillRect(x + 1,x + 79, y + 1, y + 19,selected_window,BOTTOM_SCREEN)
		else
			Screen.fillRect(x + 1,x + 79, y + 1, y + 19,window,BOTTOM_SCREEN)
		end
		Font.print(def_font,x + 5, y + 2, voice, black, BOTTOM_SCREEN)
		y = y + 25
	end
end

function RenderStatusMenu()
	Screen.clear(BOTTOM_SCREEN)
	
	-- Stats Window
	Screen.fillEmptyRect(0 , 116, 0, 145, white, BOTTOM_SCREEN)
	Screen.fillRect(1 , 115, 1, 144, window, BOTTOM_SCREEN)
	Screen.drawPartialImage(85, 5, hero_width, hero_height, hero_width, hero_height , raw_party_chars[char_i], BOTTOM_SCREEN)
	Font.print(def_font, 5, 5, party[char_i] .. " (Lv. " .. party_stats[char_i].level .. ")", Color.new(255,255,0), BOTTOM_SCREEN)
	Font.print(def_font, 5, 20, "HP: " .. party_stats[char_i].hp .. " / " .. party_stats[char_i].hp_max, white, BOTTOM_SCREEN)
	Font.print(def_font, 5, 35, "MP: " .. party_stats[char_i].mp .. " / " .. party_stats[char_i].mp_max, white, BOTTOM_SCREEN)
	Font.print(def_font, 5, 50, "Attack: " .. party_stats[char_i].attack_min .. " - " .. party_stats[char_i].attack_max, white, BOTTOM_SCREEN)
	Font.print(def_font, 5, 65, "Magic Atk.: " .. party_stats[char_i].magic_attack, white, BOTTOM_SCREEN)
	Font.print(def_font, 5, 80, "Defense: " .. party_stats[char_i].defense, white, BOTTOM_SCREEN)
	Font.print(def_font, 5, 95, "Magic Def.: " .. party_stats[char_i].magic_defense, white, BOTTOM_SCREEN)
	Font.print(def_font, 5, 110, "Speed: " .. party_stats[char_i].speed, white, BOTTOM_SCREEN)
	Font.print(def_font, 5, 125, "Crit. Hit: " .. party_stats[char_i].crit_hit .. "%", white, BOTTOM_SCREEN)
	
	-- Immunity/Resistence Window
	Screen.fillEmptyRect(0 , 319, 145, 239, white, BOTTOM_SCREEN)
	Screen.fillRect(1 , 318, 146, 238, window, BOTTOM_SCREEN)
	Font.print(def_font, 130, 148, "Resistence: ", Color.new(255,255,0), BOTTOM_SCREEN)
	Font.print(def_font, 50, 163, "Melee: " .. party_stats[char_i].resistence.melee .. "%", white, BOTTOM_SCREEN)
	Font.print(def_font, 200, 163, "Ranged: " .. party_stats[char_i].resistence.ranged .. "%", white, BOTTOM_SCREEN)
	Font.print(def_font, 50, 178, "Magic: " .. party_stats[char_i].resistence.magic .. "%", white, BOTTOM_SCREEN)
	Font.print(def_font, 200, 178, "Fire: " .. party_stats[char_i].resistence.fire .. "%", white, BOTTOM_SCREEN)
	Font.print(def_font, 50, 193, "Ice: " .. party_stats[char_i].resistence.ice .. "%", white, BOTTOM_SCREEN)
	Font.print(def_font, 200, 193, "Thunder: " .. party_stats[char_i].resistence.thunder .. "%", white, BOTTOM_SCREEN)
	Font.print(def_font, 50, 208, "Water: " .. party_stats[char_i].resistence.water .. "%", white, BOTTOM_SCREEN)
	Font.print(def_font, 200, 208, "Sancta: " .. party_stats[char_i].resistence.sancta .. "%", white, BOTTOM_SCREEN)
	Font.print(def_font, 50, 223, "Dark: " .. party_stats[char_i].resistence.dark .. "%", white,  BOTTOM_SCREEN)
	Font.print(def_font, 200, 223, "Ade: " .. party_stats[char_i].resistence.ade .. "%", white, BOTTOM_SCREEN)
	
	-- Equip Window
	Screen.fillEmptyRect(116 , 319, 0, 145, white, BOTTOM_SCREEN)
	Screen.fillRect(117 , 318, 1, 144, window, BOTTOM_SCREEN)
	Font.print(def_font, 120, 3, "Equipment:", Color.new(255,255,0), BOTTOM_SCREEN)
	for i, item in pairs(party_stats[char_i].equip) do
		if i == "Weapon" then
			extra_y = 4
		elseif i == "Hands" then
			extra_y = 2
		elseif i == "Chest" then
			extra_y = 1
		elseif i == "Shield" then
			extra_y = 5
		elseif i == "Hair" then
			extra_y = 0
		elseif i == "Foots" then
			extra_y = 3
		elseif i == "Accessory" then
			extra_y = 6
		end
		Font.print(def_font, 120, 28 + 16 * extra_y, i .. ": " .. item, white, BOTTOM_SCREEN)
	end
end

function RenderItemsMenu()

	-- Drawing background
	Screen.clear(BOTTOM_SCREEN)
	Screen.fillEmptyRect(0 , 319, 0, 20, white, BOTTOM_SCREEN)
	Screen.fillRect(1 , 318, 1, 19, window, BOTTOM_SCREEN)
	Screen.fillEmptyRect(0 , 250, 20, 239, white, BOTTOM_SCREEN)
	Screen.fillRect(1 , 249, 21, 238, window, BOTTOM_SCREEN)
	Screen.fillEmptyRect(250 , 319, 20, 239, white, BOTTOM_SCREEN)
	Screen.fillRect(251 , 318, 21, 238, window, BOTTOM_SCREEN)
	
	-- Loading selected item description
	if #inventory > 0 then
	dofile(System.currentDirectory().."/items/"..inventory[items_i][1]..".lua")
	end
	Font.print(def_font, 3, 3, description, white, BOTTOM_SCREEN)
	
	-- Drawing item list (TODO: Scroll for big inventories)
	y = 23
	for i, item in pairs(inventory) do
		if items_i == i then
			Screen.fillRect(1, 249, 21 + 20 * (i - 1),  21 + 20 * i, Color.new(0, 128, 255), BOTTOM_SCREEN)
			Font.print(def_font, 3, y, item[1], Color.new(255,255,0), BOTTOM_SCREEN)
			Font.print(def_font, 240 - 5 * string.len(item[2]), y, item[2], Color.new(255,255,0), BOTTOM_SCREEN)
		else
			Font.print(def_font, 3, y, item[1], white, BOTTOM_SCREEN)
			Font.print(def_font, 240 - 5 * string.len(item[2]), y, item[2], white, BOTTOM_SCREEN)
		end
		y = y + 20
	end
end

function RenderPauseMenu()
	y = 3
	max_y = 20 * #pause_voices
	
	-- Main Menu
	Screen.fillEmptyRect(0 , 100, 0, 2 + max_y, white, BOTTOM_SCREEN)
	Screen.fillRect(1 , 99, 0, 1 + max_y, window, BOTTOM_SCREEN)
	for i, voice in pairs(pause_voices) do
		if i == pause_i then
			Screen.fillRect(1, 99, 1 + 20 * (i - 1),  1 + 20 * i, Color.new(0, 128, 255), BOTTOM_SCREEN)
			Font.print(def_font, 3, y, voice, Color.new(255,255,0), BOTTOM_SCREEN)
		else
			Font.print(def_font, 3, y, voice, white, BOTTOM_SCREEN)
		end
		y = y + 20
	end
	
	-- Info Window
	Screen.fillEmptyRect(0 , 100, 2 + max_y, 239, white, BOTTOM_SCREEN)
	Screen.fillRect(1 , 99, 3 + max_y, 238, window, BOTTOM_SCREEN)
	Font.print(def_font, 33, 5 + max_y, "Gold", Color.new(255,255,0), BOTTOM_SCREEN)
	Font.print(def_font, 8, 25 + max_y, gold, white, BOTTOM_SCREEN)
	Font.print(def_font, 32, 65 + max_y, "Time", Color.new(255,255,0), BOTTOM_SCREEN)
	Font.print(def_font, 8, 85 + max_y, FormatTime(Timer.getTime(game_time) / 1000), white, BOTTOM_SCREEN)
	
	-- Characters Window
	Screen.fillEmptyRect(100 , 319, 0, 239, white, BOTTOM_SCREEN)
	Screen.fillRect(101 , 318, 1, 238, window, BOTTOM_SCREEN)
	char_y = 15
	for i, chara in pairs(party) do
		if submode == "CHARACTERS" then
			if char_i == i then
				Screen.fillRect(101, 318, 1 + 59 * (i - 1), 1 + 59 * i, Color.new(0, 128, 255), BOTTOM_SCREEN)
			end
		end
		Font.print(def_font, 115, char_y - 10, chara, Color.new(255,255,0), BOTTOM_SCREEN)
		Font.print(def_font, 210, char_y - 10, "Lv. " .. party_stats[i].level, white, BOTTOM_SCREEN)
		Font.setPixelSizes(def_font,14)
		if (100 * ((party_stats[i].hp_max - party_stats[i].hp) / party_stats[i].hp_max)) >= 85 then
			Font.print(def_font, 110, char_y + 5, "HP: " .. party_stats[i].hp .. " / " .. party_stats[i].hp_max , Color.new(255,0,0), BOTTOM_SCREEN)
		elseif (100 * ((party_stats[i].hp_max - party_stats[i].hp) / party_stats[i].hp_max)) >= 60 then
			Font.print(def_font, 110, char_y + 5, "HP: " .. party_stats[i].hp .. " / " .. party_stats[i].hp_max , Color.new(255,255,0), BOTTOM_SCREEN)
		else
			Font.print(def_font, 110, char_y + 5, "HP: " .. party_stats[i].hp .. " / " .. party_stats[i].hp_max , white, BOTTOM_SCREEN)
		end
		Font.print(def_font, 210, char_y + 5, "MP: " .. party_stats[i].mp .. " / " .. party_stats[i].mp_max , white, BOTTOM_SCREEN)
		Font.print(def_font, 110, char_y + 20, "EXP: " .. party_stats[i].exp .. " / " .. party_stats[i].exp_to_level , white, BOTTOM_SCREEN)
		Screen.drawPartialImage(280, char_y, hero_width, hero_height, hero_width, hero_height , raw_party_chars[i], BOTTOM_SCREEN)
		char_y = char_y + 59
		Font.setPixelSizes(def_font,16)
	end
end