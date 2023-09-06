-- Double-tap of the modifier produces the original key
local function goToSpaceByNumber(spaceIndex)
  local all_spaces = hs.spaces.spacesForScreen(hs.screen.mainScreen():id())
  local new_space_id = all_spaces[spaceIndex]
  hs.spaces.gotoSpace(new_space_id)
end

-- from https://groups.google.com/g/hammerspoon/c/HgDHNAWupFU/m/hny2NN8FCAAJ
local modifierKey = '§'
local k = hs.hotkey.modal.new()
local triggerK = hs.hotkey.bind('', modifierKey, function() k:enter() end)

-- Shortcut: Go to space by pressing a custom modifier (§) and number key
for i = 1, 6 do
  k:bind('', tostring(i), function() goToSpaceByNumber(i) end, function() k:exit() end)
end

k:bind('', modifierKey, function()
  triggerK:disable()
end, function()
  hs.eventtap.keyStroke({''}, modifierKey)
  hs.timer.doAfter(.1, function() triggerK:enable() end)
  k:exit()
end)
