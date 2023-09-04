set selectedFileContents to ""
tell application "Finder"
	set currentSelection to selection as alias list
	if currentSelection is not {} then
		set selectedFile to first item of currentSelection
		set selectedFilePath to POSIX path of selectedFile
		if selectedFilePath does not end with "/" then
			set selectedFileContents to (read file selectedFile)
		end if
	end if
end tell
set the clipboard to selectedFileContents
-- See https://www.reddit.com/r/hammerspoon/comments/rr9zjx/trying_to_copy_file_to_clipboard/jb7qca1 on copying an image
