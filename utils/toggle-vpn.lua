local globals = require('globals')

return function(vpnName, menubarLabel)
  local menubarIcon = hs.menubar.new()
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
