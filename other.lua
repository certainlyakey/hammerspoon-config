-- Shortcut: Hide notifications
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'p', function()
  hs.osascript.javascriptFromFile(hs.fs.currentDir() .. '/jxa-scripts/close-notifications.js')
end)
