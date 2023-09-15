local function sendFnKey(code, smallerSteps, delay)
  smallerSteps = smallerSteps or false
  delay = delay or 0
  
  if smallerSteps then
    hs.eventtap.event.newSystemKeyEvent(code, true):setFlags({['alt']=true, ['shift']=true}):post()
  else
    hs.eventtap.event.newSystemKeyEvent(code, true):post()
  end
  hs.timer.usleep(delay)
  hs.eventtap.event.newSystemKeyEvent(code, false):post()
end

-- See https://vvvfo.com/posts/bettertouchtool-hammerspoon
local function sendRepeatableKey(fromModifiers, fromKey, toFn)
  if not hs.hotkey.assignable(fromModifiers, fromKey) then
    hs.hotkey.deleteAll(fromModifiers, fromKey)
  end
  hs.hotkey.bind(fromModifiers, fromKey, toFn, nil, toFn)
end


sendRepeatableKey({}, 'F1', function()
  sendFnKey('BRIGHTNESS_DOWN', 200000)
end)
sendRepeatableKey({}, 'F2', function()
  sendFnKey('BRIGHTNESS_UP', 200000)
end)
hs.hotkey.bind({}, 'F7', function()
  sendFnKey('PREVIOUS')
end)
hs.hotkey.bind({}, 'F8', function()
  sendFnKey('PLAY')
end)
hs.hotkey.bind({}, 'F9', function()
  sendFnKey('NEXT')
end)
hs.hotkey.bind({}, 'F10', function()
  sendFnKey('MUTE')
end)
sendRepeatableKey({}, 'F11', function()
  sendFnKey('SOUND_DOWN', false, 100000)
end)
sendRepeatableKey({}, 'F12', function()
  sendFnKey('SOUND_UP', true)
end)

-- SOUND_UP
-- SOUND_DOWN
-- MUTE
-- BRIGHTNESS_UP
-- BRIGHTNESS_DOWN
-- CONTRAST_UP
-- CONTRAST_DOWN
-- POWER
-- LAUNCH_PANEL
-- VIDMIRROR
-- PLAY
-- EJECT
-- NEXT
-- PREVIOUS
-- FAST
-- REWIND
-- ILLUMINATION_UP
-- ILLUMINATION_DOWN
-- ILLUMINATION_TOGGLE
-- CAPS_LOCK
-- HELP
-- NUM_LOCK
