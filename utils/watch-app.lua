local util = {}

function table.contains(table, element)
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
      if table.contains(appNameTriggers, appName) then
        for _, hotkey in pairs(hotkeys) do
          if hotkey then
            hotkey:enable()
          end
        end
      end
    end

    if eventType == hs.application.watcher.deactivated or eventType == hs.application.watcher.terminated then
      if table.contains(appNameTriggers, appName) then
        for _, hotkey in pairs(hotkeys) do
          if hotkey then
            hotkey:disable()
          end
        end
      end
    end
  end

  for _, appName in pairs(appNameTriggers) do
    appWatcher = hs.application.watcher.new(watchApplication)
    appWatcher:start()

    if hs.application.find(appName) ~= nil then
      watchApplication(appName, hs.application.watcher.launched)
    end
  end

end

return util
