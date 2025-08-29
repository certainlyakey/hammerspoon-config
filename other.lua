local trimShellOutput = require('../utils/trim-shell-output')

-- Shortcut: Hide notifications
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'a', function()
  hs.osascript.javascriptFromFile(hs.fs.currentDir() .. '/jxa-scripts/close-notifications.js')
end)

-- Shortcut: Find window with home directory and move it lower for Toggl Track
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, ';', function()
  local o = hs.execute('whoami')
  local win = hs.window(trimShellOutput(o))

  if win ~= nil then
    local f = win:frame()
    f.y = f.y + 38
    win:setFrame(f)
  end

end)
