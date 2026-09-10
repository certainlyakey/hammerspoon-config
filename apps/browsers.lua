-- See https://github.com/sarangak/dotfiles/blob/a407bae7aabd250afb591c265575ecab7afb5dba/dot_hammerspoon/slack.lua
-- TODO: support for many apps at once is not perfect – alternating apps may fail to enable/disable their shortcuts in correct sequence when switching from app to app

local hotkeys = {
  -- Shortcut: Copy URL of the currently opened tab
  hs.hotkey.new({'cmd', 'ctrl'}, 'c', nil, function()
    hs.osascript.applescriptFromFile(hs.fs.currentDir() .. '/apple-scripts/copy-url.applescript')
  end),
  -- Shortcut: Paste copied URL to the current tab
  hs.hotkey.new({'shift', 'alt', 'cmd'}, 'v', nil, function()
    -- Moving to a separate AppleScript file will cause the script to fail
    hs.osascript.applescript([[
      tell application "System Events"
      set frontApp to name of first application process whose frontmost is true
      end tell
      set clipboardText to the clipboard as text
      set newURL to clipboardText
      -- if clipboard isn't a full URL, resolve it against the current tab's protocol+hostname
      if not (clipboardText starts with "http://" or clipboardText starts with "https://") then
        set currentURL to ""
        if frontApp is "Safari" then
          tell application "Safari" to set currentURL to URL of front document
        else if frontApp is "Google Chrome" then
          tell application "Google Chrome" to set currentURL to URL of active tab of front window
        end if
        set oldDelims to AppleScript's text item delimiters
        set AppleScript's text item delimiters to "/"
        set urlParts to text items of currentURL
        set baseURL to (item 1 of urlParts) & "//" & (item 3 of urlParts)
        set AppleScript's text item delimiters to oldDelims
        if clipboardText starts with "/" then
          set newURL to baseURL & clipboardText
        else
          set newURL to baseURL & "/" & clipboardText
        end if
      end if
      if frontApp is "Safari" then
        tell application "Safari" to set the URL of the front document to newURL
      else if frontApp is "Google Chrome" then
        tell application "Google Chrome" to set URL of active tab of front window to newURL
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

local wf = hs.window.filter.new{ 'Safari', 'Vivaldi', 'Google Chrome', 'Microsoft Edge' }
wf:subscribe(hs.window.filter.windowFocused, enableKeys)
:subscribe(hs.window.filter.windowUnfocused, disableKeys)
