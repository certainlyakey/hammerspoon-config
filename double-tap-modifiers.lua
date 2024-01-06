local doubleTapWatcher = require('utils/double-tap')
local centerMouse = require('utils/center-mouse')

-- Shortcut: Open Spotlight by pressing shift twice
local openSpotlight = doubleTapWatcher.doubleTapWatcher('shift', {'fn', 'cmd', 'alt', 'shift', 'ctrl'}, 'f1', 131330, false)

-- Shortcut: Center mouse at current window by pressing cmd twice
local centerMouseAtWindow = doubleTapWatcher.doubleTapWatcher('cmd', {}, '', 1048840, function()
  centerMouse()
end)

-- Shortcut: Reveal Desktop by pressing alt twice
local revealDesktop = doubleTapWatcher.doubleTapWatcher('alt', {}, '', 524608, function()
  hs.execute('/System/Applications/Mission\\ Control.app/Contents/MacOS/Mission\\ Control 1')
end)
