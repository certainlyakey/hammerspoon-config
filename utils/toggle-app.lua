local centerMouse = require('utils/center-mouse')

return function(appName, mainWindowMenuPath, centerCursor)
  local centerCursor = centerCursor or false
  local frontmostApp = hs.application.frontmostApplication()
  local frontmostAppName = frontmostApp:name()
  if appName == frontmostAppName then
    local mainWin = frontmostApp:mainWindow()
    if mainWin then
      mainWin:close()
    else
      -- Opening main window
      frontmostApp:selectMenuItem(mainWindowMenuPath)
    end
  else
    hs.application.launchOrFocus(appName)
    if centerCursor then
      centerMouse()
    end
  end
end
