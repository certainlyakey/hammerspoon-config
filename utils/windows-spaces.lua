-- From https://github.com/iwfan/dotfiles/blob/1ec39c324d0e355fa35a09f4d543beaf2f7c6d35/hammerspoon/modules/window-management.lua
local util = {}

function util.moveToDesktopToLeft()
  local win = hs.window.focusedWindow()
  local all_spaces = hs.spaces.spacesForScreen(hs.screen.mainScreen():id())
  local focus_space = hs.spaces.focusedSpace()
  local index = hs.fnutils.indexOf(all_spaces, focus_space)
  if index == 1 then
      return
  end
  local prev_space_id = all_spaces[index - 1]
  hs.spaces.moveWindowToSpace(win:id(), prev_space_id)
  hs.spaces.gotoSpace(prev_space_id)
end

function util.moveToDesktopToRight()
  local win = hs.window.focusedWindow()
  local all_spaces = hs.spaces.spacesForScreen(hs.screen.mainScreen():id())
  local focus_space = hs.spaces.focusedSpace()
  local index = hs.fnutils.indexOf(all_spaces, focus_space)
  if index == #all_spaces then
      return
  end
  local next_space_id = all_spaces[index + 1]
  hs.spaces.moveWindowToSpace(win:id(), next_space_id)
  hs.spaces.gotoSpace(next_space_id)
end

return util
