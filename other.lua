local multiClick = require('utils/multi-clicker')

-- Shortcut: Hide notifications
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'p', function()
  hs.osascript.javascriptFromFile(hs.fs.currentDir() .. '/jxa-scripts/close-notifications.js')
end)

-- Shortcut: Click
-- in contrast to newMouseEvent, supports multiple clicks
local leftClicker = multiClick('leftMouse')

hs.hotkey.bind({}, '§', function()
  leftClicker.clickDown()
  leftClicker.clickUp()
end)
