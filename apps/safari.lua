-- See https://github.com/sarangak/dotfiles/blob/a407bae7aabd250afb591c265575ecab7afb5dba/dot_hammerspoon/slack.lua
local appname = 'Safari'

local hotkeys = {
  -- Shortcut: Quit confirmation
  hs.hotkey.new({'cmd'}, 'q', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/safari-quit-confirmation.applescript')
  end),
  -- Shortcut: Move tab to the left
  hs.hotkey.new({'ctrl', 'alt'}, ',', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/move-tab-to-left.applescript')
  end),
  -- Shortcut: Move tab to the right
  hs.hotkey.new({'ctrl', 'alt'}, '.', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/move-tab-to-right.applescript')
  end),
  -- Shortcut: Paste copied URL to the current tab
  hs.hotkey.new({'shift', 'alt', 'cmd'}, 'v', nil, function()
    hs.osascript.applescript([[
      tell application "Safari" to set the URL of the front document to (the clipboard)
    ]])
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
