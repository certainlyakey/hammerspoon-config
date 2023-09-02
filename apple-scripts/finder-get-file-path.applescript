set selectedFilePath to ""
tell application "Finder"
	set currentSelection to selection as alias list
	if currentSelection is not {} then
		set selectedFilePath to POSIX path of first item of currentSelection
	end if
end tell
return selectedFilePath
