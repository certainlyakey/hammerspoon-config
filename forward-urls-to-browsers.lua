-- see also https://github.com/search?q=URLDispatcher+url_patterns+language%3ALua&type=code&l=Lua
local ok, user_patterns = pcall(require, 'config/url-redirection-patterns')
if not ok then
	print("forward-urls-to-browsers: config/url-redirection-patterns not found, using defaults")
	user_patterns = {}
end

-- the config file should be in this format: (see https://www.hammerspoon.org/Spoons/URLDispatcher.html#url_patterns):
-- return {
  -- { "jira.mycompany.net",  "com.google.Chrome" },
  -- { "teams%.microsoft%.com",     "com.microsoft.teams2", nil, { "Safari", "Chrome", "Firefox", "Mail", "Slack" } }, -- Only apply from specific apps, not from Teams itself
  -- { "https?://go/",      "com.kagi.kagimacOS" },
-- }

-- A fix for https://github.com/electron/electron/issues/16896 (not related to Electron or Hammerspoon)
local function fixStrippedColonURL(event, params, senderPID, fullURL)
	-- fullURL arrives from Safari as e.g. "hammerspoon://https//reddit.com"
	-- Strip the hammerspoon:// prefix first
	local target = fullURL:gsub("^hammerspoon://", "")
	-- Restore the colon stripped by Safari: "https//" -> "https://"
	target = target:gsub("^(https?)(//)", "%1:%2")

	-- Forward to URLDispatcher via httpCallback, same as a normal http/https URL event
	if hs.urlevent.httpCallback then
		local scheme = target:match("^([^:]+)://")
		hs.urlevent.httpCallback(scheme, nil, {}, target, senderPID)
	end
end

hs.urlevent.bind("https", fixStrippedColonURL)
hs.urlevent.bind("http", fixStrippedColonURL)

hs.loadSpoon("URLDispatcher")

local url_patterns = {
	{ ".*", "com.apple.Safari" },
}

for key, value in pairs(user_patterns) do
	url_patterns[key] = value
end

spoon.URLDispatcher.url_patterns = url_patterns

spoon.URLDispatcher:start()
