local globals = require('globals')

-- Shortcut: Love current song
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 'l', function()
  hs.osascript.applescriptFromFile('apple-scripts/love-song.applescript')
  local _, songInfo = hs.osascript.applescriptFromFile('apple-scripts/get-song.applescript')
  local image = hs.image.imageFromPath('~/.hammerspoon/images/app-music.png')
  hs.notify.new({title='Song loved', informativeText=songInfo}):setIdImage(image):contentImage(image):send()
end)

-- Shortcut: Turn VPN on
hs.hotkey.bind({'alt', 'cmd', 'shift'}, 'p', function()
  hs.execute('networksetup -connectpppoeservice "Nortal VPN"')
  hs.alert.show('Turning Nortal VPN on...', globals.alertStyle)
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
