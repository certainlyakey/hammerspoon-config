-- Shortcut: Click
-- in contrast to newMouseEvent, supports multiple clicks
local multiClick = require('utils/multi-clicker')
local leftClicker = multiClick('leftMouse')
local clickNow = function()
  leftClicker.clickDown()
  leftClicker.clickUp()
end
local function catcher(event)
  -- fn-Enter
  if event:getFlags()['fn'] and event:getKeyCode() == 76 then
    return true, {clickNow()}
  end
end
-- See https://github.com/Hammerspoon/hammerspoon/discussions/3113#discussioncomment-3341851 for tips on eventtap performance
fn_tapper = hs.eventtap.new({hs.eventtap.event.types.keyDown}, catcher):start()
