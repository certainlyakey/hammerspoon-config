tell application "Safari" to tell front window
		set currentindex to index of current tab
		if currentindex is equal to number of tabs then return
		move tab currentindex to after tab (currentindex + 1)
		set current tab to tab (currentindex + 1)
end tell
