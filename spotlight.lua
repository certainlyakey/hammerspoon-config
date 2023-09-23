-- This line must be located in this file
hs.window.filter.default:allowApp'Spotlight'

-- https://github.com/jasonrudolph/keyboard/blob/e5e351f1cc80f62cca2ce688a5d4a3dd7f3a4b36/hammerspoon/control-escape.lua
local len = function(t)
  local length = 0
  for _, __ in pairs(t) do
    length = length + 1
  end
  return length
end

local send_down_key = false
local send_enter_key = false
local prev_modifiers = {}

local modifier_handler = function(evt)
  -- evt:getFlags() holds the modifiers that are currently held down
  local curr_modifiers = evt:getFlags()

  if curr_modifiers['ctrl'] and len(curr_modifiers) == 1 and len(prev_modifiers) == 0 then
    -- We need this here because we might have had additional modifiers, which
    -- we don't want to lead to an escape, e.g. [Ctrl + Cmd] —> [Ctrl] —> [ ]
    send_down_key = true
  elseif prev_modifiers['ctrl'] and len(curr_modifiers) == 0 and send_down_key then
    send_down_key = false
    hs.eventtap.keyStroke({}, 'DOWN')
  else
    send_down_key = false
  end

  if curr_modifiers['shift'] and len(curr_modifiers) == 1 and len(prev_modifiers) == 0 then
    send_enter_key = true
  elseif prev_modifiers['shift'] and len(curr_modifiers) == 0 and send_enter_key then
    send_enter_key = false
    hs.eventtap.keyStroke({}, 'return')
  else
    send_enter_key = false
  end

  prev_modifiers = curr_modifiers

  return false
end

-- Call the modifier_handler function anytime a modifier key is pressed or released
local modifier_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, modifier_handler)


-- If any non-modifier key is pressed, we know we won't be sending anything
local non_modifier_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function()
  send_down_key = false
  send_enter_key = false
  return false
end)


-- Use non-anonymous function to improve performance
local function enableKey()
  modifier_tap:start()
  non_modifier_tap:start()
end

local function disableKey()
  modifier_tap:stop()
  non_modifier_tap:stop()
end

local wfspot = hs.window.filter.new'Spotlight'
wfspot:subscribe(hs.window.filter.windowVisible, function()
  enableKey()
end):subscribe(hs.window.filter.windowNotVisible, function()
  disableKey()
end)
