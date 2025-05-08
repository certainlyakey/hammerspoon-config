# What these Hammerspoon scripts can do?

These are my assorted [Hammerspoon](https://www.hammerspoon.org) scripts, sometimes taken from someone else and sometimes written on my own. Feel free to copy and improve them. Huge thanks to people who are the original authors (usually indicated in a script file).

The scripts were tested with Sonoma/Sequoia (although an occasional script remains to be updated in order to work on Sequoia).

## Opening apps, focusing and moving windows

### Open specific pane in the Settings app

See [`open-apps.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/open-apps.lua).

### Switch windows of specific app on current space when repeatedly pressing the same shortcut

See [`open-apps.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/open-apps.lua) for usage and [`focus-or-next-window.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/focus-or-next-window.lua). 

### Focus already opened windows of an app on this space, otherwise focus windows of another app

This helps if you use two browsers for example and have Vivaldi opened in one space but Safari in another. Now you can refocus a browser window regardless of which browser you have open on the current space.

This assumes you will not mix browsers in the same space. 

See [`open-apps.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/open-apps.lua) for usage and [`open-app.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/open-app.lua). 

### Activate an app window and then close it with the same hotkey

See [`fn-keys.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/fn-keys.lua) for usage and [`toggle-app.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/toggle-app.lua). 

### Grow and shrink windows with 2 hotkeys

See [`window-manipulation.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/window-manipulation.lua) for usage and [`grow-shrink.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/grow-shrink.lua).

### Move windows to left/right space

See [`window-manipulation.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/window-manipulation.lua) for usage and [`windows-spaces.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/windows-spaces.lua).

### Move mouse to current window by double tapping a modifier key

See [`double-tap-modifiers.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/double-tap-modifiers.lua) for usage, [`center-mouse.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/center-mouse.lua) for the action and [`double-tap.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/double-tap.lua) for the hotkey.

## System actions

### Toggling a specific VPN with a hotkey

The script will also display an icon for the currently enabled VPN in the menubar – because MacOS doesn't do the job well. The VPN protocol must be supported natively by MacOS (doesn't work with OpenVPN, WireGuard etc.).

See [`system-actions.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/system-actions.lua) for usage and [`toggle-vpn.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/toggle-vpn.lua).

### Toggling Wifi with a hotkey

See [`system-actions.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/system-actions.lua) for usage.

### Reveal Desktop by double tapping a modifier key

You can use native MacOS functionality to have Desktop revealed by single tap, but that disallows the default usage of the key and proves to be too annoying.

See [`double-tap-modifiers.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/double-tap-modifiers.lua) for usage and [`double-tap.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/double-tap.lua).

### Reveal Desktop by pressing a side mouse button

See [`mouse-buttons.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/mouse-buttons.lua).

### Toggle menubar with a hotkey

See [`system-actions.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/system-actions.lua).

### Muting on wake

See [`sleep-wake.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/sleep-wake.lua).

### Open Spotlight by double tapping a modifier key

> [!IMPORTANT]
> You will need to assign a hard-to-reach hotkey to Spotlight in MacOS Settings. Spotlight is impossible to open programmatically.

See [`double-tap-modifiers.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/double-tap-modifiers.lua) for usage and [`double-tap.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/double-tap.lua).

### Control Spotlight popup by pressing modifier keys

Thanks to the script we can press `ctrl` to navigate to the next result and `shift` to open it. 

See [`spotlight.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/spotlight.lua).

### Navigate to space by pressing `§` as a modifier + number

> [!IMPORTANT]
> You will need to assign a set of hard-to-reach hotkeys to "Move to Desktop" commands in MacOS Settings. The keys in each shortcut should be numbered (eg `Ctrl+Shift+Alt+Cmd+1`, `Ctrl+Shift+Alt+Cmd+2`, etc.)

See [`go-to-space.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/go-to-space.lua).

### Navigate to last visited space by pressing a shortcut

> [!IMPORTANT]
> You will need to assign a set of hard-to-reach hotkeys to "Move to Desktop" commands in MacOS Settings. The keys in each shortcut should be numbered (eg `Ctrl+Shift+Alt+Cmd+1`, `Ctrl+Shift+Alt+Cmd+2`, etc.)

See [`go-to-last-space.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/go-to-last-space.lua).

### Always display Spotlight popup on the main monitor

By default Spotlight popup appears on the last monitor you used. This script will always move it to the main monitor.

See [`spotlight-fix-position.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/spotlight-fix-position.lua).

### Issue a left mouse click at current position

This script is able to simulate multiple clicks too (eg, double-click).

See [`fn-mod.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/fn-mod.lua) for usage and [`multi-clicker.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/multi-clicker.lua).

### Display an alert with a space number and optional label when switching spaces

You can optionally add a label to each space by creating a `spaces.txt` file next to the script. On each line the file should have a label for each space.

See [`display-space-number.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/display-space-number.lua).

### Hide system notifications

This hides currently open Notification Center banners and alerts.

See [`other.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/other.lua) for usage and [`close-notifications.js`](https://github.com/certainlyakey/hammerspoon-config/blob/main/jxa-scripts/close-notifications.js).


## Keyboard layout

### Toggle keyboard layout by pressing a modifier key

See [`switch-layout-with-modifier.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/switch-layout-with-modifier.lua).

### Convert text incorrectly typed with wrong keyboard layout

See [`convert-selection-layout.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/convert-selection-layout.lua).


## App actions

### Confirm quitting (or any action) by pressing a shortcut two times

See [`mail.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/mail.lua) for usage and [`quit-confirmation.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/utils/quit-confirmation.lua).

### Enable Markdown markup in any app

Many apps support Markdown-flavored syntax, but not many implement balancing wrapping characters when something is selected. This script allows to enable "Markdown mode" in any app by pressing a global shortcut and then have the selected text wrapped in backticks, have link markup inserted, etc. depending on an additional key pressed separately.

See [`markdown-mode.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/markdown-mode.lua).

### Love the currently playing song in Apple Music

This works in any app.

See [`system-actions.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/system-actions.lua) for usage and [`get-song.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/get-song.applescript).

## Finder-specific actions

### Open selected file in specific app

This can be useful if you have want to preview or quickly edit a file in a lightweight app without opening a heavier app that the filetype is assigned to by default.

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/finder.lua) for usage and [`finder-get-file-path.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/finder-get-file-path.applescript).

### Open current or selected folder in iTerm (or any other app) with same hotkey

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/finder.lua) for usage and [`get-finder-folder.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/get-finder-folder.applescript).

### Move files with a single keyboard shortcut

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/finder.lua) for usage and [`get-finder-folder.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/get-finder-folder.applescript).

### Copy selected text file contents

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/finder.lua) for usage and [`finder-copy-file-contents.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/finder-copy-file-contents.applescript).

### Create new file

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/finder.lua) for usage and [`finder-create-file.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/finder-create-file.applescript).

### Copy path of a folder or file

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/finder.lua) for usage and [`finder-get-file-path.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/finder-get-file-path.applescript).

### Eject only disk images with a hotkey

See [`open-folders.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/open-folders.lua).

## Safari-specific actions

### Display detailed confirmation dialog when quitting

See [`safari.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/safari.lua) for usage and [`safari-quit-confirmation.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/safari-quit-confirmation.applescript).

### Move tab to left/right with a hotkey

Note that due to Safari limitations this will reload the moved tab.

See [`safari.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/safari.lua) for usage and [`move-tab-to-left.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/move-tab-to-left.applescript) and [`move-tab-to-right.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/move-tab-to-right.applescript).

### Navigate to top-level host of the currently viewed Safari tab

See [`safari.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/safari.lua) for usage and [`safari-go-to-host.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/safari-go-to-host.applescript)

### Navigate "up a directory" in the currently viewed Safari tab

See [`safari.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apps/safari.lua) for usage and [`safari-go-up.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/main/apple-scripts/safari-up.applescript)

