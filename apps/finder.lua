-- local watchApp = require("../utils/watch-app")
local appname = "Finder"
local app = hs.appfinder.appFromName(appname)

local hotkey1 = hs.hotkey.new({'ctrl'}, "h", nil, function()
  hs.eventtap.event.newKeyEvent({ "shift", "cmd" }, ".", true):post(app)
end, nil, nil)

local hotkey2 = hs.hotkey.new({'ctrl', 'alt'}, "c", nil, function()
  app:selectMenuItem({"File", "Open With", "Nova"})
  app:selectMenuItem({"File", "Open With", "Nova (default)"})
end, nil, nil)

local hotkey3 = hs.hotkey.new({'shift', 'cmd'}, "t", nil, function()
  local _, path = hs.osascript.applescriptFromFile(hs.fs.currentDir() .. "/apple-scripts/get-finder-folder.applescript")
  hs.execute('open -a iTerm "' .. path .. '"')
end, nil, nil)

local hotkey4 = hs.hotkey.new({'shift', 'cmd'}, 'f', nil, function()
  local _, path = hs.osascript.applescriptFromFile(hs.fs.currentDir() .. "/apple-scripts/get-finder-folder.applescript")
  hs.execute('open -a fork "' .. path .. '"')
end, nil, nil)

local hotkey5 = hs.hotkey.new({'shift', 'cmd'}, 'c', nil, function()
  hs.osascript.applescriptFromFile("apple-scripts/finder-copy-file-contents.applescript")
end, nil, nil)

local hotkey6 = hs.hotkey.new({'ctrl'}, 't', nil, function()
  hs.osascript.applescriptFromFile("apple-scripts/finder-create-file.applescript")
end, nil, nil)

local hotkey7 = hs.hotkey.new({'ctrl', 'cmd'}, 'c', nil, function()
  hs.osascript.applescriptFromFile("apple-scripts/finder-copy-file-path.applescript")
end, nil, nil)

local hotkey8 = hs.hotkey.new({'cmd'}, "left", nil, function()
  app:selectMenuItem({"Go", "Back"})
end, nil, nil)

local hotkey9 = hs.hotkey.new({'cmd'}, "right", nil, function()
  app:selectMenuItem({"Go", "Forward"})
end, nil, nil)

-- watchApp.startAppWatcher({ appname }, { hotkey1, hotkey2, hotkey3 })

hs.window.filter.new(appname)
:subscribe(hs.window.filter.windowFocused,function()
  hotkey1:enable()
  hotkey2:enable()
  hotkey3:enable()
  hotkey4:enable()
  hotkey5:enable()
  hotkey6:enable()
  hotkey7:enable()
  hotkey8:enable()
  hotkey9:enable()
end)
:subscribe(hs.window.filter.windowUnfocused,function()
  hotkey1:disable()
  hotkey2:disable()
  hotkey3:disable()
  hotkey4:disable()
  hotkey5:disable()
  hotkey6:disable()
  hotkey7:disable()
  hotkey8:disable()
  hotkey9:disable()
end)

