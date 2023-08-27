hs.window.animationDuration = 0.2

-- Shortcut: Maximise
hs.hotkey.bind({"alt"}, "f", function()
  hs.window.focusedWindow():maximize()
end)

-- Shortcut: Close window (doesn't work for Fork or Finder, only closes a tab)
hs.hotkey.bind({"ctrl", "cmd"}, "w", function()
  hs.window.frontmostWindow():close()
end)

-- Shortcut: Move to next monitor
hs.hotkey.bind({"shift", "ctrl", "cmd"}, "down", function()
  local window = hs.window.focusedWindow()
  window:moveToScreen(window:screen():next())
end)

-- Shortcut: Move to next monitor and center
hs.hotkey.bind({"shift", "ctrl", "cmd"}, "up", function()
  local window = hs.window.focusedWindow()
  window:moveToScreen(window:screen():next())
  window:centerOnScreen()
end)

-- Shortcut: Maximise height
hs.hotkey.bind({"alt"}, "z", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.y = 0
  f.h = max.h
  win:setFrame(f)
end)

-- Shortcut: Center
hs.hotkey.bind({"alt"}, ".", function()
  hs.window.focusedWindow():centerOnScreen()
end)

-- Shortcut: Align left
hs.hotkey.bind({"alt"}, ",", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = 0
  win:setFrame(f)
end)

-- Shortcut: Align right
hs.hotkey.bind({"alt"}, "/", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.w - f.w
  -- f.y = 0
  -- f.w = max.w
  -- f.h = max.h
  win:setFrame(f)
end)

-- TODO:
-- Grow and shrink from left/right (should perhaps automatically understand which side of screen a window is attached to, and grow from the other side)
--
