-- Shortcut: Bind mouse side button to Reveal desktop
mouseSideButtonHandler = hs.eventtap.new({ hs.eventtap.event.types.otherMouseUp }, function(event)
  local button = event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)
  if button == 3 then
    hs.execute('open -a /System/Applications/Mission\\ Control.app/Contents/MacOS/Mission\\ Control  --args 1')
  end
end)

mouseSideButtonHandler:start()
