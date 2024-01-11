local quitConfirmation = require('utils/quit-confirmation')

local appname = 'Mail'

local hotkeys = {
  -- Shortcut: Send mail
  hs.hotkey.new({'cmd'}, 'return', nil, function()
    local app = hs.appfinder.appFromName(appname)
    app:selectMenuItem({'Message', 'Send'})
  end),
  -- Shortcut: Quit with confirmation by double tapping the hotkey
  hs.hotkey.new({'cmd'}, 'q', nil, function()
    quitConfirmation()
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
