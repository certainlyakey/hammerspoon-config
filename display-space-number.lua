local fileUtils = require('utils/file-utils')
local lines = fileUtils.linesInFile('spaces.txt')

local getSpaceLabel = function(index)
  local label = ''

  -- In spaces.txt each line is a label for a space
  local next = next
  if next(lines) ~= nil then
    for i, line in ipairs(lines) do
      if index == i then label = line end
    end
  end
  return label
end

local spaceWatcher = hs.spaces.watcher.new(function(_)
  local screen = hs.screen.mainScreen()
  local space_ids = hs.spaces.spacesForScreen(screen:id())
  local focused_space_id = hs.spaces.focusedSpace()
  local focused_space_index = hs.fnutils.indexOf(space_ids, focused_space_id)

  local spaceLabel = getSpaceLabel(focused_space_index)
  local comment = ''
  if spaceLabel ~= '' then
    comment = ' - ' .. spaceLabel
  end

  hs.alert.closeAll()
  hs.alert.show('Space ' .. focused_space_index .. comment, 1)
end)
spaceWatcher:start()
