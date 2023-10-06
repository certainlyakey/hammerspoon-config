local watchApp = require('../utils/watch-app')
local createNewFile = require('../utils/finder-create-file')
local appname = 'Finder'
local app = hs.appfinder.appFromName(appname)

local hotkeys = {
  -- Shortcut: Toggle hidden files
  hs.hotkey.new({'ctrl'}, 'h', nil, function()
    hs.eventtap.event.newKeyEvent({ 'shift', 'cmd' }, '.', true):post(app)
  end),
  -- Shortcut: Open with editor (doesn't work when set in Keyboard Shortcuts until first app switch)
  hs.hotkey.new({'ctrl', 'alt'}, 'c', nil, function()
    local _, path = hs.osascript.applescriptFromFile('apple-scripts/finder-get-file-path.applescript')
    -- Need to set `true` to load user shell config
    hs.execute('code ' .. path, true)
  end),
  -- Shortcut: Open folder in iTerm
  hs.hotkey.new({'ctrl', 'alt'}, 't', nil, function()
    local _, path = hs.osascript.applescriptFromFile(hs.fs.currentDir() .. '/apple-scripts/get-finder-folder.applescript')
    hs.execute('open -a iTerm "' .. path .. '"')
  end),
  -- Shortcut: Open folder in Fork
  hs.hotkey.new({'ctrl', 'alt'}, 'f', nil, function()
    local _, path = hs.osascript.applescriptFromFile(hs.fs.currentDir() .. '/apple-scripts/get-finder-folder.applescript')
    hs.execute('open -a fork "' .. path .. '"')
  end),
  -- Shortcut: Copy file contents
  hs.hotkey.new({'shift', 'cmd'}, 'c', nil, function()
    hs.osascript.applescriptFromFile('apple-scripts/finder-copy-file-contents.applescript')
  end),
  -- Shortcut: Create file
  hs.hotkey.new({'ctrl'}, 't', nil, function()
    createNewFile()
  end),
  -- Shortcut: Copy file path
  hs.hotkey.new({'ctrl', 'cmd'}, 'c', nil, function()
    local _, path = hs.osascript.applescriptFromFile('apple-scripts/finder-get-file-path.applescript')
    hs.execute('echo ' .. path .. ' | pbcopy')
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

watchApp.startAppWatcher({ appname }, hotkeys)
