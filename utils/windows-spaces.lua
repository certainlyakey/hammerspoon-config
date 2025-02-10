-- From https://github.com/Hammerspoon/hammerspoon/issues/3698#issuecomment-2562188364
local util = {}
util.__index = util
util.hs = hs

-- Module state
util.isMoving = false

-- Constants
local MOUSE_OFFSET_X = 5
local MOUSE_OFFSET_Y = 12
local SWITCH_DELAY = 0.2
local RELEASE_DELAY = 0.5

local function simulateKeyEvent(modifier1, modifier2, key)
  util.hs.eventtap.event.newKeyEvent(modifier1, true):post()
  util.hs.eventtap.event.newKeyEvent(modifier2, true):post()
  util.hs.eventtap.event.newKeyEvent(key, true):post()
  util.hs.timer.doAfter(0.1, function()
    util.hs.eventtap.event.newKeyEvent(modifier1, false):post()
    util.hs.eventtap.event.newKeyEvent(modifier2, false):post()
    util.hs.eventtap.event.newKeyEvent(key, false):post()
  end)
end

function util:moveToDesktopToRight()
  if self.isMoving then return end
  self.isMoving = true

  -- Get current active window and make it frontmost
  local win = self.hs.window.focusedWindow()
  if not win then
    self.isMoving = false
    return
  end
  win:unminimize()
  win:raise()

  -- Check if we're on the rightmost desktop
  local spaces = self.hs.spaces.spacesForScreen()
  local currentSpace = self.hs.spaces.focusedSpace()

  if currentSpace == spaces[#spaces] then
    self.hs.alert.show("Already at the rightmost desktop.")
    self.isMoving = false
    return
  end

  -- Get window frame and calculate positions
  local frame = win:frame()
  local clickPos = self.hs.geometry.point(frame.x + MOUSE_OFFSET_X, frame.y + MOUSE_OFFSET_Y)
  local centerPos = self.hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)

  -- Move mouse to click position
  self.hs.mouse.absolutePosition(clickPos)

  -- Simulate mouse press and desktop switch
  self.hs.eventtap.event.newMouseEvent(self.hs.eventtap.event.types.leftMouseDown, clickPos):post()

  self.hs.timer.doAfter(SWITCH_DELAY, function()
    simulateKeyEvent("alt", "cmd", "right")
  end)

  -- Release mouse and restore position
  self.hs.timer.doAfter(RELEASE_DELAY, function()
    self.hs.eventtap.event.newMouseEvent(self.hs.eventtap.event.types.leftMouseUp, clickPos):post()
    self.hs.mouse.absolutePosition(centerPos)
    win:raise()
    win:focus()
    self.isMoving = false
  end)
end

function util:moveToDesktopToLeft()
  if self.isMoving then return end
  self.isMoving = true

  -- Check if we're on the leftmost desktop
  local spaces = self.hs.spaces.spacesForScreen()
  local currentSpace = self.hs.spaces.focusedSpace()

  if currentSpace == spaces[1] then
    self.hs.alert.show("Already at the leftmost desktop.")
    self.isMoving = false
    return
  end

  -- Get current active window and make it frontmost
  local win = self.hs.window.focusedWindow()
  if not win then
    self.isMoving = false
    return
  end
  win:unminimize()
  win:raise()

  -- Get window frame and calculate positions
  local frame = win:frame()
  local clickPos = self.hs.geometry.point(frame.x + MOUSE_OFFSET_X, frame.y + MOUSE_OFFSET_Y)
  local centerPos = self.hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)

  -- Move mouse to click position
  self.hs.mouse.absolutePosition(clickPos)

  -- Simulate mouse press and desktop switch
  self.hs.eventtap.event.newMouseEvent(self.hs.eventtap.event.types.leftMouseDown, clickPos):post()

  self.hs.timer.doAfter(SWITCH_DELAY, function()
    simulateKeyEvent("alt", "cmd", "left")
  end)

  -- Release mouse and restore position
  self.hs.timer.doAfter(RELEASE_DELAY, function()
    self.hs.eventtap.event.newMouseEvent(self.hs.eventtap.event.types.leftMouseUp, clickPos):post()
    self.hs.mouse.absolutePosition(centerPos)
    win:raise()
    win:focus()
    self.isMoving = false
  end)
end

return util
