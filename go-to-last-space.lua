local function goToSpaceByNumber(spaceIndex)
  hs.timer.doAfter(0.3, function()
    hs.eventtap.keyStroke({ 'shift', 'ctrl', 'cmd', 'alt' }, tostring(spaceIndex)) 
  end)
end

local before_last_space_id = 0;
local last_space_id = 0;

local lastSpaceWatcher = hs.spaces.watcher.new(function(_)
  last_space_id = before_last_space_id
  before_last_space_id = hs.spaces.focusedSpace()
end)

lastSpaceWatcher:start()

hs.hotkey.bind({ 'ctrl' }, '`', function()
  local screen = hs.screen.mainScreen()
  local space_ids = hs.spaces.spacesForScreen(screen:id())
  local focused_space_index = hs.fnutils.indexOf(space_ids, last_space_id)
  -- This also works, but doesn't allow to drag windows when switching
  -- hs.spaces.gotoSpace(last_space_id)
  goToSpaceByNumber(focused_space_index)
end)
