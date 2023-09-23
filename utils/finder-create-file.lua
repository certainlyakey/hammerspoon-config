  -- from https://github.com/asmagill/hammerspoon-config-take2/blob/cd2950dd962e1545ff6e5e29b87cfb5ca907d8a1/utils/_keys/finderNewFile.lua
local axuielement = require('hs.axuielement')
local dialog = require('hs.dialog')
local fs = require('hs.fs')
local application = require('hs.application')

return function()
  local _, path = hs.osascript.applescriptFromFile(hs.fs.currentDir() .. '/apple-scripts/get-finder-folder.applescript')
  local placeholderText = '.txt'
  local focusedApp = application.frontmostApplication()
  -- without this, dialogs won't take keyboard focus without clicking on them first
  application.launchOrFocus('Hammerspoon')

  -- make sure a window is focused
  local win = axuielement.applicationElement('Finder').AXFocusedWindow
  if not (win and win.AXTitle) then
    dialog.blockAlert('No window is currently focused in the Finder', '')
    focusedApp:activate()
    return
  end

  -- prompt for filename
  local btn, file = dialog.textPrompt('New file to create:', '', placeholderText, 'OK', 'Cancel')
  -- but return if they cancel or don't type in anything
  if btn ~= 'OK' or file == '' or file == placeholderText then
    focusedApp:activate()
    return
  end

  -- make sure file doesn't already exist
  local status, err = fs.touch(path .. '/' .. file)
  if not status and err ~= 'No such file or directory' then
    dialog.blockAlert('Error checking to see if file exists:', err)
    focusedApp:activate()
    return
  end

  if not status then
    -- create new empty file
    local f = io.open(path .. '/' .. file, 'w')
    if not f then
      dialog.blockAlert('Unable to create new file', '')
      focusedApp:activate()
      return
    end
    f:close()
    focusedApp:activate()
  end

  -- now open it in default editor
  -- hs.open(path .. '/' .. file)
end
