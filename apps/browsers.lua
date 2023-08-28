local watchApp = require("../utils/watch-app")
-- TODO: support for many apps at once is not perfect – alternating apps fail to enable/disable their shortcuts in correct sequence when switching from app to app
local appnames = { "Safari", "Google Chrome" }

local hotkey1 = hs.hotkey.new({'cmd', 'ctrl'}, "c", nil, function()
  hs.osascript.applescriptFromFile(hs.fs.currentDir() .. "/apple-scripts/copy-url.applescript")
end, nil, nil)

-- watchApp.startAppWatcher(appnames, { hotkey1 })


hs.window.filter.new(appnames)
:subscribe(hs.window.filter.windowFocused,function() hotkey1:enable() end)
:subscribe(hs.window.filter.windowUnfocused,function() hotkey1:disable() end)

