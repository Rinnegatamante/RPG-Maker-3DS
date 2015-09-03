is_end = false
trans_timer = Timer.new()

while not is_end do
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	RenderMapScene()
	Screen.fillRect(0, math.min(math.floor(Timer.getTime(trans_timer) / 3), 399), 0, 239, black, TOP_SCREEN)
	if Timer.getTime(trans_timer) > 1500 then
		is_end = true
		Timer.destroy(trans_timer)
	end
	Screen.flip()
	Screen.waitVblankStart()
end