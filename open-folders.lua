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

-- Shortcut: open Syncthing
hs.hotkey.bind({'alt', 'cmd'}, '7', function()
  hs.execute('open ~/Documents/All/Syncthing')
end)
