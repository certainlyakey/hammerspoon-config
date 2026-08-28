local canvas = require('hs.canvas')
local mouse = require('hs.mouse')

local GestureTrail = {}

GestureTrail.enabled = true
GestureTrail.minPointDistance = 6
GestureTrail.strokeWidth = 4
GestureTrail.strokeColor = { red = 0.1, green = 0.45, blue = 1, alpha = 0.8 }
GestureTrail.fadeSeconds = 0.35

local function distanceSquared(firstPoint, secondPoint)
  local xDistance = secondPoint.x - firstPoint.x
  local yDistance = secondPoint.y - firstPoint.y
  return xDistance ^ 2 + yDistance ^ 2
end

local function toCanvasPoint(frame, point)
  return {
    x = point.x - frame.x,
    y = point.y - frame.y,
  }
end

function GestureTrail:configure(options)
  options = options or {}

  self.enabled = options.enabled ~= false
  self.minPointDistance = options.minPointDistance or self.minPointDistance
  self.strokeWidth = options.strokeWidth or self.strokeWidth
  self.strokeColor = options.strokeColor or self.strokeColor
  self.fadeSeconds = options.fadeSeconds or self.fadeSeconds

  return self
end

function GestureTrail:clear()
  if self.canvas ~= nil then
    self.canvas:delete()
  end

  self.canvas = nil
  self.frame = nil
  self.points = {}
  self.lastPoint = nil
end

function GestureTrail:start(point)
  if not self.enabled then return end

  self:clear()
  self.frame = mouse.getCurrentScreen():fullFrame()
  self.points = { toCanvasPoint(self.frame, point) }
  self.lastPoint = point

  self.canvas = canvas.new(self.frame)
  self.canvas:level(canvas.windowLevels.floating)
  self.canvas[1] = {
    type = 'segments',
    action = 'stroke',
    closed = false,
    coordinates = self.points,
    strokeColor = self.strokeColor,
    strokeWidth = self.strokeWidth,
  }
  self.canvas:show()
end

function GestureTrail:addPoint(point)
  if not self.enabled or self.canvas == nil or self.lastPoint == nil or point == nil then return end
  if distanceSquared(self.lastPoint, point) < self.minPointDistance ^ 2 then return end

  self.points[#self.points + 1] = toCanvasPoint(self.frame, point)
  self.canvas[1].coordinates = self.points
  self.lastPoint = point
end

function GestureTrail:finish()
  if not self.enabled or self.canvas == nil then return end

  local currentCanvas = self.canvas
  self.canvas = nil
  self.frame = nil
  self.points = {}
  self.lastPoint = nil

  if self.fadeSeconds > 0 then
    currentCanvas:delete(self.fadeSeconds)
  else
    currentCanvas:delete()
  end
end

return GestureTrail