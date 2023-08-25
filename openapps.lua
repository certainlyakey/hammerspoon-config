local centerMouse = require("utils/center-mouse")
-- TBD: does not yet support centering on a window. See https://github.com/eldesperado/.dotfiles/blob/d18deca903b06d300949041f844a3c4b04823685/setup/hammerspoon/utils/mouse.lua#L9
-- centerMouse.centerMouse()

function open_app(name)
    return function()
        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
    end
end

--- quick open applications
hs.hotkey.bind({}, "f6", open_app("Music"))
hs.hotkey.bind({"alt", "cmd"}, "c", open_app("Nova"))
hs.hotkey.bind({"ctrl", "cmd"}, "s", open_app("Safari"))
hs.hotkey.bind({"alt", "cmd"}, "z", open_app("Figma"))
hs.hotkey.bind({"alt", "cmd"}, "m", open_app("Mail"))
hs.hotkey.bind({"alt", "cmd", "shift"}, "f", open_app("Fork"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "c", open_app("Google Chrome"))
hs.hotkey.bind({"alt", "cmd"}, "e", open_app("Microsoft Teams"))
hs.hotkey.bind({"alt", "cmd"}, "t", open_app("iTerm"))
hs.hotkey.bind({"alt", "cmd", "shift"}, ",", open_app("System Settings"))

hs.hotkey.bindSpec({ { "ctrl", "cmd"}, "c" },
    function()
        hs.osascript.applescriptFromFile("apple-scripts/copy-url.applescript")
    end
)
