local centerMouse = require('utils/center-mouse')

local function openFirstApp(appName)
  print('second app has no windows in this space, running the first one: ' .. appName)
  hs.application.launchOrFocus(appName)
  if appName == 'Finder' then
    hs.appfinder.appFromName(appName):activate()
  end
end

return function(firstApp, secondApp, centerCursor)
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
