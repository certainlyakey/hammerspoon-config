-- Shortcut: Hide notifications
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'p', function()
  hs.osascript.javascriptFromFile(hs.fs.currentDir() .. '/jxa-scripts/close-notifications.js')
end)

-- Shortcut: Move window lower for Toggl Track
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, ';', function()
  local win = hs.window'aleksandrb'
  
  if win ~= nil then
    local f = win:frame()
    f.y = f.y + 50
    win:setFrame(f)
  end

end)
