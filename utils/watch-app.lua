local util = {}

local function tableContains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function util.startAppWatcher(appNameTriggers, hotkeys)
  function watchApplication(appName, eventType)
    -- App focused
    if eventType == hs.application.watcher.activated then
      if tableContains(appNameTriggers, appName) then
        for _, hotkey in pairs(hotkeys) do
          if hotkey then
            hotkey:enable()
          end
        end
      end
    end

    if eventType == hs.application.watcher.deactivated or eventType == hs.application.watcher.terminated then
      if tableContains(appNameTriggers, appName) then
        for _, hotkey in pairs(hotkeys) do
          if hotkey then
            hotkey:disable()
          end
        end
      end
    end
  end

  for _, appName in pairs(appNameTriggers) do
    -- must not be local - will be garbage-collected!
    -- see https://github.com/Hammerspoon/hammerspoon/issues/681#issuecomment-212286907
    appWatcher = hs.application.watcher.new(watchApplication)
    appWatcher:start()

    if hs.application.find(appName) ~= nil then
      watchApplication(appName, hs.application.watcher.launched)
    end
  end

end

return util
