return function()
  local cwin = hs.window.focusedWindow()
  local wf = cwin:frame()
  local cscreen = cwin:screen()
  local cres = cscreen:fullFrame()
  if cwin then
    -- Center the cursor one the focused window
    hs.mouse.absolutePosition({x=wf.x+wf.w/2, y=wf.y+wf.h/2})
  else
    -- Center the cursor on the screen
    hs.mouse.absolutePosition({x=cres.x+cres.w/2, y=cres.y+cres.h/2})
  end
end
