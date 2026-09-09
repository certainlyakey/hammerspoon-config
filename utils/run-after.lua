-- Timers are garbage-collected unless a reference is held until they fire
local pendingTimers = {}

return function(delay, fn)
  local timer
  timer = hs.timer.doAfter(delay, function()
    pendingTimers[timer] = nil
    fn()
  end)
  pendingTimers[timer] = true
  return timer
end
