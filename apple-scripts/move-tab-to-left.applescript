tell application "Safari" to tell front window
		set currentindex to index of current tab
		if currentindex is 1 then return
		move tab currentindex to before tab (currentindex - 1)
		set current tab to tab (currentindex - 1)
end tell
