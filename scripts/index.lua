-- DEBUG
pos_x = 5
pos_y = 1
map = "map1"
event1 = false
party = {"hero","hero2","hero3","hero4"}
-- END DEBUG

-- Loading modules
dofile(System.currentDirectory().."/scripts/dialogs.lua") -- Dialogs Module
dofile(System.currentDirectory().."/scripts/rendering.lua") -- Rendering Module
dofile(System.currentDirectory().."/scripts/battle.lua") -- Battle Module
dofile(System.currentDirectory().."/scripts/debug.lua") -- Debug Module

-- Menu Voices
menu_buttons = {"New Game","Load Game","Credits","Exit Game"}
index = 1

-- Font Setup
def_font = Font.load(System.currentDirectory().."/fonts/main.ttf")
Font.setPixelSizes(def_font,16)

-- Loading Splashscreen
splash = Screen.loadImage(System.currentDirectory().."/pictures/splashscreen.jpg")

while true do
	pad = Controls.read()
	Screen.refresh()
	Screen.clear(BOTTOM_SCREEN)
	
	-- Drawing Splashscreen
	Screen.drawImage(0,0,splash,TOP_SCREEN)
	
	-- Drawing menu
	y = 50
	for i, voice in pairs(menu_buttons) do
		Screen.fillEmptyRect(80, 240, y, y + 20, white, BOTTOM_SCREEN)
		if i == index then
			Screen.fillRect(81, 239, y + 1, y + 19, selected_window, BOTTOM_SCREEN)
		else
			Screen.fillRect(81, 239, y + 1, y + 19, window, BOTTOM_SCREEN)
		end
		Font.print(def_font, 85, y + 3, voice, black, BOTTOM_SCREEN)
		y = y + 25
	end
	
	-- Controls triggering
	if Controls.check(pad,KEY_DUP) and not Controls.check(oldpad,KEY_DUP) then
		index = index - 1
	elseif Controls.check(pad,KEY_DDOWN) and not Controls.check(oldpad,KEY_DDOWN) then
		index = index + 1
	end
	if index == 0 then
		index = 1
	end
	if index > #menu_buttons then
		index = #menu_buttons
	end
	if Controls.check(pad,KEY_A) and not Controls.check(oldpad,KEY_A) then
		if index == 1 then -- New Game
			dofile(System.currentDirectory().."/settings/new_game.lua")
			dofile(System.currentDirectory().."/scripts/map.lua")
		elseif index == 2 then -- Load Game (TODO)
		elseif index == 3 then -- Credits
			dofile(System.currentDirectory().."/settings/credits.lua")
			dofile(System.currentDirectory().."/scripts/credits.lua")
		elseif index == 4 then -- Exit Game
			Font.unload(def_font)
			System.exit()
		end
	end
	
	oldpad = pad
	Screen.flip()
	Screen.waitVblankStart()
end