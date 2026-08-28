local eventtap = require('hs.eventtap')
local timer = require('hs.timer')
local GestureTrail = require('utils/mouse-gesture-trail')

local MouseGestures = {}

MouseGestures.startDistance = 18
MouseGestures.segmentDistance = 28
MouseGestures.axisRatio = 1.4
MouseGestures.maxSegments = 4
MouseGestures.gestures = {}

local function distanceSquared(firstPoint, secondPoint)
  local xDistance = secondPoint.x - firstPoint.x
  local yDistance = secondPoint.y - firstPoint.y
  return xDistance ^ 2 + yDistance ^ 2
end

local function classifyDirection(fromPoint, toPoint, axisRatio)
  local xDistance = toPoint.x - fromPoint.x
  local yDistance = toPoint.y - fromPoint.y
  local absX = math.abs(xDistance)
  local absY = math.abs(yDistance)

  if absX > absY * axisRatio then
    if xDistance > 0 then return 'R' end
    return 'L'
  end

  if absY > absX * axisRatio then
    if yDistance > 0 then return 'D' end
    return 'U'
  end

  return nil
end

local function gestureString(segments)
  return table.concat(segments, '')
end

function MouseGestures:init()
  self.startPos = nil
  self.segmentStartPos = nil
  self.currPos = nil
  self.points = {}
  self.segments = {}
  self.isDragging = false
  self.isInvalid = false

  self.mouseDownTap = eventtap.new({ eventtap.event.types.rightMouseDown }, self:handleMouseDown())
  self.mouseDraggedTap = eventtap.new({ eventtap.event.types.rightMouseDragged }, self:handleMouseDragged())
  self.mouseUpTap = eventtap.new({ eventtap.event.types.rightMouseUp }, self:handleMouseUp())
end

function MouseGestures:configure(options)
  options = options or {}

  self.startDistance = options.startDistance or self.startDistance
  self.segmentDistance = options.segmentDistance or self.segmentDistance
  self.axisRatio = options.axisRatio or self.axisRatio
  self.maxSegments = options.maxSegments or self.maxSegments
  self.gestures = options.gestures or self.gestures
  self.trail = GestureTrail:configure(options.trail)

  return self
end

function MouseGestures:reset()
  self.startPos = nil
  self.segmentStartPos = nil
  self.currPos = nil
  self.points = {}
  self.segments = {}
  self.isDragging = false
  self.isInvalid = false
end

function MouseGestures:findGesture(gesture)
  for _, candidate in ipairs(self.gestures) do
    if candidate.gesture == gesture then
      return candidate
    end
  end

  return nil
end

function MouseGestures:performAction(rule, context)
  if rule.keyStroke ~= nil then
    eventtap.keyStroke(rule.keyStroke[1] or {}, rule.keyStroke[2])
  end

  if rule.action ~= nil then
    rule.action(context)
  end
end

function MouseGestures:sendRightClick(position)
  self.mouseDownTap:stop()
  self.mouseUpTap:stop()
  eventtap.rightClick(position, 1)
  self.mouseDownTap:start()
  self.mouseUpTap:start()
end

function MouseGestures:handleMouseDown()
  return function(event)
    self:reset()

    if #self.gestures == 0 then return false end

    self.startPos = event:location()
    self.segmentStartPos = self.startPos
    self.currPos = self.startPos
    self.points = { self.startPos }

    return true
  end
end

function MouseGestures:handleMouseDragged()
  return function(event)
    if self.startPos == nil then return false end

    local position = event:location()
    if position == nil then return true end

    self.currPos = position
    self.points[#self.points + 1] = position

    if not self.isDragging then
      if distanceSquared(self.startPos, position) < self.startDistance ^ 2 then
        return true
      end

      self.isDragging = true
      self.trail:start(self.startPos)
    end

    self.trail:addPoint(position)

    if distanceSquared(self.segmentStartPos, position) < self.segmentDistance ^ 2 then
      return true
    end

    local direction = classifyDirection(self.segmentStartPos, position, self.axisRatio)
    if direction == nil then return true end

    if self.segments[#self.segments] ~= direction then
      if #self.segments >= self.maxSegments then
        self.isInvalid = true
        return true
      end
      self.segments[#self.segments + 1] = direction
    end

    self.segmentStartPos = position
    return true
  end
end

function MouseGestures:handleMouseUp()
  return function(event)
    if self.startPos == nil then return false end

    local clickPosition = event:location()
    local gesture = gestureString(self.segments)
    local rule = nil
    if not self.isInvalid then
      rule = self:findGesture(gesture)
    end
    local context = {
      gesture = gesture,
      startPosition = self.startPos,
      endPosition = clickPosition,
      points = self.points,
    }

    self.trail:finish()
    self:reset()

    if rule ~= nil then
      timer.doAfter(0, function()
        self:performAction(rule, context)
      end)
    else
      self:sendRightClick(clickPosition)
    end

    return true
  end
end

function MouseGestures:start()
  if self.mouseDownTap == nil then
    self:init()
  end

  self.mouseDownTap:start()
  self.mouseDraggedTap:start()
  self.mouseUpTap:start()
  return self
end

function MouseGestures:stop()
  if self.trail ~= nil then self.trail:clear() end

  if self.mouseDownTap ~= nil then self.mouseDownTap:stop() end
  if self.mouseDraggedTap ~= nil then self.mouseDraggedTap:stop() end
  if self.mouseUpTap ~= nil then self.mouseUpTap:stop() end
  return self
end

function MouseGestures:isEnabled()
  return self.mouseDownTap ~= nil and self.mouseDownTap:isEnabled()
end

return MouseGestures