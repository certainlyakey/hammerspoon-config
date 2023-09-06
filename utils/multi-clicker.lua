-- from https://github.com/msolomon/griddle/blob/3dac49f9be743036e1299f83704b3f7b19ca6a49/Griddle.spoon/multiclicker.lua
local function Stack(list)
  local self = {stack = list or {}}

  function self.push(item)
    self.stack[#self.stack + 1] = item
  end

  function self.pop()
    if #self.stack > 0 then
      return table.remove(self.stack, #self.stack)
    end
  end

  function self.peek()
    return self.stack[#self.stack]
  end

  function self.size()
    return #self.stack
  end

  return self
end

return function(button)
  local self = {
    clicks = 0,
    clicked = Stack(),
  }
  local clickState = hs.eventtap.event.properties.mouseEventClickState
  local buttonDown = hs.eventtap.event.types[button .. 'Down'] -- e.g. leftMouseDown
  local buttonUp = hs.eventtap.event.types[button .. 'Up'] -- e.g. leftMouseUp
  local dragged = hs.eventtap.event.types[button .. 'Dragged'] -- e.g. leftMouseDragged
  local countResetter = hs.timer.delayed.new(
    hs.eventtap.doubleClickInterval(),
    function()
      if self.clicked.size() == 0 then self.clicks = 0 end
    end
  )

  function clickAt(event, clicks, point)
    hs.eventtap.event.newMouseEvent(event, point):setProperty(clickState, clicks):post()
  end

  function self.clickDown()
    local point = hs.mouse.absolutePosition()
    local numClicks = self.clicks + 1
    self.clicks = numClicks
    self.clicked.push({
      point = point,
      numClicks = numClicks,
    })
    clickAt(buttonDown, numClicks, point)
  end

  function self.clickUp()
    countResetter:start()
    local click = self.clicked.pop()
    if click then
      local point = hs.mouse.absolutePosition()
      if click.point.x ~= point.x or click.point.y ~= point.y then
        clickAt(dragged, click.numClicks, point)
      end
      clickAt(buttonUp, click.numClicks, point)
    end
  end

  function self.dragged(point)
    if self.clicked.size() > 0 then
      point = point or hs.mouse.absolutePosition()
      clickAt(dragged, self.clicks, point)
    end
  end

  return self
end
