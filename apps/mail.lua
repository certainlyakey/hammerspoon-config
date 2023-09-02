local appname = 'Mail'

-- Shortcut: Open file URL from clipboard
local hotkey1 = hs.hotkey.new({'cmd'}, 'return', nil, function()
  local app = hs.appfinder.appFromName(appname)
  app:selectMenuItem({'Message', 'Send'})
end, nil, nil)

local wf = hs.window.filter.new(appname)
wf:subscribe(hs.window.filter.windowFocused,function()
  hotkey1:enable()
end)
:subscribe(hs.window.filter.windowUnfocused,function()
  hotkey1:disable()
end)
