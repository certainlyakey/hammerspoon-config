-- Shortcut: Hide notifications
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'p', function()
  hs.osascript.javascriptFromFile(hs.fs.currentDir() .. '/jxa-scripts/close-notifications.js')
end)

-- Shortcut: Click
hs.hotkey.bind({}, "§", function()
  local point = hs.mouse.absolutePosition()
  local clickState = hs.eventtap.event.properties.mouseEventClickState
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], point):setProperty(clickState, 1):post()
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], point):setProperty(clickState, 1):post()
end)
