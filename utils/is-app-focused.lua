local util = {}

function util.isAppFocused(name)
  local app = hs.application.frontmostApplication()
  local appName = app:name()

  return appName == name
end

return util
