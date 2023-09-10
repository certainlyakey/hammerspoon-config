-- https://github.com/jasonrudolph/keyboard/blob/e5e351f1cc80f62cca2ce688a5d4a3dd7f3a4b36/hammerspoon/control-escape.lua
len = function(t)
  local length = 0
  for k, v in pairs(t) do
    length = length + 1
  end
  return length
end

send_shortcut = false
prev_modifiers = {}

modifier_handler = function(evt)

  local flags = evt:rawFlags()
  local curr_modifiers = evt:getFlags()
  local rCmdCode = 1048848

  if flags == rCmdCode and curr_modifiers['cmd'] and len(curr_modifiers) == 1 and len(prev_modifiers) == 0 then
    send_shortcut = true
  elseif prev_modifiers['cmd'] and len(curr_modifiers) == 0 and send_shortcut then
    send_shortcut = false
    hs.eventtap.keyStroke({'fn', 'cmd', 'alt', 'shift'}, 'f3')
  else
    send_shortcut = false
  end

  prev_modifiers = curr_modifiers

  return false
end

-- Call the modifier_handler function anytime a modifier key is pressed or released
modifier_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, modifier_handler)


-- If any non-modifier key is pressed, we know we won't be sending anything
non_modifier_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(evt)
  send_shortcut = false
  return false
end)

modifier_tap:start()
non_modifier_tap:start()
