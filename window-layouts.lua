-- Adapted from https://github.com/wincent/wincent/blob/main/aspects/dotfiles/files/.hammerspoon/init.lua

-- Usage: 
-- 1. Add your app bundle identifier to bundle_identifiers table. 
-- 2. Add your display size or position as a function below (see eg. internalDisplay, superwideDisplay), see https://www.hammerspoon.org/docs/hs.screen.html#find for reference.
-- 3. Duplicate an existing function block in setWindowLayout for a new app and modify the placements as desired.
-- 4. Optionally add the app bundle identifier to apps_to_watch table to have new windows of that app resized on the go.

-- Use 12x12 grid, which allows us to place on quarters, thirds and halves etc.
local width = 12
local height = 12

hs.grid.setGrid(width .. 'x' .. height)
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

hs.window.animationDuration = 0 -- disable animations

-- Forward function declarations.
local activateLayout = nil
local canManageWindow = nil
local handleScreenEvent = nil
local handleWindowEvent = nil

local screenCount = #hs.screen.allScreens()

-- Debug: print screen positions
for _, screen in ipairs(hs.screen.allScreens()) do
  local x, y = screen:position()
  print(string.format("Screen '%s' position: (%d,%d)", screen:name(), x, y))
end

local p27u20Left = {
  x = 0, y = -1,
}
local p27u20Right = {
  x = 1, y = -1,
}

local asusPG49WCD = '5120x1440'

local macBookPro14 = '1512x982'

local internalDisplay = function()
  return hs.screen.find(macBookPro14)
end

local superwideDisplay = function()
  return hs.screen.find(asusPG49WCD)
end

local wideDisplayLeft = function()
  return hs.screen.find(p27u20Left)
end

local wideDisplayRight = function()
  return hs.screen.find(p27u20Right)
end

-- Returns a string specifing window location and dimensions on the grid of the
-- form:
--
--   "${x},${y} ${width}x${height}".
--
-- Example: "0,0 12x6" (represents a rectangle starting in the top-left,
-- occupying the full width of the screen and half the height.
local rect = function(x, y, w, h)
  return string.format('%d,%d %dx%d', math.floor(x), math.floor(y), math.floor(w), math.floor(h))
end

local grid = {
  full = {
    width = width,
    height = height,
  },
  half = {
    width = width / 2,
    height = height / 2,
  },
  third = {
    width = width / 3,
    height = height / 3,
  },
  quarter = {
    width = width / 4,
    height = height / 4,
  },
  sixth = {
    width = width / 6,
    height = height / 6,
  },
  twelth = {
    width = width / 12,
    height = height / 12,
  },
  two = {
    thirds = {
      width = 2 * width / 3,
      height = 2 * height / 3,
    },
    fifths = {
      width = 2 * width / 5,
      height = 2 * height / 5,
    },
    sixths = {
      width = 2 * width / 6,
      height = 2 * height / 6,
    },
  },
  three = {
    quarters = {
      width = 3 * width / 4,
      height = 3 * height / 4,
    },
  },
  five = {
    sixths = {
      width = 5 * width / 6,
      height = 5 * height / 6,
    },
    twelfths = {
      width = 5 * width / 12,
      height = 5 * height / 12,
    },
  },
}
local placements = {
  centered = {
    full = rect(0, 0, grid.full.width, grid.full.height),
    huge = rect(grid.twelth.width, 0, grid.five.sixths.width, grid.full.height),
    big = rect(grid.sixth.width, 0, grid.two.thirds.width, grid.full.height),
    medbig = rect(grid.quarter.width, 0, grid.half.width, grid.full.height),
    medium = rect(grid.quarter.width, 0, grid.two.sixths.width, grid.full.height),
    small = rect(grid.third.width, 0, grid.third.width, grid.full.height),
  },
  top = {
    half = rect(0, 0, grid.full.width, grid.half.height),
    third = rect(0, 0, grid.full.width, grid.third.height),
    quarter = rect(0, 0, grid.full.width, grid.quarter.height),
    two = {
      thirds = rect(0, 0, grid.full.width, grid.two.thirds.height),
    },
    three = {
      quarters = rect(0, 0, grid.full.width, grid.three.quarters.height),
    },
    left = rect(0, 0, grid.half.width, grid.half.height),
    right = rect(grid.half.width, 0, grid.half.width, grid.half.height),
  },
  right = {
    half = rect(grid.half.width, 0, grid.half.width, grid.full.height),
    third = rect(grid.two.thirds.width, 0, grid.third.width, grid.full.height),
    quarter = rect(grid.three.quarters.width, 0, grid.quarter.width, grid.full.height),
    two = {
      thirds = rect(grid.third.width, 0, grid.two.thirds.width, grid.full.height),
    },
    three = {
      quarters = rect(grid.quarter.width, 0, grid.three.quarters.width, grid.full.height),
    },
  },
  bottom = {
    half = rect(0, grid.half.height, grid.full.width, grid.half.height),
    third = rect(0, grid.two.thirds.height, grid.full.width, grid.third.height),
    quarter = rect(0, grid.three.quarters.height, grid.full.width, grid.quarter.height),
    two = {
      thirds = rect(0, grid.third.height, grid.full.width, grid.two.thirds.height),
    },
    three = {
      quarters = rect(0, grid.quarter.height, grid.full.width, grid.three.quarters.height),
    },
    left = rect(0, grid.half.height, grid.half.width, grid.half.height),
    right = rect(grid.half.width, grid.half.height, grid.half.width, grid.half.height),
  },
  left = {
    half = rect(0, 0, grid.half.width, grid.full.height),
    third = rect(0, 0, grid.third.width, grid.full.height),
    quarter = rect(0, 0, grid.quarter.width, grid.full.height),
    two = {
      thirds = rect(0, 0, grid.two.thirds.width, grid.full.height),
      fifths = rect(0, 0, grid.two.fifths.width, grid.full.height),
    },
    three = {
      quarters = rect(0, 0, grid.three.quarters.width, grid.full.height),
    },
    five = {
      sixths = rect(0, 0, grid.five.sixths.width, grid.full.height),
      twelfths = rect(0, 0, grid.five.twelfths.width, grid.full.height),
    },
  },
}

local bundle_identifiers = {
  Chrome = 'com.google.Chrome',
  Edge = 'com.microsoft.edgemac',
  VSCode = 'com.microsoft.VSCode',
  Teams = 'com.microsoft.teams2',
  Safari = 'com.apple.Safari',
  Ghostty = 'com.mitchellh.ghostty',
  Figma = 'com.figma.Desktop',
}

-- Apps to watch for resizing new windows. 
-- When a new window is created, it will be resized on the go according to the number/type of current displays. 
-- Do NOT add Safari here because this will resize all Safari windows including popups or native menus.
local apps_to_watch = {
  bundle_identifiers.VSCode,
  bundle_identifiers.Figma,
}

local setWindowLayout = {
  _before_ = function()
    --[[ hide(bundle_identifiers.Ghostty) ]]
  end,

  _after_ = function() end,

  [bundle_identifiers.Chrome] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 3 then
      hs.grid.set(window, placements.left.three.quarters, wideDisplayLeft())
    elseif count == 2 then
      hs.grid.set(window, placements.left.five.twelfths, hs.screen.primaryScreen())
    else
      hs.grid.set(window, placements.centered.full)
    end
  end,

  [bundle_identifiers.VSCode] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 3 then
      hs.grid.set(window, placements.centered.full, wideDisplayRight())
    elseif count == 2 then
      hs.grid.set(window, placements.right.half, hs.screen.primaryScreen())
    else
      hs.grid.set(window, placements.centered.full)
    end
  end,

  [bundle_identifiers.Teams] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 3 then
      hs.grid.set(window, placements.centered.full, internalDisplay())
    elseif count == 2 then
      hs.grid.set(window, placements.centered.medium, hs.screen.primaryScreen())
    else
      hs.grid.set(window, placements.centered.full)
    end
  end,

  [bundle_identifiers.Edge] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 3 then
      hs.grid.set(window, placements.left.two.thirds, wideDisplayRight())
    elseif count == 2 then
      hs.grid.set(window, placements.centered.medbig, hs.screen.primaryScreen())
    else
      hs.grid.set(window, placements.centered.full)
    end
  end,

  [bundle_identifiers.Safari] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 3 then
      hs.grid.set(window, placements.left.two.thirds, wideDisplayRight())
    elseif count == 2 then
      hs.grid.set(window, placements.centered.medbig, hs.screen.primaryScreen())
    else
      hs.grid.set(window, placements.centered.full)
    end
  end,

  [bundle_identifiers.Ghostty] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 3 then
      hs.grid.set(window, placements.right.quarter, wideDisplayLeft())
    elseif count == 2 then
      hs.grid.set(window, placements.right.half, hs.screen.primaryScreen())
    else
      hs.grid.set(window, placements.centered.full)
    end
  end,

  [bundle_identifiers.Figma] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 3 then
      hs.grid.set(window, placements.centered.full, internalDisplay())
    elseif count == 2 then
      hs.grid.set(window, placements.right.half, hs.screen.primaryScreen())
    else
      hs.grid.set(window, placements.centered.full)
    end
  end,
}

--
-- Utility and helper functions.
--

canManageWindow = function(window)
  return window:isStandard()
end

local getNamesOfAllScreensAsString = function()
  local names = {}
  for _, screen in ipairs(hs.screen.allScreens()) do
    table.insert(names, screen:name())
  end
  return table.concat(names, ', ')
end

activateLayout = function(forceScreenCount)
  local screenCount = #hs.screen.allScreens()
  hs.alert.show('layout activated, ' .. screenCount .. ' screens found: ' .. getNamesOfAllScreensAsString(), {
    atScreenEdge = 2, -- bottom
  }, hs.screen.primaryScreen(), 5)
  setWindowLayout._before_()

  for bundleID, callback in pairs(setWindowLayout) do
    local application = hs.application.get(bundleID)
    if application then
      local windows = application:visibleWindows()
      for _, window in pairs(windows) do
        if canManageWindow(window) then
          callback(window, forceScreenCount)
        end
      end
    end
  end

  setWindowLayout._after_()
end

--
-- Event-handling
--

handleWindowEvent = function(window)
  if canManageWindow(window) then
    local application = window:application()
    local bundleID = application:bundleID()
    if setWindowLayout[bundleID] and hs.fnutils.contains(apps_to_watch, bundleID) then
      hs.alert.show('new window resized for ' .. bundleID)
      setWindowLayout[bundleID](window)
    end
  end
end

local windowFilter = hs.window.filter.new()
windowFilter:subscribe(hs.window.filter.windowCreated, handleWindowEvent)

handleScreenEvent = function()
  local screens = hs.screen.allScreens()
  -- If the number of screens has changed, re-apply the layout.
  if not (#screens == screenCount) then
    screenCount = #screens
    if screenCount < 4 then
      activateLayout(screenCount)
    end
  end
end

hs.hotkey.bind({ 'ctrl', 'shift', 'cmd' }, 's', function()
  local screenCount = #hs.screen.allScreens()
  if screenCount < 4 then
    activateLayout(screenCount)
  end
end)

local screenWatcher = hs.screen.watcher.new(handleScreenEvent)
screenWatcher:start()
