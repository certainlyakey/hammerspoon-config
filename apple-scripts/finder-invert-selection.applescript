tell application "Finder"
	if not (exists Finder window 1) then return

	set inverted to {}
	set fitems to items of Finder window 1 as alias list
	set selectedItems to the selection as alias list
	repeat with itemRef in fitems
		if itemRef is not in selectedItems then
			set end of inverted to itemRef
		end if
	end repeat
	select inverted
end tell
