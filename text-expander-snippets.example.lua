-- text-expander-snippets.example.lua
-- This is a template for the text expander snippets.
-- Copy this file to `text-expander-snippets.lua` to customize it.

return {
    -- 1. Simple Expansion: trigger is replaced with the string.
    -- (Note the trailing space in the trigger - it acts as a delimiter, and is typed by the user to trigger the expansion)
    ["bg "] = "background",

    -- 2. Text Selection: inserts the text and simulates Shift+Left to select a portion of it.
    ["accs "] = { text = "accessibility", select = 5 },

    -- 3. Cursor Movement: inserts the text and simulates Left Arrow to move the cursor without selecting.
    ["whth "] = { text = "what do you think, ", moveLeft = 2 },

    -- 4. Dynamic Output (Functions): evaluates the function when triggered.
    ["ddd "] = function() 
        return os.date("%d.%m.%Y") 
    end,

    -- 5. Random Choice (via Function): picks a random option, optionally with selection/movement.
    ["pbb "] = function()
        local choices = {
            { text = "probably", select = 1 },
            "maybe",
            "perhaps",
            "possibly"
        }
        return choices[math.random(#choices)]
    end,

    -- 6. Pattern Matching: use isPattern = true to evaluate the trigger as a Lua pattern.
    -- E.g. matches "ext" followed by 1 or more spaces.
    ["ext%s+"] = { text = "extension", isPattern = true }
}
