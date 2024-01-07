local appWatcher = nil

local function reloadConfig()
  appWatcher:stop()
  appWatcher = nil
  hs.reload()
  hs.notify.new({title='Hammerspoon', informativeText='Configuration loaded'}):send()
end

-- function sleepCallback( eventType )
--   hs.timer.doAfter(1,hs.reload)
-- end

-- sleepWatcher = hs.caffeinate.watcher.new(sleepCallback):start()

-- configFileWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig)
-- configFileWatcher:start()
hs.hotkey.bind({'alt', 'shift', 'ctrl'}, 'r', function()
  reloadConfig()
end)

-- Callback function for application events
function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    if (appName == 'Finder') then
      -- Bring all Finder windows forward when one gets activated
      appObject:selectMenuItem({'Window', 'Bring All to Front'})
    end
  end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
