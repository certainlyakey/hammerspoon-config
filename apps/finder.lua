local appname = 'Finder'
local app = hs.appfinder.appFromName(appname)

local hotkeys = {
  -- Shortcut: Toggle hidden files
  hs.hotkey.new({'ctrl'}, 'h', nil, function()
    hs.eventtap.event.newKeyEvent({ 'shift', 'cmd' }, '.', true):post(app)
  end),
  -- Shortcut: Open with Nova (doesn't work when set in Keyboard Shortcuts until first app switch)
  hs.hotkey.new({'ctrl', 'alt'}, 'c', nil, function()
    local _, path = hs.osascript.applescriptFromFile('apple-scripts/finder-get-file-path.applescript')
    hs.execute('open -a nova "' .. path .. '"')
  end),
  -- Shortcut: Open folder in iTerm
  hs.hotkey.new({'shift', 'cmd'}, 't', nil, function()
    local _, path = hs.osascript.applescriptFromFile(hs.fs.currentDir() .. '/apple-scripts/get-finder-folder.applescript')
    hs.execute('open -a iTerm "' .. path .. '"')
  end),
  -- Shortcut: Open folder in Fork
  hs.hotkey.new({'shift', 'cmd'}, 'f', nil, function()
    local _, path = hs.osascript.applescriptFromFile(hs.fs.currentDir() .. '/apple-scripts/get-finder-folder.applescript')
    hs.execute('open -a fork "' .. path .. '"')
  end),
  -- Shortcut: Copy file contents
  hs.hotkey.new({'shift', 'cmd'}, 'c', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/finder-copy-file-contents.applescript')
  end),
  -- Shortcut: Create file
  hs.hotkey.new({'ctrl'}, 't', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/finder-create-file.applescript')
  end),
  -- Shortcut: Copy file path
  hs.hotkey.new({'ctrl', 'cmd'}, 'c', nil, function()
    local _, path = hs.osascript.applescriptFromFile('apple-scripts/finder-get-file-path.applescript')
    hs.execute('echo "' .. path .. '" | pbcopy')
  end),
  -- Shortcut: Go back (resets to ⌘ when set in Keyboard Shortcuts)
  hs.hotkey.new({'cmd'}, 'left', nil, function()
    app:selectMenuItem({'Go', 'Back'})
  end),
  -- Shortcut: Go forward (resets to ⌘ when set in Keyboard Shortcuts)
  hs.hotkey.new({'cmd'}, 'right', nil, function()
    app:selectMenuItem({'Go', 'Forward'})
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
