tell application "Finder"
	set selectedFolder to ""
	set currentFolder to POSIX path of (target of front window as string)
	set currentSelection to selection as alias list
	if currentSelection is not {} then
		set selectedFolder to POSIX path of first item of currentSelection
	end if
	if selectedFolder ends with "/" then
		set result to selectedFolder
	else
		set result to currentFolder
	end if

	return result
end tell
