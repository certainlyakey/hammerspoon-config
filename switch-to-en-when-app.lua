-- Automatically switch to English keyboard layout when certain apps are activated.
local globals = require('globals')

local module = {}

local appNames = {
	Ghostty = true,
	['IntelliJ IDEA'] = true,
	Fork = true,
	Code = true,
}

local function switchToEnglishLayout()
	if hs.keycodes.currentLayout() ~= globals.keyboardLayoutEn then
		hs.keycodes.setLayout(globals.keyboardLayoutEn)
	end
end

local function shouldSwitchForApp(appName)
	return appNames[appName] == true
end

local function handleAppEvent(appName, eventType)
	if eventType == hs.application.watcher.activated and shouldSwitchForApp(appName) then
		switchToEnglishLayout()
	end
end

module.appWatcher = hs.application.watcher.new(handleAppEvent)
module.appWatcher:start()

local frontmostApp = hs.application.frontmostApplication()
if frontmostApp and shouldSwitchForApp(frontmostApp:name()) then
	switchToEnglishLayout()
end

return module
