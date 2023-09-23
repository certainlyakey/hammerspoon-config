local globals = require('globals')

-- Shortcut: open home folder
hs.hotkey.bind({'alt', 'cmd'}, '1', function()
  hs.execute('open ~/')
end)

-- Shortcut: open documents folder
hs.hotkey.bind({'alt', 'cmd'}, '2', function()
  hs.execute('open ~/Documents/All')
end)

-- Shortcut: open downloads folder
hs.hotkey.bind({'alt', 'cmd'}, '3', function()
  hs.execute('open ~/Downloads')
end)

-- Shortcut: open Application Support
hs.hotkey.bind({'alt', 'cmd'}, '4', function()
  hs.execute('open ~/Library/Application\\ Support')
end)

-- Shortcut: open Projects
hs.hotkey.bind({'alt', 'cmd'}, '5', function()
  hs.execute('open ~/Projects')
end)

-- Shortcut: open Syncthing
hs.hotkey.bind({'alt', 'cmd'}, '7', function()
  hs.execute('open ~/Documents/All/Syncthing')
end)

-- Shortcut: open Project links
hs.hotkey.bind({'alt', 'ctrl', 'cmd'}, '7', function()
  hs.execute('open ~/Local/Link\\ Folders/Project\\ Links')
end)

-- Shortcut: open Trash
hs.hotkey.bind({'alt', 'cmd'}, 'b', function()
  hs.execute('open ~/.hammerspoon/bin/open-trash.app')
  hs.application.launchOrFocus('Finder')
end)

-- Shortcut: Eject disk images
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'e', function()
  --  From https://forum.keyboardmaestro.com/t/how-to-eject-mounted-dmg-images/29531/13
  hs.execute('for disk in $(/usr/bin/hdiutil info | /usr/bin/egrep -o "^/dev/disk\\d+" | /usr/bin/sort | /usr/bin/uniq); do /usr/bin/hdiutil detach $disk; done')
  hs.alert.show('Disk images ejected', globals.alertStyle)
end)

