local appname = 'Code'

local hotkeys = {
  -- Shortcut: Focus editing field
  hs.hotkey.new({'cmd', 'ctrl'}, 'r', nil, function()
    -- Doesn't work without focusing the app first
    hs.application.launchOrFocusByBundleID("com.google.Chrome")
    hs.eventtap.event.newKeyEvent('cmd', 'r', true):post(hs.application.get("com.google.Chrome"))
    hs.eventtap.event.newKeyEvent('cmd', 'r', false):post(hs.application.get("com.google.Chrome"))
    hs.timer.doAfter(0.3, function()
      hs.application.launchOrFocus('Visual Studio Code')
      hs.notify.new({title='Hammerspoon', informativeText='Chrome reloaded'}):send()
    end)
  end),
}

-- Use non-anonymous function to improve performance
local function enableKeys()
  -- Use this instead of pairs syntax to improve performance
  for k = 1, #hotkeys do
    hotkeys[k]:enable()
  end
end

local function disableKeys()
  for k = 1, #hotkeys do
    hotkeys[k]:disable()
  end
end

-- We want all windows of the app, and VSCode windows don't contain the app name
local wf = hs.window.filter.new(false):setAppFilter('Code')
wf:subscribe(hs.window.filter.windowFocused, enableKeys)
:subscribe(hs.window.filter.windowUnfocused, disableKeys)
