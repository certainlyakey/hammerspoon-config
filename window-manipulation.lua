local growShrink = require('utils/grow-shrink')
local windowsSpaces = require('utils/windows-spaces')

-- Shortcut: Maximise and restore
-- from: https://github.com/Hammerspoon/hammerspoon/issues/181#issuecomment-69685928
hs.hotkey.bind({'alt'}, 'f', function()
  local win = hs.window.focusedWindow()
    local frame = win:frame()
    local id = win:id()
  
    -- init table to save window state
    savedwin = savedwin or {}
    savedwin[id] = savedwin[id] or {}
  
    if (savedwin[id].maximized == nil or savedwin[id].maximized == false) then
      savedwin[id].frame = frame
      savedwin[id].maximized = true
      win:maximize()
    else
      savedwin[id].maximized = false
      win:setFrame(savedwin[id].frame)
    end
end)

-- Shortcut: Close window (doesn't work for Fork or Finder, only closes a tab)
hs.hotkey.bind({'ctrl', 'cmd'}, 'w', function()
  hs.window.frontmostWindow():close()
end)

-- Shortcut: Move to previous monitor
hs.hotkey.bind({'shift', 'ctrl', 'cmd'}, 'up', function()
  local window = hs.window.focusedWindow()
  window:moveToScreen(window:screen():previous())
end)

-- Shortcut: Move to next monitor
hs.hotkey.bind({'shift', 'ctrl', 'cmd'}, 'down', function()
  local window = hs.window.focusedWindow()
  window:moveToScreen(window:screen():next())
  -- window:centerOnScreen()
end)

-- Shortcut: Maximise height
hs.hotkey.bind({'alt'}, 'z', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.y = 0
  f.h = max.h
  win:setFrame(f)
end)

-- Shortcut: Center
hs.hotkey.bind({'alt'}, '.', function()
  hs.window.focusedWindow():centerOnScreen()
end)

-- Shortcut: Align left
hs.hotkey.bind({'alt'}, ',', function()
  local win = hs.window.focusedWindow()
  local screenFrame = win:screen():frame()
  local winFrame = win:frame()

  winFrame.x = screenFrame.x

  win:setFrame(winFrame)
end)

-- Shortcut: Align right
hs.hotkey.bind({'alt'}, '/', function()
  local win = hs.window.focusedWindow()
  local screenFrame = win:screen():frame()
  local winFrame = win:frame()

  winFrame.x = screenFrame.x + screenFrame.w - winFrame.w

  win:setFrame(winFrame)
end)

-- Shortcut: Grow and shrink to left
hs.hotkey.bind({'alt', 'shift'}, ',', growShrink('left'))

-- Shortcut: Grow and shrink to right
hs.hotkey.bind({'alt', 'shift'}, '/', growShrink('right'))

-- Shortcut: Move to left space
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'left', function()
  windowsSpaces.moveToDesktopToLeft()
end)

-- Shortcut: Move to right space
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'right', function()
  windowsSpaces.moveToDesktopToRight()
end)
