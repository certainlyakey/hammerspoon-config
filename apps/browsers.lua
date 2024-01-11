-- See https://github.com/sarangak/dotfiles/blob/a407bae7aabd250afb591c265575ecab7afb5dba/dot_hammerspoon/slack.lua
-- TODO: support for many apps at once is not perfect – alternating apps may fail to enable/disable their shortcuts in correct sequence when switching from app to app

local hotkeys = {
  -- Shortcut: Copy URL of the currently opened tab
  hs.hotkey.new({'cmd', 'ctrl'}, 'c', nil, function()
    hs.osascript.applescriptFromFile(hs.fs.currentDir() .. '/apple-scripts/copy-url.applescript')
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
