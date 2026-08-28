local eventtap = require('hs.eventtap')
local geometry = require('hs.geometry')
local mouse = require('hs.mouse')
local timer = require('hs.timer')
local window = require('hs.window')

local GrabScroll = {}

GrabScroll.speed = 1
GrabScroll.acceleration = 35
GrabScroll.excludedApps = {}

local buttonNumber = 2
local scrollFrequency = 0.01
local startDistance = 12
local sampleWindow = 0.12
local momentumMultiplier = 1.25
local momentumDecay = 0.94
local momentumThreshold = 0.2
local maxMomentumTicks = 320

local function eventButtonNumber(event)
  return event:getProperty(eventtap.event.properties.mouseEventButtonNumber)
end

local function getWindowUnderMouse()
  local _ = hs.application
  local mousePosition = geometry.new(mouse.absolutePosition())
  local screen = mouse.getCurrentScreen()

  return hs.fnutils.find(window.orderedWindows(), function(candidateWindow)
    return screen == candidateWindow:screen() and mousePosition:inside(candidateWindow:frame())
  end)
end

local function addSample(samples, position)
  samples[#samples + 1] = {
    position = position,
    time = timer.secondsSinceEpoch(),
  }

  local oldestAllowed = samples[#samples].time - sampleWindow
  while #samples > 2 and samples[1].time < oldestAllowed do
    table.remove(samples, 1)
  end
end

local function estimateVelocity(samples)
  if #samples < 2 then
    return { x = 0, y = 0 }
  end

  local firstSample = samples[1]
  local lastSample = samples[#samples]
  local elapsed = lastSample.time - firstSample.time

  if elapsed <= 0 then
    return { x = 0, y = 0 }
  end

  return {
    x = (lastSample.position.x - firstSample.position.x) / elapsed,
    y = (lastSample.position.y - firstSample.position.y) / elapsed,
  }
end

function GrabScroll:init()
  self.startPos = nil
  self.currPos = nil
  self.lastDragPos = nil
  self.isDragging = false
  self.samples = {}
  self.momentumTimer = nil
  self.scrollRemainder = { x = 0, y = 0 }

  self.mouseDownTap = eventtap.new({ eventtap.event.types.otherMouseDown }, self:handleMouseDown())
  self.mouseDraggedTap = eventtap.new({ eventtap.event.types.otherMouseDragged }, self:handleMouseDragged())
  self.mouseUpTap = eventtap.new({ eventtap.event.types.otherMouseUp }, self:handleMouseUp())
end

function GrabScroll:configure(options)
  options = options or {}

  self.speed = options.speed or self.speed
  self.acceleration = options.acceleration or self.acceleration
  self.excludedApps = options.excludedApps or self.excludedApps

  return self
end

function GrabScroll:isExcluded()
  local targetWindow = getWindowUnderMouse()
  if targetWindow == nil then return true end

  local app = targetWindow:application()
  local appTitle = app and app:title()
  if appTitle == nil then return true end

  return hs.fnutils.some(self.excludedApps, function(excludedApp)
    return excludedApp == appTitle
  end)
end

function GrabScroll:resetScrollRemainder()
  self.scrollRemainder = { x = 0, y = 0 }
end

function GrabScroll:stopMomentumTimer()
  if self.momentumTimer ~= nil then
    self.momentumTimer:stop()
    self.momentumTimer = nil
  end
end

function GrabScroll:wholeScrollValue(axis, value)
  local total = self.scrollRemainder[axis] + value
  local wholeValue

  if total > 0 then
    wholeValue = math.floor(total)
  else
    wholeValue = math.ceil(total)
  end

  self.scrollRemainder[axis] = total - wholeValue
  return wholeValue
end

function GrabScroll:emitScroll(xValue, yValue)
  local wholeX = self:wholeScrollValue('x', xValue)
  local wholeY = self:wholeScrollValue('y', yValue)

  if wholeX == 0 and wholeY == 0 then return end

  eventtap.scrollWheel({ wholeX, wholeY }, {}, 'pixel')
end

function GrabScroll:startDragScrolling(position)
  self.isDragging = true
  self.lastDragPos = position
  self:resetScrollRemainder()
end

function GrabScroll:startMomentum()
  local velocity = estimateVelocity(self.samples)
  local inertiaScale = self.acceleration / 35
  local momentumX = velocity.x * scrollFrequency * self.speed * momentumMultiplier * inertiaScale
  local momentumY = velocity.y * scrollFrequency * self.speed * momentumMultiplier * inertiaScale
  local ticks = 0

  if math.abs(momentumX) < momentumThreshold and math.abs(momentumY) < momentumThreshold then
    return
  end

  self:resetScrollRemainder()

  self.momentumTimer = timer.doEvery(scrollFrequency, function()
    ticks = ticks + 1
    self:emitScroll(momentumX, momentumY)

    momentumX = momentumX * momentumDecay
    momentumY = momentumY * momentumDecay

    if ticks >= maxMomentumTicks or (math.abs(momentumX) < momentumThreshold and math.abs(momentumY) < momentumThreshold) then
      self:stopMomentumTimer()
    end
  end)
end

function GrabScroll:handleMouseDown()
  return function(event)
    self.startPos = nil
    self.currPos = nil
    self.lastDragPos = nil
    self.isDragging = false
    self.samples = {}
    self:stopMomentumTimer()

    if eventButtonNumber(event) ~= buttonNumber then return false end
    if self:isExcluded() then return false end

    self.startPos = event:location()
    self.currPos = self.startPos
    self.lastDragPos = self.startPos
    addSample(self.samples, self.startPos)

    return true
  end
end

function GrabScroll:handleMouseDragged()
  return function(event)
    if eventButtonNumber(event) ~= buttonNumber or self.startPos == nil then return false end

    local position = event:location()
    if position == nil then return true end

    self.currPos = position
    addSample(self.samples, position)

    if self.isDragging then
      self:emitScroll(
        (position.x - self.lastDragPos.x) * self.speed,
        (position.y - self.lastDragPos.y) * self.speed
      )
      self.lastDragPos = position
      return true
    end

    local xDistance = position.x - self.startPos.x
    local yDistance = position.y - self.startPos.y
    if xDistance ^ 2 + yDistance ^ 2 > startDistance ^ 2 then
      self:startDragScrolling(position)
    end

    return true
  end
end

function GrabScroll:sendMiddleClick(position)
  self.mouseDownTap:stop()
  self.mouseUpTap:stop()
  eventtap.middleClick(position, 1)
  self.mouseDownTap:start()
  self.mouseUpTap:start()
end

function GrabScroll:handleMouseUp()
  return function(event)
    if eventButtonNumber(event) ~= buttonNumber or self.startPos == nil then return false end

    local clickPosition = event:location()
    local shouldSendMiddleClick = not self.isDragging

    if self.isDragging then
      if clickPosition ~= nil then
        addSample(self.samples, clickPosition)
      end

      self:startMomentum()
    end

    self.startPos = nil
    self.currPos = nil
    self.lastDragPos = nil
    self.isDragging = false

    if shouldSendMiddleClick then
      self:sendMiddleClick(clickPosition)
    end

    return true
  end
end

function GrabScroll:start()
  if self.mouseDownTap == nil then
    self:init()
  end

  self.mouseDownTap:start()
  self.mouseDraggedTap:start()
  self.mouseUpTap:start()
  return self
end

function GrabScroll:stop()
  self:stopMomentumTimer()

  if self.mouseDownTap ~= nil then self.mouseDownTap:stop() end
  if self.mouseDraggedTap ~= nil then self.mouseDraggedTap:stop() end
  if self.mouseUpTap ~= nil then self.mouseUpTap:stop() end
  return self
end

function GrabScroll:isEnabled()
  return self.mouseDownTap ~= nil and self.mouseDownTap:isEnabled()
end

return GrabScroll