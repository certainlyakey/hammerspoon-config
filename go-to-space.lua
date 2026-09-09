-- Tap § to type the character; hold it as a modifier to switch spaces
-- from https://groups.google.com/g/hammerspoon/c/HgDHNAWupFU/m/hny2NN8FCAAJ
local modifierKey = '§'
local k = hs.hotkey.modal.new()

-- Set when § is used as a modifier, so releasing it doesn't also type the character
local usedWhileHeld = false

local triggerK = hs.hotkey.bind('', modifierKey,
    function()
        usedWhileHeld = false
        k:enter()
    end,
    function()
        k:exit()
        if not usedWhileHeld then
            -- Unicode event rather than the § keycode, so this doesn't re-trigger the hotkey
            hs.eventtap.keyStrokes(modifierKey)
        end
    end
)

-- Function to handle space switching
local function goToSpaceByNumber(spaceIndex)
    hs.eventtap.event.newKeyEvent({ 'shift', 'ctrl', 'cmd', 'alt' }, tostring(spaceIndex), true):post()
end

-- Bind number keys only when in modal state
for i = 1, 6 do
    k:bind('', tostring(i), nil, function()
        usedWhileHeld = true
        goToSpaceByNumber(i)
    end)
end

-- Automatically exit modal after 2 seconds if no key is pressed.
-- A single restartable timer, cancelled on exit, so a stale countdown from an
-- earlier entry can't cut a later one short.
local exitTimer = hs.timer.delayed.new(2, function()
    k:exit()
end)

k.entered = function(self)
    exitTimer:start()
end

k.exited = function(self)
    exitTimer:stop()
end