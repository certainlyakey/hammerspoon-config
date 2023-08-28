local hammerspoonLoad = require("hammerspoon-load")
local openApps = require("open-apps")
local windowManipulation = require("window-manipulation")
local spoons = require("spoons")
local doubleTapModifiers = require("double-tap-modifiers")
local appSafari = require("apps/safari")
local appFinder = require("apps/finder")
local appBrowsers = require("apps/browsers")
local markdownMode = require("markdown-mode")
local other = require("other")
local playground = require("playground")

hs.application.enableSpotlightForNameSearches(true)
hs.window.animationDuration = 0.2

-- Links:
-- https://blog.jverkamp.com/2023/03/19/keyboard-chords-with-hammerspoon/
-- https://github.com/muescha/dot_hammerspoon/blob/886d7f33b441357365a226a9e3781fcaeef15787/Functions/HighLight.lua
-- https://balatero.com/writings/hammerspoon/retrieving-input-field-values-and-cursor-position-with-hammerspoon/
-- https://rakhesh.com/coding/using-hammerspoon-to-switch-apps/ - tap cmd+alt+shortcut twice to do x
-- https://evantravers.com/articles/2020/06/12/hammerspoon-handling-windows-and-layouts/
-- https://github.com/asmagill/hammerspoon-config-take2/blob/master/_Spoons/LeftRightHotkey.spoon/init.lua
