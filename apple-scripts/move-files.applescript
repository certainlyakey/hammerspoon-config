tell application "System Events" to tell process "Finder"
    set frontmost to true
    click (menu item 1 where its name starts with "Move") of menu 1 of menu bar item "Edit" of menu bar 1
end tell