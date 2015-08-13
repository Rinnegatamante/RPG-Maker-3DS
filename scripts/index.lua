-- DEBUG
pos_x = 5
pos_y = 1
map = "map1"
-- END DEBUG

-- GPU Setup
Graphics.init()

-- Position Setup
hero_x = 16 + pos_x * 32
hero_y = pos_y * 32
move = "STAY"

-- Map Loading
dofile(System.currentDirectory().."/maps/"..map..".lua")

-- Hero Loading
hero = Screen.loadImage(System.currentDirectory().."/chars/hero.png")
hero_max_tile_x = Screen.getImageWidth(hero)
hero_max_tile_y = Screen.getImageHeight(hero)
hero_width = hero_max_tile_x / 3
hero_height = hero_max_tile_y / 4
hero_tile_x = hero_width
hero_tile_y = 0

-- Animation Setup
anim_timer = Timer.new()
Timer.pause(anim_timer)

-- Random Encounter
random_escaper = 0
function RandomEncounter()
	random_escaper = random_escaper + 1
	if rnd_encounter and random_escaper >= 5 then
		h,m,s = System.getTime()
		math.randomseed(h*3600+m*60+s)
		tckt = math.random(1,100)
		if tckt >= 70 then
			random_escaper = 0
			-- TODO: Start battle
		end
	end
end

-- Hero Collision Check (TODO: Add NPCs, unwalkable blocks collision checks)
function HeroCollision()
	if pos_x == 0 then
		can_go_left = false
	else
		can_go_left = true
	end
	if pos_y == 0 then
		can_go_up = false
	else
		can_go_up = true
	end
	if pos_x == ((map_width / 32) - 1) then
		can_go_right = false
	else
		can_go_right = true
	end
	if pos_y == ((map_height / 32) - 1) then
		can_go_down = false
	else
		can_go_down = true
	end
end

while true do

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
	if Controls.check(pad,KEY_DUP) and move == "STAY" then
		HeroCollision()
		if can_go_up then
			move = "UP"
			move_stage = 1
			tot_move_stage = 1
			Timer.resume(anim_timer)
			hero_tile_x = 0
		else
			move = nil
			hero_tile_y = hero_height * 3
		end
	elseif Controls.check(pad,KEY_DDOWN) and move == "STAY" then
		HeroCollision()
		if can_go_down then
			move = "DOWN"
			move_stage = 1
			tot_move_stage = 1
			Timer.resume(anim_timer)
			hero_tile_x = 0
		else
			move = nil
			hero_tile_y = 0
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
			move = nil
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
			move = nil
			hero_tile_y = hero_height * 2
		end
	end
	
	-- Drawing Scene
	Graphics.initBlend(TOP_SCREEN)
	Graphics.drawPartialImage(deboard_x, deboard_y, start_draw_x, start_draw_y, draw_width, draw_height, map_test) -- Draw Level1 Map (GPU)
	Graphics.termBlend()
	Screen.drawPartialImage(200 - (hero_width / 2), 120 - (hero_height / 2), hero_tile_x, hero_tile_y, hero_width, hero_height, hero, TOP_SCREEN) -- Draw Hero (CPU)
	
	-- DEBUG
	if Controls.check(pad,KEY_SELECT) and (not Controls.check(oldpad,KEY_SELECT)) then
		Screen.freeImage(hero)
		Graphics.term()
		Timer.CRASH_ME_NOW()
	end
	Screen.debugPrint(0,0,"X: "..pos_x.. " ("..hero_x.." pixels)",Color.new(255,255,255),BOTTOM_SCREEN)
	Screen.debugPrint(0,15,"Y: "..pos_y.. " ("..hero_y.." pixels)",Color.new(255,255,255),BOTTOM_SCREEN)
	Screen.debugPrint(0,30,"Map Width: "..((map_width / 32) - 1),Color.new(255,255,255),BOTTOM_SCREEN)
	Screen.debugPrint(0,45,"Map Height: "..((map_height / 32) - 1),Color.new(255,255,255),BOTTOM_SCREEN)
	-- END DEBUG
	
	-- Hero Animation
	if move ~= "STAY" then
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
			RandomEncounter()
		end
	end
	Screen.flip()
	Screen.waitVblankStart()
	oldpad = pad
end