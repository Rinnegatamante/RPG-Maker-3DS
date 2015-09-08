-- GPU Setup
Graphics.init()

-- Hero Loading
hero_max_tile_x = 32 * 3
hero_max_tile_y = 32 * 4
hero_width = hero_max_tile_x / 3
hero_height = hero_max_tile_y / 4
hero_tile_x = hero_width
hero_tile_y = 0

-- Position Setup
hero_x = 16 + pos_x * 32
hero_y = pos_y * 32
move = "STAY"
in_game = true

-- Map Loading
dofile(System.currentDirectory().."/maps/"..map.."/map.lua")
dofile(System.currentDirectory().."/maps/"..map.."/events.lua")
map_max_x = (map_width / 32) - 1
map_max_y = (map_height / 32) - 1
layers = {level1, level2, level3}
map_length = map_width / 32
tileset_length = tileset_w / 32

-- Animation Setup
anim_timer = Timer.new()
Timer.pause(anim_timer)

-- Pause Menu Setup
pause_voices = {"Items","Magic","Equipment","Status","Save Game","Exit Game"}

-- Random Encounter function
random_escaper = 0
function RandomEncounter()
	random_escaper = random_escaper + 1
	if rnd_encounter and random_escaper >= 5 then
		h,m,s = System.getTime()
		math.randomseed(h*3600+m*60+s)
		tckt = math.random(1,100)
		if tckt >= 70 then
			random_escaper = 0
			CallBattle({monsters[math.random(1,#monsters)]},false)
		end
	end
end

-- Hero Collision Check (TODO: Add NPCs collision checks)
no_clip = false
function HeroCollision()
	raw_pos = pos_x + 1 + pos_y * (map_max_x + 1)
	if pos_x == 0 then
		can_go_left = false
	else
		can_go_left = true
		if map_table[raw_pos - 1] == 2 then
			can_go_left = false
		end
	end
	if pos_y == 0 then
		can_go_up = false
	else
		can_go_up = true
		if map_table[raw_pos - (map_max_x + 1)] == 2 then
			can_go_up = false
		end
	end
	if pos_x == ((map_width / 32) - 1) then
		can_go_right = false
	else
		can_go_right = true
		if map_table[raw_pos + 1] == 2 then
			can_go_right = false
		end
	end
	if pos_y == ((map_height / 32) - 1) then
		can_go_down = false
	else
		can_go_down = true
		if map_table[raw_pos + (map_max_x + 1)] == 2 then
			can_go_down = false
		end
	end
	if no_clip then
		can_go_down = true
		can_go_left = true
		can_go_right = true
		can_go_up = true
	end
end

while in_game do

	-- Engine Setup
	pad = Controls.read()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	
	-- Map Setup
	start_draw_x = hero_x - 200
	if start_draw_x < 0 then
		deboard_x = 200 - hero_x
		start_draw_x = 0
	else
		deboard_x = 0
	end
	start_draw_y = hero_y - 120
	if start_draw_y < 0 then
		deboard_y = 120 - hero_y
		start_draw_y = 0
	else
		deboard_y = 0
	end
	if hero_x + 200 > map_width then
		if deboard_x == 0 then
			draw_width = 200 + (map_width - hero_x)
		else
			draw_width = (hero_x + 200) - map_width + deboard_x
		end
	else
		draw_width = 400 - deboard_x
	end
	if hero_y + 120 > map_height then
		if deboard_y == 0 then
			draw_height = 120 + (map_height - hero_y)
		else
			draw_height = (hero_y + 120) - map_height + deboard_y
		end
	else
		draw_height = 240 - deboard_y
	end
	
	-- Hero Movement Triggering
	if Controls.check(pad,KEY_DUP) then
		if move == "STAY" then
			HeroCollision()
			if can_go_up then
				move = "UP"
				move_stage = 1
				tot_move_stage = 1
				Timer.resume(anim_timer)
				hero_tile_x = 0
			else
				move = "STAY"
				hero_tile_y = hero_height * 3
			end
		elseif move == "PAUSE" and not Controls.check(oldpad, KEY_DUP) then
			if submode == "MAIN" then
				pause_i = pause_i - 1
				if pause_i == 0 then
					pause_i = 1
				end
			elseif submode == "CHARACTERS" then
				char_i = char_i - 1
				if char_i == 0 then
					char_i = #party
				end
			end
		end
	elseif Controls.check(pad,KEY_DDOWN) then
		if move == "STAY" then
			HeroCollision()
			if can_go_down then
				move = "DOWN"
				move_stage = 1
				tot_move_stage = 1
				Timer.resume(anim_timer)
				hero_tile_x = 0
			else
				move = "STAY"
				hero_tile_y = 0
			end
		elseif move == "PAUSE" and not Controls.check(oldpad, KEY_DDOWN) then
			if submode == "MAIN" then
				pause_i = pause_i + 1
				if pause_i > #pause_voices then
					pause_i = #pause_voices
				end
			elseif submode == "CHARACTERS" then
				char_i = char_i + 1
				if char_i > #party then
					char_i = 1
				end
			end
		end
	elseif Controls.check(pad,KEY_DLEFT) and move == "STAY" then
		HeroCollision()
		if can_go_left then
			move = "LEFT"
			move_stage = 1
			tot_move_stage = 1
			Timer.resume(anim_timer)
			hero_tile_x = 0
		else
			move = "STAY"
			hero_tile_y = hero_height
		end
	elseif Controls.check(pad,KEY_DRIGHT) and move == "STAY" then
		HeroCollision()
		if can_go_right then
			move = "RIGHT"
			move_stage = 1
			tot_move_stage = 1
			Timer.resume(anim_timer)
			hero_tile_x = 0
		else
			move = "STAY"
			hero_tile_y = hero_height * 2
		end
	elseif Controls.check(pad,KEY_START) and not Controls.check(oldpad, KEY_START) then
		if move == "STAY" then
			move = "PAUSE"
			submode = "MAIN"
			pause_i = 1
		elseif move == "PAUSE" then
			move = "STAY"
		end
	end
	
	-- Drawing Scene through GPU
	RenderMapScene()
	
	-- Drawing Menu when enabled
	if move == "PAUSE" then
		RenderPauseMenu()
		
		-- Menu Controls
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			if submode == "MAIN" then
				if pause_i == 1 then -- Items
					dofile(System.currentDirectory().."/scripts/items.lua")
				elseif pause_i == 2 then
		
				elseif pause_i == 3 then
		
				elseif pause_i == 4 then -- Status
					submode = "CHARACTERS"
					char_i = 1
				elseif pause_i == 5 then
		
				elseif pause_i == 6 then -- Exit Game
					Graphics.freeImage(hero)
					Graphics.freeImage(t)	
					Graphics.term()
					Timer.destroy(anim_timer)
					in_game = false
				end
			elseif submode == "CHARACTERS" then
				if pause_i == 4 then -- Open Status Page
					dofile(System.currentDirectory().."/scripts/status.lua")
				end
			end
		end
		if Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
			if submode == "MAIN" then
				move = "STAY"
			elseif submode == "CHARACTERS" then
				submode = "MAIN"
			end
		end
	end
	
	-- Events Triggering
	MapEvents()
	
	-- DEBUG
	EnableScreenshots()
	NoClipMode()
	-- END DEBUG
	
	-- Hero Animation
	if move == "UP" or move == "DOWN" or move == "RIGHT" or move == "LEFT" then
		if move == "UP" then
			pos_molt = 3
			hxm = 0
			hym = -4
			new_pos_y = pos_y - 1
			new_pos_x = pos_x
		elseif move == "DOWN" then
			pos_molt = 0
			hxm = 0
			hym = 4
			new_pos_y = pos_y + 1
			new_pos_x = pos_x
		elseif move == "RIGHT" then
			pos_molt = 2
			hxm = 4
			hym = 0
			new_pos_y = pos_y
			new_pos_x = pos_x + 1
		elseif move == "LEFT" then
			pos_molt = 1
			hxm = -4
			hym = 0
			new_pos_y = pos_y
			new_pos_x = pos_x - 1
		end
		if tot_move_stage <= 8 then
			if Timer.getTime(anim_timer) > (40 * move_stage) then
				move_stage = move_stage + 1
				hero_x = hero_x + hxm
				hero_y = hero_y + hym
				tot_move_stage =  tot_move_stage + 1
			end
			if Timer.getTime(anim_timer) > 200 then
				hero_tile_x = hero_tile_x + hero_width * 2
				Timer.reset(anim_timer)
				move_stage = 1
			end
			hero_tile_y = hero_height * pos_molt
			if hero_tile_x	>= hero_max_tile_x then
				hero_tile_x = 0
			end
		else
			Timer.pause(anim_timer)
			Timer.reset(anim_timer)
			move = "STAY"
			hero_tile_x = hero_width
			pos_x = new_pos_x
			pos_y = new_pos_y
			if not MapEvents() then
				RandomEncounter()
			end
		end
	end
	
	Screen.flip()
	Screen.waitVblankStart()
	oldpad = pad
end