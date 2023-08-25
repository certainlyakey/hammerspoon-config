set currentTabURL to ""
tell application "System Events" to set frontApp to name of first process whose frontmost is true
if (frontApp starts with "Safari") or (frontApp starts with "Webkit") or (frontApp starts with "Orion") then
	using terms from application "Safari"
		tell application frontApp to set currentTabURL to URL of front document
	end using terms from
else if (frontApp starts with "Google Chrome") or (frontApp starts with "Chromium") or (frontApp starts with "Opera") or (frontApp starts with "Vivaldi") or (frontApp starts with "Brave Browser") or (frontApp starts with "Microsoft Edge") or (frontApp starts with "Arc") then
	using terms from application "Google Chrome"
		tell application frontApp to set currentTabURL to URL of active tab of front window
	end using terms from
-- else
-- return frontApp & " is not a supported browser"
end if
-- return currentTabURL
set the clipboard to currentTabURL
