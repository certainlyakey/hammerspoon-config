return function()
  local function catcher(event)
    if event:getFlags()['fn'] and event:getKeyCode() == 76 then
      local currentpos = hs.mouse.absolutePosition()
      return true, {hs.eventtap.leftClick(currentpos)}
      -- return true, {hs.eventtap.event.newKeyEvent({}, "right", true)}
    end
  end
  fn_tapper = hs.eventtap.new({hs.eventtap.event.types.keyDown}, catcher):start()
end
