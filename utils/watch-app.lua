local util = {}

function util.startAppWatcher(appNameTrigger, hotkeys)
  function watchApplication(appName, eventType)
    -- App focused
    if eventType == hs.application.watcher.activated then
      if appName == appNameTrigger then
        for _, hotkey in pairs(hotkeys) do
          if hotkey then
            hotkey:enable()
          end
        end
      end
    end

    if eventType == hs.application.watcher.deactivated or eventType == hs.application.watcher.terminated then
      if appName == appNameTrigger then
        for _, hotkey in pairs(hotkeys) do
          if hotkey then
            hotkey:disable()
          end
        end
      end
    end
  end

  appWatcher = hs.application.watcher.new(watchApplication)
  appWatcher:start()

  if hs.application.find(appNameTrigger) ~= nil then
    watchApplication(appNameTrigger, hs.application.watcher.launched)
  end

end

return util
