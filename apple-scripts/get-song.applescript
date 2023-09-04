set display to ""
tell application "Music"
	if player state is stopped then
		set display to "No Track Playing"
	else
		set track_artist to artist of current track
		set track_name to name of current track
		set state to ""
		if player state is paused then
			set state to "(Paused) "
		end if

		set display to state & track_name & " by " & track_artist
	end if
end tell
return display
