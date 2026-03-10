local focusOrNext = require('utils/focus-or-next-window')
local openApp = require('utils/open-app')
local drawWindowBorder = require('utils/draw-window-border')

hs.hotkey.bind({}, 'f6', openApp('Music', nil, true))
-- Do not Disturb key remapped via hidutil to f14, see https://gist.github.com/zats/16a301a1705d69be40accc596e4b63c9
hs.hotkey.bind({}, 'f14', openApp('Music', nil, true))
hs.hotkey.bind({'alt', 'cmd'}, 's', openApp('Safari', 'Vivaldi'))
hs.hotkey.bind({'alt', 'cmd'}, 'c', function()
  focusOrNext('Visual Studio Code')
end)
hs.hotkey.bind({'alt', 'cmd'}, 'z', openApp('Figma'))
hs.hotkey.bind({'alt', 'cmd'}, 'g', function()
  focusOrNext('Finder')
  drawWindowBorder.drawBorder()
end, function()
  drawWindowBorder.deleteBorder()
end)
hs.hotkey.bind({'alt', 'cmd'}, 'm', function()
  focusOrNext('Mail')
end)
hs.hotkey.bind({'alt', 'cmd'}, 'n', openApp('Notes'))
hs.hotkey.bind({'shift', 'alt', 'cmd'}, 'c', openApp('Calendar'))
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 'f', openApp('Fork'))
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 't', openApp('Transmit'))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'c', openApp('Google Chrome'))
hs.hotkey.bind({'alt', 'cmd'}, 'e', openApp('Microsoft Teams', nil, true))
hs.hotkey.bind({'alt', 'cmd'}, 't', openApp('iTerm'))
hs.hotkey.bind({'alt', 'cmd', 'shift'}, ',', function()
  local url = 'x-apple.systempreferences:com.apple.Keyboard-Settings.extension'

  local scheme = url:match('^([^:]+)')
  local handler = hs.urlevent.getDefaultHandler(scheme)
  -- or skip both of those and just do:
  -- local handler = 'com.apple.systempreferences'

  hs.urlevent.openURLWithBundle(url, handler)
end)
