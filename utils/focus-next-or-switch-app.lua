--[[ use this in HS Console to get a bundle id of an app
hs.timer.doAfter(3, function()
  local app = hs.application.frontmostApplication()
  print(app:name(), app:bundleID(), app:path())
end)

]]

local centerMouse = require('utils/center-mouse')

local runningBundleIDs = {}
local appWatcher = nil

local function setRunningBundleID(app, isRunning)
  if not app then return end

  local ok, bundleID = pcall(function()
    return app:bundleID()
  end)

  if ok and bundleID then
    runningBundleIDs[bundleID] = isRunning or nil
  end
end

local function refreshRunningBundleIDs()
  runningBundleIDs = {}

  for _, app in ipairs(hs.application.runningApplications()) do
    setRunningBundleID(app, true)
  end
end

local function startAppWatcher()
  if appWatcher then return end

  refreshRunningBundleIDs()

  appWatcher = hs.application.watcher.new(function(_, eventType, app)
    if eventType == hs.application.watcher.launched then
      setRunningBundleID(app, true)
    elseif eventType == hs.application.watcher.terminated then
      if app then
        setRunningBundleID(app, false)
      else
        refreshRunningBundleIDs()
      end
    end
  end)
  appWatcher:start()
end

-- Avoids slow failed hs.application.get(bundleID) calls for apps that are not running.
-- Returns a sorted list of visible windows for the given app bundle ID.
-- Sorting by window ID gives a stable ordering that doesn't shift when focus
-- changes (unlike allWindows(), whose order follows recency).
local function getAppWindows(bundleID)
  if not runningBundleIDs[bundleID] then return {} end

  local runningApp = hs.application.get(bundleID)
  if not runningApp then
    runningBundleIDs[bundleID] = nil
    return {}
  end

  local windows = runningApp:visibleWindows()
  local appWindows = {}
  for _, w in ipairs(windows) do
    table.insert(appWindows, w)
  end

  table.sort(appWindows, function(a, b) return a:id() < b:id() end)
  return appWindows
end

local function launchFirstApp(bundleID)
  hs.application.launchOrFocusByBundleID(bundleID)
end

local function parseArguments(bundleIDs, centerCursor)
  assert(type(bundleIDs) == 'table', 'focusNextOrSwitch requires a table of app bundle IDs')
  assert(#bundleIDs > 0, 'focusNextOrSwitch requires at least one app bundle ID')

  for _, bundleID in ipairs(bundleIDs) do
    assert(type(bundleID) == 'string', 'focusNextOrSwitch app bundle IDs must be strings')
  end

  return bundleIDs, centerCursor or false
end

-- Combined focus-or-next-window + open-app utility.
-- API: focusNextOrSwitch({ firstAppBundleID, secondAppBundleID, ... }, centerCursor?) -> callback
--
-- The returned callback, on each invocation:
-- 1) Collects visible windows from all running app bundle IDs, combining them
--    into a single list in the same order as the arguments.
-- 2) If none of the apps have windows, launches the first app. Never launches
--    the second or later apps.
-- 3) If the currently focused window is in the list, focuses the next one
--    (wrapping around), cycling through all configured app windows.
-- 4) If none of the configured apps is focused, focuses the first available window.
-- 5) Optionally centers the mouse cursor on the focused window.
return function(bundleIDs, centerCursor)
  local appBundleIDs, shouldCenterCursor = parseArguments(bundleIDs, centerCursor)
  local firstAppBundleID = appBundleIDs[1]

  startAppWatcher()

  return function()
    local allWindows = {}
    for _, bundleID in ipairs(appBundleIDs) do
      for _, w in ipairs(getAppWindows(bundleID)) do
        table.insert(allWindows, w)
      end
    end

    if #allWindows == 0 then
      -- No windows from any configured app — launch the first app only.
      launchFirstApp(firstAppBundleID)
    elseif #allWindows == 1 then
      -- Single window total — just focus it. Re-focusing an already-focused
      -- window is effectively a no-op, matching example 1.
      allWindows[1]:focus()
    else
      -- Multiple windows available — find the focused one and cycle to next.
      local focusedWindow = hs.window.focusedWindow()
      local focusedId = focusedWindow and focusedWindow:id()

      local currentIndex = nil
      if focusedId then
        for i, w in ipairs(allWindows) do
          if w:id() == focusedId then
            currentIndex = i
            break
          end
        end
      end

      if currentIndex then
        -- Focused window is in our list — advance to next (wrap around).
        local nextIndex = (currentIndex % #allWindows) + 1
        allWindows[nextIndex]:focus()
      else
        -- Neither app is focused — focus the most recently used window.
        local allWindowIds = {}
        for _, w in ipairs(allWindows) do allWindowIds[w:id()] = true end

        local target = allWindows[1]
        for _, w in ipairs(hs.window.orderedWindows()) do
          if allWindowIds[w:id()] then
            target = w
            break
          end
        end
        target:focus()
      end
    end

    if shouldCenterCursor then
      centerMouse()
    end
  end
end
