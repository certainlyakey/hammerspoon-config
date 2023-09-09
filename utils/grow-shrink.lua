-- From https://github.com/fuermosi777/utils/blob/eac0f1f6f598bf047006641212696d84cb6d224b/hammerspoon/init.lua

local function screenWidthFraction(ratio)
  local win = hs.window.focusedWindow()
  local screenFrame = win:screen():frame()
  screenFrame = win:screen():absoluteToLocal(screenFrame)
  return math.floor(screenFrame.w * ratio)
end

local function screenHeightFraction(ratio)
  local win = hs.window.focusedWindow()
  local screenFrame = win:screen():frame()
  screenFrame = win:screen():absoluteToLocal(screenFrame)
  return math.floor(screenFrame.h * ratio)
end

return function(dir)
  return function()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screenFrame = win:screen():frame()
    frame = win:screen():absoluteToLocal(frame)
    screenFrame = win:screen():absoluteToLocal(screenFrame)
    local x = frame.x
    local y = frame.y
    local w = frame.w
    local h = frame.h

    if dir == 'right' then
      if x < 0 then -- overflow left
        frame.x = 0
        frame.w = math.min(frame.w, screenFrame.w)
      elseif x == 0 then -- attached left, expand to full and then shrink
        if w < screenWidthFraction(1 / 4) then -- win width less than 33%
          frame.w = screenWidthFraction(1 / 4)
        elseif w < screenWidthFraction(1 / 2) then -- win width less than 50%
          frame.w = screenWidthFraction(1 / 2)
        elseif w < screenWidthFraction(3 / 4) then -- win with less than 67%
          frame.w = screenWidthFraction(3 / 4)
        elseif w < screenFrame.w then -- win not full screen
          frame.w = screenFrame.w
        else -- already full with, start shrink
          frame.w = screenWidthFraction(3 / 4)
          frame.x = screenFrame.w - frame.w
        end
      elseif x + frame.w < screenFrame.w then -- gap on right side, attaching right
        frame.x = screenFrame.w - frame.w
      else -- already attached right or overflow right, shrink
        frame.w = screenFrame.w - x
        if w > screenWidthFraction(3 / 4) then
          frame.w = screenWidthFraction(3 / 4)
          frame.x = screenFrame.w - frame.w
        elseif w > screenWidthFraction(1 / 2) then
          frame.w = screenWidthFraction(1 / 2)
          frame.x = screenFrame.w - frame.w
        elseif w > screenWidthFraction(1 / 3) then
          frame.w = screenWidthFraction(1 / 3)
          frame.x = screenFrame.w - frame.w
        end
      end
    elseif dir == 'left' then
      if x + w > screenFrame.w then -- overflow right, un-overflow
        frame.x = screenFrame.w - w
        frame.w = math.min(frame.w, screenFrame.w)
      elseif x + w == screenFrame.w then -- attached right, expand to full then shrink
        if w < screenWidthFraction(1 / 4) then -- win with less than 33%
          frame.w = screenWidthFraction(1 / 4)
          frame.x = screenFrame.w - frame.w
        elseif w < screenWidthFraction(1 / 2) then -- win width less than 50%
          frame.w = screenWidthFraction(1 / 2)
          frame.x = screenFrame.w - frame.w
        elseif w < screenWidthFraction(3 / 4) then -- win with less than 67%
          frame.w = screenWidthFraction(3 / 4)
          frame.x = screenFrame.w - frame.w
        elseif w < screenFrame.w then -- win almost full width
          frame.w = screenFrame.w
          frame.x = screenFrame.w - frame.w
        else -- full width, start shrinking
          frame.w = screenWidthFraction(3 / 4)
        end
      elseif x > 0 then -- gap on left
        frame.x = 0
      else -- already attached left or overflow left
        frame.x = 0
        if w > screenWidthFraction(3 / 4) then
          frame.w = screenWidthFraction(3 / 4)
        elseif w > screenWidthFraction(1 / 2) then
          frame.w = screenWidthFraction(1 / 2)
        elseif w > screenWidthFraction(1 / 3) then
          frame.w = screenWidthFraction(1 / 3)
        end
      end
    elseif dir == 'up' then
      if y == screenFrame.y then -- attached to top
        -- shrink
        if h > screenHeightFraction(2 / 3) then
          frame.h = screenHeightFraction(2 / 3)
        elseif h > screenHeightFraction(1 / 2) then
          frame.h = screenHeightFraction(1 / 2)
        else
          frame.h = screenHeightFraction(1 / 3)
        end
      elseif y + h == screenFrame.h + screenFrame.y then -- attached to bottom
        if h < screenHeightFraction(1 / 3) then
          frame.h = screenHeightFraction(1 / 3)
          frame.y = screenFrame.h - frame.h + screenFrame.y
        elseif h < screenHeightFraction(1 / 2) then
          frame.h = screenHeightFraction(1 / 2)
          frame.y = screenFrame.h - frame.h + screenFrame.y
        elseif h < screenHeightFraction(2 / 3) then
          frame.h = screenHeightFraction(2 / 3)
          frame.y = screenFrame.h - frame.h + screenFrame.y
        else
          frame.y = screenFrame.y
          frame.h = screenFrame.h
        end
      elseif y + h > screenFrame.h + screenFrame.y then -- overflow bottom, attaching to bottom
        frame.y = screenFrame.h - h + screenFrame.y
      else -- not attached
        frame.y = screenFrame.y
      end
    elseif dir == 'down' then
      if y + h == screenFrame.h + screenFrame.y then -- attach to bottom
          if h > screenHeightFraction(2 / 3) then
            frame.h = screenHeightFraction(2 / 3)
            frame.y = screenFrame.h - frame.h + screenFrame.y
          elseif h > screenHeightFraction(1 / 2) then
            frame.h = screenHeightFraction(1 / 2)
            frame.y = screenFrame.h - frame.h + screenFrame.y
          elseif h > screenHeightFraction(1 / 3) then
            frame.h = screenHeightFraction(1 / 3)
            frame.y = screenFrame.h - frame.h + screenFrame.y
          end
        elseif y == screenFrame.y then -- attach to top
          if h < screenHeightFraction(1 / 3) then
            frame.h = screenHeightFraction(1 / 3)
          elseif h < screenHeightFraction(1 / 2) then
            frame.h = screenHeightFraction(1 / 2)
          elseif h < screenHeightFraction(2 / 3) then
            frame.h = screenHeightFraction(2 / 3)
          else
            frame.y = screenFrame.y
            frame.h = screenFrame.h
          end
        elseif y + h > screenFrame.h + screenFrame.y then -- overflow bottom do nothing
        else
          frame.y = screenFrame.h - h + screenFrame.y
        end
    end

    frame = win:screen():localToAbsolute(frame)
    win:setFrame(frame)
  end
end
