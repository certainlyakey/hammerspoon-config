hs.loadSpoon('SpoonInstall')
local Install = spoon.SpoonInstall

local col = hs.drawing.color.x11
Install:andUse('MenubarFlag',
  {
    config = {
      colors = {
          ['Russian – PC'] = { col.red, col.white, col.red, col.white, col.red, col.white, col.red, col.white },
        }
      },
    start = true
  }
)
