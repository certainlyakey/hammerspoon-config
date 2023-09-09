return function(name)
  local app = hs.application.frontmostApplication()
  local appName = app:name()

  return appName == name
end
