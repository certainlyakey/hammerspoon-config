-- Configuration
local borderColor = {red=1, green=0, blue=0, alpha=0.8}
local fillColor = {red=1, green=0, blue=0, alpha=0.1}
local borderWidth = 10

-- Global variable to store the border
local rectangle = nil

-- Function to delete the border
local function deleteBorder()
    if rectangle then
        rectangle:delete()
        rectangle = nil
    end
end

-- Function to draw the border
local function drawBorder()
    -- Ensure any existing border is cleared first, in case the hotkey is triggered rapidly
    deleteBorder()

    local win = hs.window.focusedWindow()
    if not win then
        return
    end

    local frame = win:frame()
    local adjustedFrame = { x = frame.x, y = frame.y, w = frame.w, h = frame.h }

    rectangle = hs.drawing.rectangle(adjustedFrame)
    rectangle:setStrokeColor(borderColor)
    rectangle:setRoundedRectRadii(borderWidth, borderWidth)
    rectangle:setFill(true)
    rectangle:setFillColor(fillColor)
    rectangle:setStrokeWidth(borderWidth)
    rectangle:show()
end

-- Create a hotkey for ctrl+9 to show/hide the border
hs.hotkey.bind({"ctrl"}, "9",
    function() -- On key press
        drawBorder()
    end,
    function() -- On key release
        deleteBorder()
    end
)

--[[ Modifier_handler1 = function(evt)

  local flags = evt:rawFlags()
  print(flags)
  local curr_modifiers = evt:getFlags()
  print(curr_modifiers)
  local rCmdCode = 1573160
end

-- Call the Modifier_handler1 function anytime a modifier key is pressed or released
Modifier_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, Modifier_handler1) ]]

-- Export functions for external use
return {
    drawBorder = drawBorder,
    deleteBorder = deleteBorder,
}