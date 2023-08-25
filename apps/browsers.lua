local watchApp = require("../utils/watch-app")
local appnames = { "Safari", "Google Chrome", "Vivaldi" }

local hotkey1 = hs.hotkey.new({'cmd', 'ctrl'}, "c", nil, function()
  hs.osascript.applescriptFromFile(hs.fs.currentDir() .. "/apple-scripts/copy-url.applescript")
end, nil, nil)

watchApp.startAppWatcher(appnames, { hotkey1 })
