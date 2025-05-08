tell application "Safari"
	if it is running then
		-- Get the current URL of the active tab
		set currentURL to URL of current tab of front window
		
		-- Extract the host from the URL
		set AppleScript's text item delimiters to {"://"}
		set urlWithoutProtocol to text item 2 of currentURL
		set AppleScript's text item delimiters to {"/"}
		set hostOnly to text item 1 of urlWithoutProtocol
		
		-- Construct the new URL with just the host
		set newURL to "https://" & hostOnly
		
		-- Navigate to the new URL in the same tab
		set URL of current tab of front window to newURL
	else
		display dialog "Safari is not running" buttons {"OK"} default button "OK"
	end if
end tell