local timer = require('hs.timer')

-- in nanoseconds
local min_delay = 300000000

-- https://github.com/jasonrudolph/keyboard/blob/e5e351f1cc80f62cca2ce688a5d4a3dd7f3a4b36/hammerspoon/control-escape.lua
len = function(t)
  local length = 0
  for _, __ in pairs(t) do
    length = length + 1
  end
  return length
end

get_time = function()
-- could also use hs.timer.secondsSinceEpoch since it is fractional
  return timer.absoluteTime()
end

pressed_with_delay = function(prev)
  local delay = get_time() - prev
  return delay < min_delay
end

already_pressed = false
prev_modifiers = {}
prev_time = 0

modifier_handler = function(evt)

  local flags = evt:rawFlags()
  local curr_modifiers = evt:getFlags()
  local rCmdCode = 1048848

  if flags == rCmdCode and curr_modifiers['cmd'] and len(curr_modifiers) == 1 and len(prev_modifiers) == 0 then
    already_pressed = true
    prev_time = get_time()
  elseif prev_modifiers['cmd'] and len(curr_modifiers) == 0 and already_pressed and pressed_with_delay(prev_time) == true then
    already_pressed = false
    hs.eventtap.keyStroke({'fn', 'cmd', 'alt', 'shift'}, 'f3')
  else
    already_pressed = false
  end

  prev_modifiers = curr_modifiers

  return false
end

-- Call the modifier_handler function anytime a modifier key is pressed or released
modifier_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, modifier_handler)


-- If any non-modifier key is pressed, we know we won't be sending anything
non_modifier_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(evt)
  already_pressed = false
  return false
end)

modifier_tap:start()
non_modifier_tap:start()
