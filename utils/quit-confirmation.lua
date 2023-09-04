-- from https://github.com/matthieugicquel/dotfiles/blob/24d6479e00389f90c6a338d691d4f679932905b9/dotfiles/hammerspoon/init.lua#L61
local function quitConfirmationExpired(prompt_id, hotkey)
  hs.alert.closeSpecific(prompt_id)
  hotkey:delete() -- Will reactivate the prompt hotkey that was "overloaded"
end

return function()
  local prompt_id = hs.alert('Press again to quit', nil, nil , nil)
  local hotkey = hs.hotkey.bind({'cmd'}, 'q', function()
    hs.alert.closeSpecific(prompt_id)
    hs.alert('Quitting this app')
    local app = hs.application.frontmostApplication()
    app:kill()
  end)
  hs.timer.doAfter(2, function() quitConfirmationExpired(prompt_id, hotkey) end)
end
