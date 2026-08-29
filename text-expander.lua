local M = {}

local MAX_BUFFER_LENGTH = 50
local typeBuffer = ""

-- The snippet library
-- Trigger can be a string or a pattern.
-- We match triggers against the end of the typing buffer.
-- If isPattern is true, trigger is evaluated as a Lua pattern.
local snippets = {
    { trigger = "ext", replacement = "extension", select = 3 },
    { trigger = "ddd", replacement = function() return os.date("%d.%m.%Y") end },
    { trigger = "ext%s+", replacement = "extension", isPattern = true }
}

-- Utility: Clear the buffer
local function clearBuffer()
    typeBuffer = ""
end

-- Mouse clicks to reset cursor context
local mouseTap = hs.eventtap.new({
    hs.eventtap.event.types.leftMouseDown,
    hs.eventtap.event.types.rightMouseDown
}, function(e)
    clearBuffer()
    return false
end):start()

local keyTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    local keycode = e:getKeyCode()
    local flags = e:getFlags()
    
    -- If using modifier keys other than Shift, clear context
    if flags.cmd or flags.ctrl or flags.alt then
        clearBuffer()
        return false
    end

    local resetKeys = {
        [117] = true, -- Forward Delete
        [123] = true, -- Left
        [124] = true, -- Right
        [125] = true, -- Down
        [126] = true, -- Up
        [115] = true, -- Home
        [119] = true, -- End
        [116] = true, -- Page Up
        [121] = true, -- Page Down
        [36]  = true, -- Return
        [76]  = true, -- Enter
        [48]  = true, -- Tab
    }

    if keycode == 51 then -- Backspace
        if #typeBuffer > 0 then
            -- Remove last character
            -- Using string.sub is simple and works for ASCII.
            -- Note: UTF-8 backspacing in Lua requires more logic, 
            -- but assuming standard characters for snippets.
            typeBuffer = typeBuffer:sub(1, -2)
        end
        return false
    end

    if resetKeys[keycode] then
        clearBuffer()
        return false
    end
    
    local char = e:getCharacters()
    if not char or char == "" then return false end
    
    -- We only care about standard printable characters (including spaces/punctuation)
    if not char:match("[%w%s%p]") then
        return false
    end
    
    typeBuffer = typeBuffer .. char
    if #typeBuffer > MAX_BUFFER_LENGTH then
        typeBuffer = typeBuffer:sub(-MAX_BUFFER_LENGTH)
    end
    
    -- Check snippets
    for _, snippet in ipairs(snippets) do
        local matchStr = nil
        if snippet.isPattern then
            local pattern = snippet.trigger
            if not pattern:match("%$$") then pattern = pattern .. "$" end
            matchStr = typeBuffer:match(pattern)
        else
            local len = #snippet.trigger
            if typeBuffer:sub(-len) == snippet.trigger then
                matchStr = snippet.trigger
            end
        end
        
        if matchStr then
            local prevCharPos = #typeBuffer - #matchStr
            local prevChar = prevCharPos > 0 and typeBuffer:sub(prevCharPos, prevCharPos) or ""
            
            if prevChar == "" or prevChar:match("[%s%p]") then
                -- Match triggered!
                
                -- Block the final character that completed the trigger
                local charsToDelete = #matchStr - 1
                local replacement = type(snippet.replacement) == "function" and snippet.replacement() or snippet.replacement
                
                -- Execute substitution async so we can block the current keystroke
                hs.timer.doAfter(0.01, function()
                    for i = 1, charsToDelete do
                        hs.eventtap.keyStroke({}, "delete", 0)
                    end
                    hs.eventtap.keyStrokes(replacement)
                    
                    if snippet.select and type(snippet.select) == "number" then
                        for i = 1, snippet.select do
                            hs.eventtap.keyStroke({"shift"}, "left", 0)
                        end
                    end
                end)
                
                clearBuffer()
                return true
            end
        end
    end
    
    return false
end):start()

function M.start()
    -- Ensure taps are started (they are started on file require)
    return M
end

function M.stop()
    mouseTap:stop()
    keyTap:stop()
    return M
end

return M
