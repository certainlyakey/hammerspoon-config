local watchApp = require("../utils/watch-app")
local appname = "Safari"

-- Hotkey setup
local hotkey1 = hs.hotkey.new({'alt', 'ctrl', 'cmd'}, "escape", nil, function()
  local app = hs.appfinder.appFromName(appname)
  app:selectMenuItem({"File", "New Window"})
  -- hs.eventtap.event.newKeyEvent({ "shift", "cmd" }, "m", true):post(app)
end, nil, nil)

local hotkey2 = hs.hotkey.new({'cmd'}, "q", nil, function()
  hs.osascript.applescriptFromFile("apple-scripts/safari-quit-confirmation.applescript")
end, nil, nil)

watchApp.startAppWatcher({ appname }, { hotkey1, hotkey2 })
