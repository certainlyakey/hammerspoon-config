local doubleTapWatcher = require("utils/double-tap")

-- Shortcut: Open Spotlight by pressing shift twice
local openSpotlight = doubleTapWatcher.doubleTapWatcher('shift', {"fn", "cmd", "alt", "shift", "ctrl"}, 'f1', false)

-- Shortcut: Reveal Desktop by pressing alt twice
local revealDesktop = doubleTapWatcher.doubleTapWatcher('alt', {"fn", "ctrl", "cmd", "shift"}, 'f12', function()
  hs.execute('/System/Applications/Mission\\ Control.app/Contents/MacOS/Mission\\ Control 1')
end)
