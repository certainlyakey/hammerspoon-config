-- From https://rakhesh.com/coding/using-hammerspoon-to-switch-apps/ with adaptations for Ventura
return function(app)
  local function getFileName(file)
    local fileName = file:match('[^/]*.app$')
    return fileName:sub(0, #fileName - 4)
  end

  local focusedWindow = hs.window.focusedWindow()
  -- Output of the above is an hs.window object

  -- I can get the application it belongs to via the :application() method
  -- See https://www.hammerspoon.org/docs/hs.window.html#application
  local focusedWindowApp = focusedWindow:application()
  -- This returns an hs.application object

  -- Get the name of this application; this isn't really useful fof us as launchOrFocus needs the app name on disk
  -- I do use it below, further on...
  local focusedWindowAppName = focusedWindowApp:name()

  -- This gives the path - /Applications/<application>.app
  local focusedWindowPath = focusedWindowApp:path()

  -- I need to extract <application> from that
  local appNameOnDisk = getFileName(focusedWindowPath)

  -- If already focused, try to find the next window
  if focusedWindow and appNameOnDisk == app then
    -- hs.application.get needs the name as per hs.application:name() and not the name on disk
    -- It can also take pid or bundle, but that doesn't help here
    -- Since I have the name already from above, I can use that though
    local appWindows = hs.application.get(focusedWindowAppName):allWindows()

    -- https://www.hammerspoon.org/docs/hs.application.html#allWindows
    -- A table of zero or more hs.window objects owned by the application. From the current space.

    if #appWindows > 0 then
      -- It seems that this list order changes after one window get focused,
      -- Let's directly bring the last one to focus every time
      -- https://www.hammerspoon.org/docs/hs.window.html#focus
      if app == 'Finder' then
        -- If the app is Finder the window count returned is one more than the actual count, so I subtract
        appWindows[#appWindows-1]:focus()
      else
        appWindows[#appWindows]:focus()
      end
    else
      -- this should not happen, but just in case
      hs.application.launchOrFocus(app)
    end
  else -- if not focused
    hs.application.launchOrFocus(app)
  end
end
