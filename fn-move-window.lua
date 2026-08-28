local eventtap = require('hs.eventtap')
local geometry = require('hs.geometry')
local mouse = require('hs.mouse')
local window = require('hs.window')

local FnMoveWindow = {}

FnMoveWindow.excludedAppBundleIDs = {}
FnMoveWindow.strictModifiers = true

local function onlyFn(flags)
  return flags.fn == true
    and not flags.cmd
    and not flags.alt
    and not flags.shift
    and not flags.ctrl
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

function FnMoveWindow:init()
  self.targetWindow = nil
  self.startMouse = nil
  self.startFrame = nil

  self.flagsTap = eventtap.new({ eventtap.event.types.flagsChanged }, self:handleFlagsChanged())
  self.mouseMovedTap = eventtap.new({ eventtap.event.types.mouseMoved }, self:handleMouseMoved())
end

function FnMoveWindow:configure(options)
  options = options or {}

  self.excludedAppBundleIDs = options.excludedAppBundleIDs or self.excludedAppBundleIDs
  if options.strictModifiers ~= nil then
    self.strictModifiers = options.strictModifiers
  end

  return self
end

function FnMoveWindow:reset()
  self.targetWindow = nil
  self.startMouse = nil
  self.startFrame = nil
end

function FnMoveWindow:hasMoveModifier(flags)
  if self.strictModifiers then
    return onlyFn(flags)
  end

  return flags.fn == true
end

function FnMoveWindow:isExcluded(targetWindow)
  if targetWindow == nil then return true end

  local app = targetWindow:application()
  local appBundleID = app and app:bundleID()
  if appBundleID == nil then return true end

  return isExcludedAppBundleID(appBundleID, self.excludedAppBundleIDs)
end

function FnMoveWindow:startMoving(position)
  local targetWindow = getWindowUnderMouse(position)
  if self:isExcluded(targetWindow) then return false end

  self.targetWindow = targetWindow
  self.startMouse = position
  self.startFrame = targetWindow:frame()

  return true
end

function FnMoveWindow:moveTo(position)
  if self.targetWindow == nil or self.startMouse == nil or self.startFrame == nil then return false end

  self.targetWindow:setTopLeft({
    x = self.startFrame.x + position.x - self.startMouse.x,
    y = self.startFrame.y + position.y - self.startMouse.y,
  })

  return true
end

function FnMoveWindow:handleFlagsChanged()
  return function(event)
    if not self:hasMoveModifier(event:getFlags()) then
      self:reset()
    end

    return false
  end
end

function FnMoveWindow:handleMouseMoved()
  return function(event)
    if not self:hasMoveModifier(event:getFlags()) then
      self:reset()
      return false
    end

    local position = event:location()
    if position == nil then return false end

    if self.targetWindow == nil and not self:startMoving(position) then
      return false
    end

    self:moveTo(position)
    return true
  end
end

function FnMoveWindow:start()
  if self.flagsTap == nil then
    self:init()
  end

  self.flagsTap:start()
  self.mouseMovedTap:start()
  return self
end

function FnMoveWindow:stop()
  self:reset()

  if self.flagsTap ~= nil then self.flagsTap:stop() end
  if self.mouseMovedTap ~= nil then self.mouseMovedTap:stop() end
  return self
end

function FnMoveWindow:isEnabled()
  return self.mouseMovedTap ~= nil and self.mouseMovedTap:isEnabled()
end

return FnMoveWindow
