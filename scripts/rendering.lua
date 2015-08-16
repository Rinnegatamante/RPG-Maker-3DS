function RenderMapScene()
	Graphics.initBlend(TOP_SCREEN)
	Graphics.drawPartialImage(deboard_x, deboard_y, start_draw_x, start_draw_y, draw_width, draw_height, map_l1) -- Level1 Map
	Graphics.drawPartialImage(deboard_x, deboard_y, start_draw_x, start_draw_y, draw_width, draw_height, map_l2) -- Level2 Map
	Graphics.drawPartialImage(math.tointeger(200 - (hero_width / 2)), math.tointeger(120 - (hero_height / 2)), hero_tile_x, hero_tile_y, hero_width, hero_height, hero) -- Hero
	Graphics.drawPartialImage(deboard_x, deboard_y, start_draw_x, start_draw_y, draw_width, draw_height, map_l3) -- Level3 Map
	Graphics.termBlend()
end

function RenderBattleScene()
	x = 30
	y = 50
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