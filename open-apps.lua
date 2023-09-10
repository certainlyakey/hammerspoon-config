local centerMouse = require('utils/center-mouse')
local focusOrNext = require('utils/focus-or-next-window')

local function openFirstApp(appName)
  print('second app has no windows in this space, running the first one: ' .. appName)
  hs.application.launchOrFocus(appName)
  if appName == 'Finder' then
    hs.appfinder.appFromName(appName):activate()
  end
end

local function open_app(firstApp, secondApp, centerCursor)
  secondApp = secondApp or nil
  centerCursor = centerCursor or false
  return function()
    local secondAppIsRunning = hs.application.get(secondApp)
    if secondApp ~= nil and secondAppIsRunning then
      local secondAppWindows = secondAppIsRunning:allWindows()
      if #secondAppWindows > 0 then
        secondAppWindows[#secondAppWindows]:focus()
      else
        openFirstApp(firstApp)
      end
    else
      openFirstApp(firstApp)
    end

    if centerCursor then
      centerMouse()
    end
  end
end

--- quick open applications
hs.hotkey.bind({}, 'f6', open_app('Music', nil, true))
hs.hotkey.bind({'alt', 'cmd'}, 'c', open_app('Visual Studio Code', 'Nova'))
-- TODO: combine focusOrNext with open_app
-- hs.hotkey.bind({'alt', 'cmd'}, 's', function()
--   focusOrNext('Safari')
-- end)
hs.hotkey.bind({'alt', 'cmd'}, 's', open_app('Safari', 'Vivaldi'))
hs.hotkey.bind({'alt', 'cmd'}, 'z', open_app('Figma'))
hs.hotkey.bind({'alt', 'cmd'}, 'm', function()
  focusOrNext('Mail')
end)
hs.hotkey.bind({'alt', 'cmd'}, 'n', open_app('Notes'))
hs.hotkey.bind({'shift', 'alt', 'cmd'}, 'c', open_app('Calendar'))
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 'f', open_app('Fork'))
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 't', open_app('Transmit'))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'c', open_app('Google Chrome'))
hs.hotkey.bind({'alt', 'cmd'}, 'e', open_app('Microsoft Teams', nil, true))
hs.hotkey.bind({'alt', 'cmd'}, 't', open_app('iTerm'))
hs.hotkey.bind({'alt', 'cmd', 'shift'}, ',', function()
  local url = 'x-apple.systempreferences:com.apple.Keyboard-Settings.extension'

  local scheme = url:match('^([^:]+)')
  local handler = hs.urlevent.getDefaultHandler(scheme)
  -- or skip both of those and just do:
  -- local handler = 'com.apple.systempreferences'

  hs.urlevent.openURLWithBundle(url, handler)
end)

-- function mediaKeyCallback(event)
--   local delete = false
--
--   local data = event:systemKey()
--
--   if data["down"] == false or data["repeat"] == true then
--     if data["key"] == "EJECT" then
--       print('eject')
--       delete = true
--     elseif data["key"] == "FAST" then
--       hs.spotify.next()
--       delete = true
--     elseif data["key"] == "REWIND" then
--       hs.spotify.previous()
--       delete = true
--     end
--   end
--
--   return delete, nil
-- end
--
-- hs.eventtap.new({ hs.eventtap.event.types.NSSystemDefined }, mediaKeyCallback)
