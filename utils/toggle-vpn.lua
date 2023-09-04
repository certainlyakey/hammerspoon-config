local globals = require('globals')

return function(vpnName)
  local status = hs.execute('networksetup -showpppoestatus "' .. vpnName .. '"')
  if string.find(status, 'disconnected') then
    hs.execute('networksetup -connectpppoeservice "' .. vpnName .. '"')
    hs.alert.show('Turning ' .. vpnName .. ' on...', globals.alertStyle)
  else
    hs.execute('networksetup -disconnectpppoeservice "' .. vpnName .. '"')
    hs.alert.show('Turning ' .. vpnName .. ' off', globals.alertStyle)
  end
end
