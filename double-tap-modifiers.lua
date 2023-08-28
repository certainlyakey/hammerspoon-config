local doubleTapWatcher = require("utils/double-tap")

-- Shortcut: Open Spotlight by pressing shift twice
local openSpotlight = doubleTapWatcher.doubleTapWatcher('shift', {"fn", "cmd", "alt", "shift", "ctrl"}, 'f1')

-- Shortcut: Reveal Desktop by pressing alt twice
-- local revealDesktop = doubleTapWatcher.doubleTapWatcher('cmd', {"fn", "ctrl", "cmd", "shift"}, 'f12')
