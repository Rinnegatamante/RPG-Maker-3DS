map_width = 960
map_height = 256
tile1 = Screen.loadImage(System.currentDirectory().."/tilesets/test.png")
b1 = {128,128}
b2 = {128,158}
b3 = {128,256}
level1 = {	b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3,
			b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3,
			b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3,
			b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3, b3,
			b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1,
			b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1, b1,
			b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2, b2
		 }
		 
map = Screen.createImage(map_width, map_height, Color.new(0,0,0))
i = 1
w_temp = 0
h_temp = 0
while i <= #level1 do
	if w_temp >= map_width then
		w_temp = 0
		h_temp = h_temp + 32
	end
	Screen.drawPartialImage(w_temp, h_temp, level1[i][1], level1[i][2], 32, 32, tile1, map)
	w_temp = w_temp + 32
	i = i + 1
end
map_test = Graphics.loadImage(map)