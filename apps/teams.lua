local appname = 'Microsoft Teams'

-- Shortcut: Focus editing field
local hotkey1 = hs.hotkey.new({'shift', 'cmd'}, "c", nil, function()
  local app = hs.appfinder.appFromName(appname)
  hs.eventtap.event.newKeyEvent({ "shift", "alt" }, "c", true):post(app)
end, nil, nil)

local wf = hs.window.filter.new(appname)
wf:subscribe(hs.window.filter.windowFocused,function()
  hotkey1:enable()
end)
:subscribe(hs.window.filter.windowUnfocused,function()
  hotkey1:disable()
end)
