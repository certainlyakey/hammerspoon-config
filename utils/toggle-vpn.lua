local globals = require('globals')
local menubarIcon = hs.menubar.new()

return function(vpnName, menubarLabel)
  local status = hs.execute('networksetup -showpppoestatus "' .. vpnName .. '"')
  if string.find(status, 'disconnected') then
    hs.execute('networksetup -connectpppoeservice "' .. vpnName .. '"')
    hs.alert.show('Turning ' .. vpnName .. ' on...', globals.alertStyle)
    menubarIcon:setTitle(menubarLabel)
  else
    hs.execute('networksetup -disconnectpppoeservice "' .. vpnName .. '"')
    hs.alert.show('Turning ' .. vpnName .. ' off', globals.alertStyle)
    menubarIcon:delete()
  end
end
