local watchApp = require("../utils/watch-app")
local appname = "Finder"

-- Hotkey setup
local hotkey = hs.hotkey.new({'ctrl'}, "h", nil, function()
  local app = hs.appfinder.appFromName(appname_for_trigger)
  hs.eventtap.event.newKeyEvent({ "shift", "cmd" }, ".", true):post(app)
end, nil, nil)

watchApp.startAppWatcher({ appname }, { hotkey })
