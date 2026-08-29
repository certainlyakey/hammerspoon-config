local eventtap = require('hs.eventtap')
local geometry = require('hs.geometry')
local mouse = require('hs.mouse')
local timer = require('hs.timer')
local window = require('hs.window')

local FnWindowManipulation = {}

FnWindowManipulation.excludedAppBundleIDs = {}
FnWindowManipulation.minWidth = 120
FnWindowManipulation.minHeight = 80
FnWindowManipulation.resizeFrequency = 1 / 60
FnWindowManipulation.strictModifiers = true

local rawFlagMasks = eventtap.event.rawFlagMasks

local function hasRawFlag(event, flag)
  local mask = rawFlagMasks[flag]
  return mask ~= nil and (event:rawFlags() & mask) ~= 0
end

local function hasLeftShift(event)
  return hasRawFlag(event, 'deviceLeftShift')
end

local function hasRightShift(event)
  return hasRawFlag(event, 'deviceRightShift')
end

local function modeForEvent(event, strictModifiers)
  local flags = event:getFlags()

  if flags.fn ~= true then return nil end

  if not strictModifiers then
    if flags.ctrl then return 'resize' end
    return 'move'
  end

  if flags.cmd or flags.alt or hasRightShift(event) then return nil end

  if flags.ctrl then
    if flags.shift then return nil end
    return 'resize'
  end

  if flags.shift and not hasLeftShift(event) then return nil end
  return 'move'
end

local function dominantAxis(deltaX, deltaY)
  if math.abs(deltaX) >= math.abs(deltaY) then
    return 'horizontal'
  end

  return 'vertical'
end

local function constrainDelta(deltaX, deltaY, axis)
  if axis == nil then
    return deltaX, deltaY
  end

  if axis == 'horizontal' then
    return deltaX, 0
  end

  return 0, deltaY
end

local function distanceSquared(firstPoint, secondPoint)
  local xDistance = secondPoint.x - firstPoint.x
  local yDistance = secondPoint.y - firstPoint.y
  return xDistance ^ 2 + yDistance ^ 2
end

local function closestCorner(position, frame)
  local corners = {
    { name = 'topLeft', point = { x = frame.x, y = frame.y } },
    { name = 'topRight', point = { x = frame.x + frame.w, y = frame.y } },
    { name = 'bottomLeft', point = { x = frame.x, y = frame.y + frame.h } },
    { name = 'bottomRight', point = { x = frame.x + frame.w, y = frame.y + frame.h } },
  }
  local nearestCorner = corners[1]
  local nearestDistance = distanceSquared(position, nearestCorner.point)

  for index = 2, #corners do
    local corner = corners[index]
    local currentDistance = distanceSquared(position, corner.point)
    if currentDistance < nearestDistance then
      nearestCorner = corner
      nearestDistance = currentDistance
    end
  end

  return nearestCorner.name
end

local function isExcludedAppBundleID(appBundleID, excludedAppBundleIDs)
  return hs.fnutils.some(excludedAppBundleIDs, function(excludedAppBundleID)
    return excludedAppBundleID == appBundleID
  end)
end

local function getWindowUnderMouse(position)
  local _ = hs.application
  local mousePosition = geometry.new(position or mouse.absolutePosition())
  local screen = mouse.getCurrentScreen()

  return hs.fnutils.find(window.orderedWindows(), function(candidateWindow)
    if not candidateWindow:isStandard() or screen ~= candidateWindow:screen() then
      return false
    end

    local frame = candidateWindow:frame()
    return frame ~= nil and mousePosition:inside(frame)
  end)
end

local function isNearlyEqual(firstValue, secondValue)
  return math.abs(firstValue - secondValue) <= 1
end

local function isFullyExpandedWindow(targetWindow)
  local frame = targetWindow:frame()
  local screenFrame = targetWindow:screen():frame()

  return isNearlyEqual(frame.x, screenFrame.x)
    and isNearlyEqual(frame.y, screenFrame.y)
    and isNearlyEqual(frame.w, screenFrame.w)
    and isNearlyEqual(frame.h, screenFrame.h)
end

local function targetWindowForMode(position, mode)
  if mode == 'resize' then
    local focusedWindow = window.focusedWindow()
    if focusedWindow == nil or not focusedWindow:isStandard() then return nil end
    return focusedWindow
  end

  local targetWindow = getWindowUnderMouse(position)
  if targetWindow == nil or isFullyExpandedWindow(targetWindow) then return nil end
  return targetWindow
end

function FnWindowManipulation:init()
  self.targetWindow = nil
  self.startMouse = nil
  self.startFrame = nil
  self.mode = nil
  self.constraintAxis = nil
  self.resizeCorner = nil
  self.pendingResizePosition = nil
  self.resizeTimer = nil

  self.flagsTap = eventtap.new({ eventtap.event.types.flagsChanged }, self:handleFlagsChanged())
  self.mouseMovedTap = eventtap.new({ eventtap.event.types.mouseMoved }, self:handleMouseMoved())
end

function FnWindowManipulation:configure(options)
  options = options or {}

  self.excludedAppBundleIDs = options.excludedAppBundleIDs or self.excludedAppBundleIDs
  self.minWidth = options.minWidth or self.minWidth
  self.minHeight = options.minHeight or self.minHeight
  self.resizeFrequency = options.resizeFrequency or self.resizeFrequency
  if options.strictModifiers ~= nil then
    self.strictModifiers = options.strictModifiers
  end

  return self
end

function FnWindowManipulation:reset()
  self:flushResize()
  self:stopResizeTimer()

  self.targetWindow = nil
  self.startMouse = nil
  self.startFrame = nil
  self.mode = nil
  self.constraintAxis = nil
  self.resizeCorner = nil
  self.pendingResizePosition = nil
end

function FnWindowManipulation:modeForEvent(event)
  return modeForEvent(event, self.strictModifiers)
end

function FnWindowManipulation:isExcluded(targetWindow)
  if targetWindow == nil then return true end

  local app = targetWindow:application()
  local appBundleID = app and app:bundleID()
  if appBundleID == nil then return true end

  return isExcludedAppBundleID(appBundleID, self.excludedAppBundleIDs)
end

function FnWindowManipulation:startGesture(position, mode)
  local targetWindow = targetWindowForMode(position, mode)
  if targetWindow == nil or self:isExcluded(targetWindow) then return false end

  self.targetWindow = targetWindow
  self.startMouse = position
  self.startFrame = targetWindow:frame()
  self.mode = mode

  if mode == 'resize' then
    self.resizeCorner = closestCorner(position, self.startFrame)
  end

  return true
end

function FnWindowManipulation:moveTo(position, event)
  if self.targetWindow == nil or self.startMouse == nil or self.startFrame == nil then return false end

  local deltaX = position.x - self.startMouse.x
  local deltaY = position.y - self.startMouse.y

  if hasLeftShift(event) then
    self.constraintAxis = self.constraintAxis or dominantAxis(deltaX, deltaY)
  else
    self.constraintAxis = nil
  end

  deltaX, deltaY = constrainDelta(deltaX, deltaY, self.constraintAxis)

  self.targetWindow:setFrame({
    x = self.startFrame.x + deltaX,
    y = self.startFrame.y + deltaY,
    w = self.startFrame.w,
    h = self.startFrame.h,
  }, 0)

  return true
end

function FnWindowManipulation:resizeTo(position)
  if self.targetWindow == nil or self.startMouse == nil or self.startFrame == nil or self.resizeCorner == nil then return false end

  local startFrame = self.startFrame
  local right = startFrame.x + startFrame.w
  local bottom = startFrame.y + startFrame.h
  local deltaX = position.x - self.startMouse.x
  local deltaY = position.y - self.startMouse.y
  local frame = {
    x = startFrame.x,
    y = startFrame.y,
    w = startFrame.w,
    h = startFrame.h,
  }

  if self.resizeCorner == 'topLeft' then
    frame.x = math.min(startFrame.x + deltaX, right - self.minWidth)
    frame.y = math.min(startFrame.y + deltaY, bottom - self.minHeight)
    frame.w = right - frame.x
    frame.h = bottom - frame.y
  elseif self.resizeCorner == 'topRight' then
    frame.x = startFrame.x
    frame.y = math.min(startFrame.y + deltaY, bottom - self.minHeight)
    frame.w = math.max(right + deltaX, startFrame.x + self.minWidth) - startFrame.x
    frame.h = bottom - frame.y
  elseif self.resizeCorner == 'bottomLeft' then
    frame.x = math.min(startFrame.x + deltaX, right - self.minWidth)
    frame.y = startFrame.y
    frame.w = right - frame.x
    frame.h = math.max(bottom + deltaY, startFrame.y + self.minHeight) - startFrame.y
  else
    frame.x = startFrame.x
    frame.y = startFrame.y
    frame.w = math.max(right + deltaX, startFrame.x + self.minWidth) - startFrame.x
    frame.h = math.max(bottom + deltaY, startFrame.y + self.minHeight) - startFrame.y
  end

  self.targetWindow:setFrame(frame, 0)
  return true
end

function FnWindowManipulation:startResizeTimer()
  if self.resizeTimer ~= nil then return end

  self.resizeTimer = timer.doEvery(self.resizeFrequency, function()
    self:flushResize()
  end)
end

function FnWindowManipulation:stopResizeTimer()
  if self.resizeTimer == nil then return end

  self.resizeTimer:stop()
  self.resizeTimer = nil
end

function FnWindowManipulation:queueResize(position)
  self.pendingResizePosition = position
  self:startResizeTimer()
end

function FnWindowManipulation:flushResize()
  if self.pendingResizePosition == nil then return false end

  local position = self.pendingResizePosition
  self.pendingResizePosition = nil
  return self:resizeTo(position)
end

function FnWindowManipulation:handleFlagsChanged()
  return function(event)
    local mode = self:modeForEvent(event)

    if mode == nil or (self.mode ~= nil and mode ~= self.mode) then
      self:reset()
    elseif mode == 'move' and not hasLeftShift(event) then
      self.constraintAxis = nil
    end

    return false
  end
end

function FnWindowManipulation:handleMouseMoved()
  return function(event)
    local mode = self:modeForEvent(event)
    if mode == nil then
      self:reset()
      return false
    end

    if self.mode ~= nil and mode ~= self.mode then
      self:reset()
      return false
    end

    local position = event:location()
    if position == nil then return false end

    if self.targetWindow == nil and not self:startGesture(position, mode) then
      return false
    end

    if self.mode == 'resize' then
      self:queueResize(position)
    else
      self:moveTo(position, event)
    end

    return true
  end
end

function FnWindowManipulation:start()
  if self.flagsTap == nil then
    self:init()
  end

  self.flagsTap:start()
  self.mouseMovedTap:start()
  return self
end

function FnWindowManipulation:stop()
  self:reset()

  if self.flagsTap ~= nil then self.flagsTap:stop() end
  if self.mouseMovedTap ~= nil then self.mouseMovedTap:stop() end
  return self
end

function FnWindowManipulation:isEnabled()
  return self.mouseMovedTap ~= nil and self.mouseMovedTap:isEnabled()
end

return FnWindowManipulation