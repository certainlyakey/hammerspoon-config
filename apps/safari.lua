-- local watchApp = require("../utils/watch-app")
local appname = "Safari"

-- Shortcut: Quit confirmation
local hotkey1 = hs.hotkey.new({'cmd'}, "q", nil, function()
  hs.osascript.applescriptFromFile("apple-scripts/safari-quit-confirmation.applescript")
end, nil, nil)

-- Shortcut: Move tab to the left
local hotkey2 = hs.hotkey.new({'ctrl', 'alt'}, ",", nil, function()
  hs.osascript.applescriptFromFile("apple-scripts/move-tab-to-left.applescript")
end, nil, nil)

-- Shortcut: Move tab to the right
local hotkey3 = hs.hotkey.new({'ctrl', 'alt'}, '.', nil, function()
  hs.osascript.applescriptFromFile("apple-scripts/move-tab-to-right.applescript")
end, nil, nil)

-- watchApp.startAppWatcher({ appname }, { hotkey1 })

local wf = hs.window.filter.new(appname)
wf:subscribe(hs.window.filter.windowFocused,function()
  hotkey1:enable()
  hotkey2:enable()
  hotkey3:enable()
end)
:subscribe(hs.window.filter.windowUnfocused,function()
  hotkey1:disable()
  hotkey2:disable()
  hotkey3:disable()
end)
