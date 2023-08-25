local watchApp = require("../utils/watch-app")
local appname = "Safari"

local hotkey1 = hs.hotkey.new({'cmd'}, "q", nil, function()
  hs.osascript.applescriptFromFile("apple-scripts/safari-quit-confirmation.applescript")
end, nil, nil)

watchApp.startAppWatcher({ appname }, { hotkey1 })
