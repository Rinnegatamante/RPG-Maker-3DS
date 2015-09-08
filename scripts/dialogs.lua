-- Default colors
black = Color.new(0,0,0)
white = Color.new(255,255,255)
window = Color.new(132,205,255,120)
selected_window = Color.new(255,255,132,120)

-- Last space check for text integrity
function LastSpace(text)
	start = -1
	while string.sub(text,start,start) ~= " " do
		start = start - 1
	end
	return start
end

-- Cropper text function
function TextCrop(text)
	y = 190
	lines = {}
	while string.len(text) > 65 do
		endl = 66 + LastSpace(string.sub(text,1,65))
		table.insert(lines,{string.sub(text,1,endl), y})
		text = string.sub(text,endl+1,-1)
		y = y + 20
		if y >= 230 then
			y = 190
		end
	end
	if string.len(text) > 0 then
		table.insert(lines,{text, y})
	end
end

-- Show Dialog function (TODO: Facesets support, text animation)
function ShowDialog(text,check_confirm)
	move = "DIALOG"
	old_y = 0
	my_lines = {}
	TextCrop(text)
	for i,line in pairs(lines) do
		oldpad = pad
		if old_y > line[2] then
			checked = false
			while not checked do
				Screen.refresh()
				RenderMapScene()
				Screen.fillEmptyRect(5,395,180,235,Color.new(0,0,0),TOP_SCREEN)
				Screen.fillRect(6,394,181,234,window,TOP_SCREEN)
				for z,line2 in pairs(my_lines) do
					Font.print(def_font,15,line2[2],line2[1],black,TOP_SCREEN)					
				end
				if three then
					Screen.fillEmptyRect(5,395,180,235,Color.new(0,0,0),TOP_SCREEN, RIGHT_EYE)
					Screen.fillRect(6,394,181,234,window,TOP_SCREEN, RIGHT_EYE)
					for z,line2 in pairs(my_lines) do
						Font.print(def_font,15,line2[2],line2[1],black,TOP_SCREEN, RIGHT_EYE)					
					end
				end
				Screen.flip()
				Screen.waitVblankStart()
				pad = Controls.read()
				if Controls.check(pad,KEY_A) and not Controls.check(oldpad,KEY_A) then
					checked = true
				end
			end
			my_lines = {}
			table.insert(my_lines,{line[1],line[2]})
			old_y = line[2]
		else
			table.insert(my_lines,{line[1],line[2]})
			old_y = line[2]
		end
	end
	checked = false
	while not checked do
		oldpad = pad
		Screen.refresh()
		RenderMapScene()
		Screen.fillEmptyRect(5,395,180,235,Color.new(0,0,0),TOP_SCREEN)
		Screen.fillRect(6,394,181,234,window,TOP_SCREEN)
		for z,line2 in pairs(my_lines) do
			Font.print(def_font,15,line2[2],line2[1],black,TOP_SCREEN)					
		end
		if three then
			Screen.fillEmptyRect(5,395,180,235,Color.new(0,0,0),TOP_SCREEN, RIGHT_EYE)
			Screen.fillRect(6,394,181,234,window,TOP_SCREEN, RIGHT_EYE)
			for z,line2 in pairs(my_lines) do
				Font.print(def_font,15,line2[2],line2[1],black,TOP_SCREEN, RIGHT_EYE)					
			end
		end
		Screen.flip()
		Screen.waitVblankStart()
		pad = Controls.read()
		if Controls.check(pad,KEY_A) and not Controls.check(oldpad,KEY_A) then
			checked = true
		end
	end
	if check_confirm then
		-- TODO (Yes/No Dialog)
	else
		move = "STAY"
		return true
	end
end