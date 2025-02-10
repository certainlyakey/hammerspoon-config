-- Double-tap of the modifier produces the original key
-- from https://groups.google.com/g/hammerspoon/c/HgDHNAWupFU/m/hny2NN8FCAAJ
local modifierKey = '§'
local k = hs.hotkey.modal.new()
local triggerK = hs.hotkey.bind('', modifierKey, function() 
    k:enter() 
end)

-- Function to handle space switching
local function goToSpaceByNumber(spaceIndex)
    hs.eventtap.event.newKeyEvent({ 'shift', 'ctrl', 'cmd', 'alt' }, tostring(spaceIndex), true):post()
end

-- Bind number keys only when in modal state
for i = 1, 6 do
    k:bind('', tostring(i), nil, function() 
        goToSpaceByNumber(i)
        k:exit()
    end)
end

-- Shortcut: Go to space by pressing a custom modifier (§) and number key
k:bind('', modifierKey, nil, function()
    triggerK:disable()
    hs.eventtap.keyStroke({''}, modifierKey)
    hs.timer.doAfter(0.1, function() 
        triggerK:enable() 
    end)
    k:exit()
end)

-- Automatically exit modal after 2 seconds if no key is pressed
k.entered = function(self)
    hs.timer.doAfter(2, function() 
        k:exit() 
    end)
end