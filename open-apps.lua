local centerMouse = require("utils/center-mouse")

local function open_app(name, centerCursor)
    centerCursor = centerCursor or false
    return function()
        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
        if centerCursor then
            centerMouse.centerMouse()
        end
    end
end

--- quick open applications
hs.hotkey.bind({}, "f6", open_app("Music", true))
hs.hotkey.bind({"alt", "cmd"}, "c", open_app("Nova"))
hs.hotkey.bind({"alt", "cmd"}, "s", open_app("Safari"))
hs.hotkey.bind({"alt", "cmd"}, "z", open_app("Figma"))
hs.hotkey.bind({"alt", "cmd"}, "m", open_app("Mail"))
hs.hotkey.bind({"alt", "cmd"}, "n", open_app("Notes"))
hs.hotkey.bind({"shift", "alt", "cmd"}, "c", open_app("Calendar"))
hs.hotkey.bind({"alt", "cmd", "shift"}, "f", open_app("Fork"))
hs.hotkey.bind({"alt", "cmd", "shift"}, "t", open_app("Transmit"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "c", open_app("Google Chrome"))
hs.hotkey.bind({"alt", "cmd"}, "e", open_app("Microsoft Teams", true))
hs.hotkey.bind({"alt", "cmd"}, "t", open_app("iTerm"))
hs.hotkey.bind({"alt", "cmd", "shift"}, ",", open_app("System Settings", true))
