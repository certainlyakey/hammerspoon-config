-- From https://github.com/irliao/dotfiles/blob/a10e629dbcf4a2f85caf28164ec4f866b570b335/hammerspoon/windowFilter.lua#L9
fixSpotlightPosition = function()
  local spotlightWindow = (hs.window.focusedWindow() and hs.window.focusedWindow() or hs.window.frontmostWindow())
  if not spotlightWindow then
    return
  end
  local spotlightFrame = spotlightWindow:frame()
  local screen = spotlightWindow:screen()
  local screenFrame = screen:frame()

  spotlightFrame.x = (screenFrame.w / 2) - (spotlightFrame.w / 2)
  spotlightFrame.y = screenFrame.y + (screenFrame.h / 6)

  spotlightWindow:setFrame(spotlightFrame)
end

local wf_spotlight = hs.window.filter.new'Spotlight'
wf_spotlight:subscribe(hs.window.filter.windowVisible, fixSpotlightPosition)

return wf_spotlight
