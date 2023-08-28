local eventtap = require("hs.eventtap")
local timer = require("hs.timer")

local util = {}

function util.doubleTapWatcher(key, mods, keystroke, callback)
  local module = {}

  local events = eventtap.event.types

  module.timeFrame = 1

  module.action = function()
    if callback then
      callback()
    else
      hs.eventtap.keyStroke(mods, keystroke)
    end
  end

  local timeFirstPress, firstDown, secondDown = 0, false, false

  local noFlags = function(ev)
    local result = true
    for k, v in pairs(ev:getFlags()) do
      if v then
        result = false
        break
      end
    end
    return result
  end

  local onlyKey = function(ev)
    local result = ev:getFlags()[key]
    for k,v in pairs(ev:getFlags()) do
      if k~=key and v then
        result = false
        break
      end
    end
    return result
  end

  module.eventWatcher = eventtap.new({events.flagsChanged, events.keyDown}, function(ev)
    if (timer.secondsSinceEpoch() - timeFirstPress) > module.timeFrame then
      timeFirstPress, firstDown, secondDown = 0, false, false
    end

    if ev:getType() == events.flagsChanged then
      if noFlags(ev) and firstDown and secondDown then
        if module.action then module.action() end
        timeFirstPress, firstDown, secondDown = 0, false, false
      elseif onlyKey(ev) and not firstDown then
        firstDown = true
        timeFirstPress = timer.secondsSinceEpoch()
      elseif onlyKey(ev) and firstDown then
        secondDown = true
      elseif not noFlags(ev) then
        timeFirstPress, firstDown, secondDown = 0, false, false
      end
    else
      timeFirstPress, firstDown, secondDown = 0, false, false
    end
    return false
  end):start()

  return module
end

return util
