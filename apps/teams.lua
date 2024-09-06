local appname = 'Microsoft Teams'

local hotkeys = {
  -- Shortcut: Focus editing field
  hs.hotkey.new({'shift', 'cmd'}, 'c', nil, function()
      local app = hs.appfinder.appFromName(appname)
      hs.eventtap.event.newKeyEvent({'ctrl'}, 'r', true):post(app)
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

local wf = hs.window.filter.new(appname)
wf:subscribe(hs.window.filter.windowFocused, enableKeys)
:subscribe(hs.window.filter.windowUnfocused, disableKeys)
