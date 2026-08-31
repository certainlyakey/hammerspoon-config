local M = {}

local MAX_BUFFER_LENGTH = 50
local typeBuffer = ""

-- The snippet library
-- Attempt to load personal config, fallback to example config
local status, expanderData = pcall(require, "text-expander-snippets")
if not status then
    expanderData = dofile(hs.configdir .. "/text-expander-snippets.example.lua")
end

local config = expanderData.config or {}
local snippets = expanderData.snippets or expanderData

local disabledApps = {}
if config.disabledApps then
    for k, v in pairs(config.disabledApps) do
        if type(k) == "number" and type(v) == "string" then
            disabledApps[v] = true
        elseif type(k) == "string" then
            disabledApps[k] = v
        end
    end
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
        local copy = {}
        for k, v in pairs(val) do copy[k] = v end
        return copy
    end
    return nil
end

-- Utility: UTF-8 aware lowercasing and uppercasing (ASCII + Cyrillic)
local function utf8Lower(str)
    local lower = str:lower()
    local map = {
        ["А"]="а", ["Б"]="б", ["В"]="в", ["Г"]="г", ["Д"]="д", ["Е"]="е", ["Ё"]="ё", ["Ж"]="ж", ["З"]="з", ["И"]="и",
        ["Й"]="й", ["К"]="к", ["Л"]="л", ["М"]="м", ["Н"]="н", ["О"]="о", ["П"]="п", ["Р"]="р", ["С"]="с", ["Т"]="т",
        ["У"]="у", ["Ф"]="ф", ["Х"]="х", ["Ц"]="ц", ["Ч"]="ч", ["Ш"]="ш", ["Щ"]="щ", ["Ъ"]="ъ", ["Ы"]="ы", ["Ь"]="ь",
        ["Э"]="э", ["Ю"]="ю", ["Я"]="я"
    }
    for upper, l in pairs(map) do
        lower = lower:gsub(upper, l)
    end
    return lower
end

local function utf8Upper(str)
    local upper = str:upper()
    local map = {
        ["а"]="А", ["б"]="Б", ["в"]="В", ["г"]="Г", ["д"]="Д", ["е"]="Е", ["ё"]="Ё", ["ж"]="Ж", ["з"]="З", ["и"]="И",
        ["й"]="Й", ["к"]="К", ["л"]="Л", ["м"]="М", ["н"]="Н", ["о"]="О", ["п"]="П", ["р"]="Р", ["с"]="С", ["т"]="Т",
        ["у"]="У", ["ф"]="Ф", ["х"]="Х", ["ц"]="Ц", ["ч"]="Ч", ["ш"]="Ш", ["щ"]="Щ", ["ъ"]="Ъ", ["ы"]="Ы", ["ь"]="Ь",
        ["э"]="Э", ["ю"]="Ю", ["я"]="Я"
    }
    for lower, u in pairs(map) do
        upper = upper:gsub(lower, u)
    end
    return upper
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
    local activeApp = hs.application.frontmostApplication()
    if activeApp then
        local bundleID = activeApp:bundleID()
        local disabled = disabledApps[bundleID]
        if disabled ~= nil then
            if type(disabled) == "function" then
                if disabled(activeApp) then
                    clearBuffer()
                    return false
                end
            elseif disabled then
                clearBuffer()
                return false
            end
        end
    end
    
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
    local typeBufferLower = utf8Lower(typeBuffer)
    for trigger, snippet in pairs(snippets) do
        local isPattern = type(snippet) == "table" and snippet.isPattern
        local caseMode = type(snippet) == "table" and snippet.caseMode or 0
        
        local matchStr = nil
        local triggerToMatch = trigger
        local bufferToMatch = typeBuffer
        
        if caseMode >= 1 then
            triggerToMatch = utf8Lower(trigger)
            bufferToMatch = typeBufferLower
        end
        
        if isPattern then
            local pattern = triggerToMatch
            if not pattern:match("%$$") then pattern = pattern .. "$" end
            matchStr = bufferToMatch:match(pattern)
        else
            local len = #triggerToMatch
            if bufferToMatch:sub(-len) == triggerToMatch then
                matchStr = bufferToMatch:sub(-len)
            end
        end
        
        if matchStr then
            -- Note: matchStr length in bytes is the same whether lower or uppercase for our supported characters
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
                    -- Get the original casing of the matched trigger from the real buffer
                    local originalMatchStr = typeBuffer:sub(-#matchStr)
                    
                    -- Apply caseMode 2 logic
                    if caseMode == 2 then
                        local hasLower = (utf8Upper(originalMatchStr) ~= originalMatchStr)
                        local hasUpper = (utf8Lower(originalMatchStr) ~= originalMatchStr)
                        
                        -- Simple heuristic:
                        -- If it contains uppercase but NO lowercase, it's ALL CAPS
                        if hasUpper and not hasLower then
                            repData.text = utf8Upper(repData.text)
                        -- If the first character is uppercase, capitalize the output
                        else
                            local firstCharLen = utf8.offset(originalMatchStr, 2) or (#originalMatchStr + 1)
                            local firstChar = originalMatchStr:sub(1, firstCharLen - 1)
                            
                            local isFirstUpper = (utf8Lower(firstChar) ~= firstChar)
                            
                            if isFirstUpper then
                                local firstOutLen = utf8.offset(repData.text, 2) or (#repData.text + 1)
                                local firstOut = repData.text:sub(1, firstOutLen - 1)
                                local restOut = repData.text:sub(firstOutLen)
                                repData.text = utf8Upper(firstOut) .. restOut
                            end
                        end
                    end
                    
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
