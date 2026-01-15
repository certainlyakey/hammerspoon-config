tell application "Finder"
    activate --probably not really necessary
    set currentfolder to target of window 1
    set clonedwindow to make new Finder window to currentfolder
end tell
