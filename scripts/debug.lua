function Print(text)
	Screen.refresh()
	Screen.clear(BOTTOM_SCREEN)
	Screen.debugPrint(0,0,text,Color.new(255,255,255),BOTTOM_SCREEN)
	Screen.flip()
	Screen.waitVblankStart()
end

function EnableScreenshots()
	if Controls.check(Controls.read(), KEY_SELECT) then
		System.takeScreenshot("/rpgmaker_sshot.bmp",false)
	end
end