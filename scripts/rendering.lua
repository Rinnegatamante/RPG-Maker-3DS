function RenderMapScene()
	Graphics.initBlend(TOP_SCREEN)
	Graphics.drawPartialImage(deboard_x, deboard_y, start_draw_x, start_draw_y, draw_width, draw_height, map_l1) -- Level1 Map
	Graphics.drawPartialImage(deboard_x, deboard_y, start_draw_x, start_draw_y, draw_width, draw_height, map_l2) -- Level2 Map
	Graphics.drawPartialImage(math.tointeger(200 - (hero_width / 2)), math.tointeger(120 - (hero_height / 2)), hero_tile_x, hero_tile_y, hero_width, hero_height, hero) -- Hero
	Graphics.drawPartialImage(deboard_x, deboard_y, start_draw_x, start_draw_y, draw_width, draw_height, map_l3) -- Level3 Map
	Graphics.termBlend()
end