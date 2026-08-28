-- See https://github.com/sarangak/dotfiles/blob/a407bae7aabd250afb591c265575ecab7afb5dba/dot_hammerspoon/slack.lua
local appname = 'Safari'

local function getSafariTabCount()
  local ok, result = hs.osascript.applescript([[
    tell application "Safari"
      set _tab_count to 0
      repeat with _w in every window
        set _tab_count to _tab_count + (count tabs of _w)
      end repeat
      return _tab_count
    end tell
  ]])

  if ok and tonumber(result) then
    return tonumber(result)
  end

  return 0
end

local function buildQuitMessage(windowCount, tabCount)
  local windowLabel = (windowCount == 1) and 'window' or 'windows'
  local tabLabel = (tabCount == 1) and 'tab' or 'tabs'
  return string.format('This will close %d %s containing %d %s.', windowCount, windowLabel, tabCount, tabLabel)
end

local function quitSafariGracefully(app)
  app:activate()
  return app:selectMenuItem({ 'Safari', 'Quit Safari' })
end

local function confirmQuitSafari()
  local safari = hs.application.get(appname)
  if not safari then
    return
  end

  safari:activate()
  hs.timer.usleep(150000)

  local windows = safari:allWindows()
  local windowCount = #windows
  local tabCount = getSafariTabCount()
  local message = buildQuitMessage(windowCount, tabCount)

  local button = hs.dialog.blockAlert(
    'Are you sure you want to quit Safari?',
    message,
    'Quit',
    'Cancel'
  )

  if button == 'Quit' then
    quitSafariGracefully(safari)
  end
end

local hotkeys = {
  -- Shortcut: Quit confirmation
  hs.hotkey.new({ 'cmd' }, 'q', nil, confirmQuitSafari),
  -- Shortcut: Move tab to the left
  hs.hotkey.new({'ctrl', 'alt'}, ',', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/move-tab-to-left.applescript')
  end),
  -- Shortcut: Move tab to the right
  hs.hotkey.new({'ctrl', 'alt'}, '.', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/move-tab-to-right.applescript')
  end),
  -- Shortcut: Navigate to host
  hs.hotkey.new({'cmd', 'shift'}, 'k', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/safari-go-to-host.applescript')
  end),
  -- Shortcut: Navigate up a directory
  hs.hotkey.new({'alt'}, 'up', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/safari-go-up.applescript')
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
