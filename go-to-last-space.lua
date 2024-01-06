local before_last_space_id = 0;
local last_space_id = 0;

local lastSpaceWatcher = hs.spaces.watcher.new(function(_)
  last_space_id = before_last_space_id
  before_last_space_id = hs.spaces.focusedSpace()
  print('current space id is ' .. before_last_space_id)
end)

lastSpaceWatcher:start()

hs.hotkey.bind({ 'ctrl' }, '`', function()
  print('last space is ' .. last_space_id)
  hs.spaces.gotoSpace(last_space_id)
  -- hs.eventtap.event.newKeyEvent({ 'shift', 'ctrl', 'cmd', 'alt' }, tostring(last_space_id), true):post()
end)
