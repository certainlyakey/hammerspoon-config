local hammerspoonLoad = require("hammerspoon-load")
local openApps = require("open-apps")
local openFolders = require("open-folders")
local windowManipulation = require("window-manipulation")
local spoons = require("spoons")
local doubleTapModifiers = require("double-tap-modifiers")
local appSafari = require("apps/safari")
local appFinder = require("apps/finder")
local appMail = require("apps/mail")
local appTeams = require("apps/teams")
local appBrowsers = require("apps/browsers")
local markdownMode = require("markdown-mode")
-- local fnKeys = require("utils/fn-keys")
local other = require("other")
local playground = require("playground")


-- Global Hammerspoon settings

-- Disabled hs.application.enableSpotlightForNameSearches due to performance hit on config reload
-- hs.application.enableSpotlightForNameSearches(true)
hs.window.animationDuration = 0.2


-- Init functions

-- disabling due to currently using another shortcut for left click
-- fnKeys()


-- Links:
-- https://blog.jverkamp.com/2023/03/19/keyboard-chords-with-hammerspoon/
-- https://github.com/muescha/dot_hammerspoon/blob/886d7f33b441357365a226a9e3781fcaeef15787/Functions/HighLight.lua
-- https://balatero.com/writings/hammerspoon/retrieving-input-field-values-and-cursor-position-with-hammerspoon/
-- https://rakhesh.com/coding/using-hammerspoon-to-switch-apps/ - tap cmd+alt+shortcut twice to do x
-- https://evantravers.com/articles/2020/06/12/hammerspoon-handling-windows-and-layouts/
-- https://github.com/asmagill/hammerspoon-config-take2/blob/master/_Spoons/LeftRightHotkey.spoon/init.lua and https://github.com/harsilspatel/dotfiles/blob/master/config/hammerspoon/hotkeyextension/hotkeyextension.lua (distinguish between left and right mods)
-- https://github.com/Hammerspoon/hammerspoon/issues/2322#issuecomment-1090427915 (using § as modifier)
-- https://github.com/imty42/oh-my-hammerspoon/blob/b109ada5e420a9d4770e137d716bcf87ee925686/init.lua#L292 (automatically move windows around on screen change)
-- https://github.com/knu/Knu.spoon/tree/9e55529ce0c8460fc366973d77b3adca134aceda
