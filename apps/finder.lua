local watchApp = require("../utils/watch-app")
local appname = "Finder"

local hotkey1 = hs.hotkey.new({'ctrl'}, "h", nil, function()
  local app = hs.appfinder.appFromName(appname_for_trigger)
  hs.eventtap.event.newKeyEvent({ "shift", "cmd" }, ".", true):post(app)
end, nil, nil)

local hotkey2 = hs.hotkey.new({'ctrl', 'alt'}, "c", nil, function()
  local app = hs.appfinder.appFromName(appname)
  app:selectMenuItem({"File", "Open With", "Nova"})
  app:selectMenuItem({"File", "Open With", "Nova (default)"})
end, nil, nil)

watchApp.startAppWatcher({ appname }, { hotkey1, hotkey2 })
