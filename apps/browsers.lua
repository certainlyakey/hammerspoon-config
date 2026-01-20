-- See https://github.com/sarangak/dotfiles/blob/a407bae7aabd250afb591c265575ecab7afb5dba/dot_hammerspoon/slack.lua
-- TODO: support for many apps at once is not perfect – alternating apps may fail to enable/disable their shortcuts in correct sequence when switching from app to app

local hotkeys = {
  -- Shortcut: Copy URL of the currently opened tab
  hs.hotkey.new({'cmd', 'ctrl'}, 'c', nil, function()
    hs.osascript.applescriptFromFile(hs.fs.currentDir() .. '/apple-scripts/copy-url.applescript')
  end),
  -- Shortcut: Paste copied URL to the current tab
  hs.hotkey.new({'shift', 'alt', 'cmd'}, 'v', nil, function()
    hs.osascript.applescript([[
      tell application "System Events"
      set frontApp to name of first application process whose frontmost is true
      end tell
      if frontApp is "Safari" then
        tell application "Safari" to set the URL of the front document to (the clipboard)
      else if frontApp is "Google Chrome" then
        tell application "Google Chrome" to set URL of active tab of front window to (the clipboard)
      end if
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

local wf = hs.window.filter.new{ 'Safari', 'Vivaldi', 'Google Chrome' }
wf:subscribe(hs.window.filter.windowFocused, enableKeys)
:subscribe(hs.window.filter.windowUnfocused, disableKeys)
