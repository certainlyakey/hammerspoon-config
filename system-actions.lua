local globals = require('globals')
local toggleVpn = require('utils/toggle-vpn')

-- Shortcut: Love current song
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 'l', function()
  hs.osascript.applescript([[
    tell application "Music"
      set loved of current track to true
    end tell
  ]])
  local _, songInfo = hs.osascript.applescriptFromFile('apple-scripts/get-song.applescript')
  local image = hs.image.imageFromPath('~/.hammerspoon/images/app-music.png')
  if image ~= nil then
    hs.notify.new({title='Song loved', informativeText=songInfo}):setIdImage(image):contentImage(image):send()
  else
    hs.notify.new({title='Song loved', informativeText=songInfo}):send()
  end
  -- TODO: display artwork too https://stackoverflow.com/a/71430813/102397
end)

-- Shortcut: Turn VPN on
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 'p', function()
  toggleVpn('Nortal VPN', '🇪🇪')
end)

-- Shortcut: Toggle Wifi
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 'w', function()
  if hs.wifi.currentNetwork() == nil then
    hs.alert.show('Turning Wifi on', globals.alertStyle)
    os.execute('networksetup -setairportpower en1 on')
  else
    hs.alert.show('Turning Wifi off', globals.alertStyle)
    os.execute('networksetup -setairportpower en1 off')
  end
end)
