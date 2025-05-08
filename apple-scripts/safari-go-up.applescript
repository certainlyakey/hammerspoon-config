tell application "Safari"
	if it is running then
		-- Get the current URL of the active tab
		set currentURL to URL of current tab of front window
		
		-- Remove any trailing slash from the URL
		if currentURL ends with "/" then
			set currentURL to text 1 thru -2 of currentURL
		end if
		
		-- Extract the URL up to the last directory
		set AppleScript's text item delimiters to "/"
		set urlParts to text items of currentURL
		if (count of urlParts) > 3 then
			set newURL to (text items 1 thru -2 of currentURL) as text
			set newURL to newURL & "/"
		else
			-- If there are no directories left, navigate to the host
			set newURL to (text items 1 thru 3 of currentURL) as text
			set newURL to newURL & "/"
		end if
		
		-- Navigate to the new URL in the same tab
		set URL of current tab of front window to newURL
	else
		display dialog "Safari is not running" buttons {"OK"} default button "OK"
	end if
end tell
