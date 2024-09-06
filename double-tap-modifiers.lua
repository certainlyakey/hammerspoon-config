local doubleTapWatcher = require('utils/double-tap')
local centerMouse = require('utils/center-mouse')

-- Shortcut: Open Spotlight by pressing left shift twice
local openSpotlight = doubleTapWatcher.doubleTapWatcher('shift', {'fn', 'cmd', 'alt', 'shift', 'ctrl'}, 'f1', 131330, false)

-- Shortcut: Center mouse at current window by pressing left cmd twice
local centerMouseAtWindow = doubleTapWatcher.doubleTapWatcher('cmd', {}, '', 1048840, function()
  centerMouse()
end)

-- Shortcut: Reveal Desktop by pressing right alt twice
-- This is a Sonoma-specific command
local revealDesktop = doubleTapWatcher.doubleTapWatcher('alt', {}, '', 524608, function()
  hs.execute('open -a /System/Applications/Mission\\ Control.app/Contents/MacOS/Mission\\ Control  --args 1')
end)
