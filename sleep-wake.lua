function mute(e)
  if e == hs.caffeinate.watcher.screensDidWake then
    print('Volume muted 2')
    hs.osascript.applescript([[
      set volume 0
    ]])
  end
end

caffeinateWatcher = hs.caffeinate.watcher.new(mute)
caffeinateWatcher:start()
