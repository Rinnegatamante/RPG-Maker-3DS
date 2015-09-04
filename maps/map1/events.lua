
function MapEvents()

	-- EVENT 1 - Walking trigger type Event (Oneshot)
	if not event1 then
		if pos_x == 21 and pos_y == 3 then
			ShowDialog("I heard a strange noise. I hope there is nothing to worry about. I should check where it came from, maybe it was made by rats...")
			event1 = true
			return true
		end
		if pos_x == 22 and pos_y == 3 then
			ShowDialog("I heard a strange noise. I hope there is nothing to worry about. I should check where it came from, maybe it was made by rats...")
			event1 = true
			return true
		end
	end
	
	return false
end