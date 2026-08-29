local M = {}

local MAX_BUFFER_LENGTH = 50
local typeBuffer = ""

-- The snippet library
-- Attempt to load personal config, fallback to example config
local status, snippets = pcall(require, "text-expander-snippets")
if not status then
    snippets = dofile(hs.configdir .. "/text-expander-snippets.example.lua")
end

-- Utility: Recursively evaluate replacement
local function evalReplacement(val)
    if type(val) == "function" then
        return evalReplacement(val())
    end
    if type(val) == "string" then
        return { text = val }
    end
    if type(val) == "table" then
        return val
    end
    return nil
end

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
            -- Remove last character (UTF-8 aware)
            local lastCharStart = utf8.offset(typeBuffer, -1)
            if lastCharStart then
                typeBuffer = typeBuffer:sub(1, lastCharStart - 1)
            end
        end
        return false
    end

    if resetKeys[keycode] then
        clearBuffer()
        return false
    end
    
    local char = e:getCharacters()
    if not char or char == "" then return false end
    
    -- Filter out control characters (like enter, tab, etc which are handled above)
    if char:match("%c") then
        return false
    end
    
    typeBuffer = typeBuffer .. char
    if utf8.len(typeBuffer) and utf8.len(typeBuffer) > MAX_BUFFER_LENGTH then
        local cutPos = utf8.offset(typeBuffer, -MAX_BUFFER_LENGTH)
        if cutPos then
            typeBuffer = typeBuffer:sub(cutPos)
        end
    end
    
    -- Check snippets
    for trigger, snippet in pairs(snippets) do
        local isPattern = type(snippet) == "table" and snippet.isPattern
        
        local matchStr = nil
        if isPattern then
            local pattern = trigger
            if not pattern:match("%$$") then pattern = pattern .. "$" end
            matchStr = typeBuffer:match(pattern)
        else
            local len = #trigger
            if typeBuffer:sub(-len) == trigger then
                matchStr = trigger
            end
        end
        
        if matchStr then
            local prevCharPos = #typeBuffer - #matchStr
            local prevChar = ""
            if prevCharPos > 0 then
                local prevCharStart = utf8.offset(typeBuffer, -1, prevCharPos + 1)
                if prevCharStart then
                    prevChar = typeBuffer:sub(prevCharStart, prevCharPos)
                end
            end
            
            -- Word boundary: empty (start of buffer), or any space/punctuation
            -- Since match pattern doesn't cover UTF-8 punctuation completely, we just ensure 
            -- it's not a standard word character and not a cyrillic letter
            local isWordBoundary = false
            if prevChar == "" or prevChar:match("[%s%p]") then
                isWordBoundary = true
            elseif not prevChar:match("[%wА-Яа-яЁё]") then
                -- Broad fallback for other non-word characters
                isWordBoundary = true
            end
            
            if isWordBoundary then
                -- Match triggered!
                
                -- Block the final character that completed the trigger
                local charsToDelete = utf8.len(matchStr) - 1
                local repData = evalReplacement(snippet)
                
                if repData and repData.text then
                    -- Execute substitution async so we can block the current keystroke
                    hs.timer.doAfter(0.01, function()
                        -- 1. Delete characters
                        for i = 1, charsToDelete do
                            hs.eventtap.keyStroke({}, "delete", 0)
                        end
                        
                        -- 2. Wait for deletes to process, then type text
                        hs.timer.doAfter(0.05, function()
                            hs.eventtap.keyStrokes(repData.text)
                            
                            -- 3. Wait for typing to complete before cursor movements
                            if repData.select or repData.moveLeft then
                                -- Safe estimation of typing time to prevent interleaving
                                local typeTime = (#repData.text * 0.01) + 0.1
                                hs.timer.doAfter(typeTime, function()
                                    if repData.select and type(repData.select) == "number" then
                                        for i = 1, repData.select do
                                            hs.eventtap.keyStroke({"shift"}, "left", 0)
                                        end
                                    end
                                    if repData.moveLeft and type(repData.moveLeft) == "number" then
                                        for i = 1, repData.moveLeft do
                                            hs.eventtap.keyStroke({}, "left", 0)
                                        end
                                    end
                                end)
                            end
                        end)
                    end)
                    
                    clearBuffer()
                    return true
                end
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
