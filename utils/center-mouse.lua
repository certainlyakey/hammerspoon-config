local util = {}

function util.centerMouse()
    local screen = hs.mouse.getCurrentScreen()
    -- local nextScreen = screen:next()
    local rect = screen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    hs.mouse.absolutePosition(center)
end

return util
