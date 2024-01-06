# What these Hammerspoon scripts can do?

These are my assorted Hammerspoon scripts, sometimes taken from someone else and sometimes written on my own. Feel free to copy and improve them. Huge thanks to people who are the original authors (usually indicated in a script file).

## Opening apps, focusing and moving windows

### Open specific pane in the Settings app

See [`open-apps.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/ab899564c4c297d64dfb62255fb656f8257c7c71/open-apps.lua).

### Switch windows of specific app on current space when repeatedly pressing the same shortcut

See [`open-apps.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/ab899564c4c297d64dfb62255fb656f8257c7c71/open-apps.lua) for usage and [`focus-or-next-window.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/1ef00026f27eec52372cf793c26230098072babd/utils/focus-or-next-window.lua). 

### Focus already opened windows of an app on this space, otherwise focus windows of another app

This helps if you use two browsers for example and have Vivaldi opened in one space but Safari in another. Now you can refocus a browser window regardless of which browser you have open on the current space.

This assumes you will not mix browsers in the same space. 

See [`open-apps.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/ab899564c4c297d64dfb62255fb656f8257c7c71/open-apps.lua) for usage and [`open-app.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/e32d0ae0ddbcac7605c82e13e68a642340c5b427/utils/open-app.lua). 

### Grow and shrink windows with 2 hotkeys

See [`window-manipulation.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/c68ff0984a552610b0d1bd04024f0ff901617aea/window-manipulation.lua) for usage and [`grow-shrink.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/c68ff0984a552610b0d1bd04024f0ff901617aea/utils/grow-shrink.lua).

### Move windows to left/right space

See [`window-manipulation.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/c68ff0984a552610b0d1bd04024f0ff901617aea/window-manipulation.lua) for usage and [`windows-spaces.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/250e512301cc7d867a4a2e2cf6e6264fb7bdf52c/utils/windows-spaces.lua).

### Move mouse to current window by double tapping a modifier key

See [`double-tap-modifiers.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/17435a7b28903ac2f210fbbb7a0bc713f3f1044a/double-tap-modifiers.lua) for usage, [`center-mouse.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/d37a8108fb2419101e67911e9b13b75417d57b05/utils/center-mouse.lua) for the action and [`double-tap.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/2eab4b9e3cefc523cba77d457b4a485c4806a0aa/utils/double-tap.lua) for the hotkey.

## System actions

### Toggling a specific VPN with a hotkey

The script will also display an icon for the currently enabled VPN in the menubar – because MacOS doesn't do the job well.

See [`system-actions.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/46fbab2f49d624e939fc81c146450bf0a0223fc7/system-actions.lua) for usage and [`toggle-vpn.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/46fbab2f49d624e939fc81c146450bf0a0223fc7/utils/toggle-vpn.lua).

### Toggling Wifi with a hotkey

See [`system-actions.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/46fbab2f49d624e939fc81c146450bf0a0223fc7/system-actions.lua) for usage.

### Reveal Desktop by double tapping a modifier key

You can use native MacOS functionality to have Desktop revealed by single tap, but that disallows the default usage of the key and proves to be too annoying.

See [`double-tap-modifiers.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/17435a7b28903ac2f210fbbb7a0bc713f3f1044a/double-tap-modifiers.lua) for usage and [`double-tap.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/2eab4b9e3cefc523cba77d457b4a485c4806a0aa/utils/double-tap.lua).

### Open Spotlight by double tapping a modifier key

> [!IMPORTANT]
> You will need to assign a hard-to-reach hotkey to Spotlight in MacOS Settings. Spotlight is impossible to open programmatically.

See [`double-tap-modifiers.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/17435a7b28903ac2f210fbbb7a0bc713f3f1044a/double-tap-modifiers.lua) for usage and [`double-tap.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/2eab4b9e3cefc523cba77d457b4a485c4806a0aa/utils/double-tap.lua).

### Control Spotlight popup by pressing modifier keys

Thanks to the script we can press `ctrl` to navigate to the next result and `shift` to open it. 

See [`spotlight.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/ab899564c4c297d64dfb62255fb656f8257c7c71/spotlight.lua).

### Navigate to space by pressing `§` as a modifier + number

> [!IMPORTANT]
> You will need to assign a set of hard-to-reach hotkeys to "Move to Desktop" commands in MacOS Settings. The keys in each shortcut should be numbered (eg `Ctrl+Shift+Alt+Cmd+1`, `Ctrl+Shift+Alt+Cmd+2`, etc.)

See [`go-to-space.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/df63c963564a5201c3441bc8dad7073912e84f85/go-to-space.lua).

### Navigate to last visited space by pressing a shortcut

> [!IMPORTANT]
> You will need to assign a set of hard-to-reach hotkeys to "Move to Desktop" commands in MacOS Settings. The keys in each shortcut should be numbered (eg `Ctrl+Shift+Alt+Cmd+1`, `Ctrl+Shift+Alt+Cmd+2`, etc.)

See [`go-to-last-space.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/df63c963564a5201c3441bc8dad7073912e84f85/go-to-last-space.lua).

### Always display Spotlight popup on the main monitor

By default Spotlight popup appears on the last monitor you used. This script will always move it to the main monitor.

See [`spotlight-fix-position.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/f96c646d179c7eef99108293e93f0bdc29347739/spotlight-fix-position.lua).

### Toggle keyboard layout by pressing a modifier key

See [`switch-layout-with-modifier.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/28a01c742879b045ae63c25768c634a2b79d73a8/switch-layout-with-modifier.lua).

### Issue a left mouse click at current position

This script is able to simulate multiple clicks too (eg, double-click).

See [`fn-mod.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/8fd522d00a13f9b670a9675db92fc7a1ca71aa30/utils/fn-mod.lua) for usage and [`multi-clicker.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/a928d03e65b8423f67a49aeaa7cd5d104e065979/utils/multi-clicker.lua).

### Display an alert with a space number and optional label when switching spaces

You can optionally add a label to each space by creating a `spaces.txt` file next to the script. On each line the file should have a label for each space.

See [`display-space-number.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/63265cb6727c9b4633e0823923f8f73c7b5ea6d4/display-space-number.lua).

### Hide system notifications

This hides currently open Notification Center banners and alerts.

See [`other.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/9502e78a3c2cc1ce8d9c92f868ee921cc9d6f398/other.lua) for usage and [`close-notifications.js`](https://github.com/certainlyakey/hammerspoon-config/blob/e114387c44ff0f2fb06215c928f491468c7405d0/jxa-scripts/close-notifications.js).

## App actions

### Confirm quitting (or any action) by pressing a shortcut two times

See [`mail.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/a8e3abc613e86691deaaab654d7dabf95c8a997f/apps/mail.lua) for usage and [`quit-confirmation.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/a8e3abc613e86691deaaab654d7dabf95c8a997f/utils/quit-confirmation.lua).

### Enable Markdown markup in any app

Many apps support Markdown-flavored syntax, but not many implement balancing wrapping characters when something is selected. This script allows to enable "Markdown mode" in any app by pressing a global shortcut and then have the selected text wrapped in backticks, have link markup inserted, etc. depending on an additional key pressed separately.

See [`markdown-mode.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/07bf6b9d92af8d33faf1558b5dc89cbb970fc27c/markdown-mode.lua).

### Love the currently playing song in Apple Music

This works in any app.

See [`system-actions.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/46fbab2f49d624e939fc81c146450bf0a0223fc7/system-actions.lua) for usage and [`get-song.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/5e620e756d56c106f952dc386598edaaeaed7a9c/apple-scripts/get-song.applescript).

## Finder-specific actions

### Open selected file in specific app

This can be useful if you have want to preview or quickly edit a file in a lightweight app without opening a heavier app that the filetype is assigned to by default.

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/c2879420e8366df2903de95b98681df7070fb931/apps/finder.lua) for usage and [`finder-get-file-path.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/3be88381ad4d00087b49f6bdab117a8a12a3273b/apple-scripts/finder-get-file-path.applescript).

### Open current or selected folder in iTerm (or any other app) with same hotkey

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/c2879420e8366df2903de95b98681df7070fb931/apps/finder.lua) for usage and [`get-finder-folder.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/1c9b570a987431c3f90e880ddd260ebae8a36e7a/apple-scripts/get-finder-folder.applescript).

### Copy selected text file contents

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/c2879420e8366df2903de95b98681df7070fb931/apps/finder.lua) for usage and [`finder-copy-file-contents.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/5e620e756d56c106f952dc386598edaaeaed7a9c/apple-scripts/finder-copy-file-contents.applescript).

### Create new file

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/c2879420e8366df2903de95b98681df7070fb931/apps/finder.lua) for usage and [`finder-create-file.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/a8be3f1e6cc5a1af250adf53742fb89db5d311c8/apple-scripts/finder-create-file.applescript).

### Copy path of a folder or file

See [`finder.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/c2879420e8366df2903de95b98681df7070fb931/apps/finder.lua) for usage and [`finder-get-file-path.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/3be88381ad4d00087b49f6bdab117a8a12a3273b/apple-scripts/finder-get-file-path.applescript).

### Eject disk images only with a hotkey

See [`open-folders.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/bb26498aceb0624a30b549cc0e7b5ace30d337e7/open-folders.lua).

## Safari-specific actions

### Display detailed confirmation dialog when quitting

See [`safari.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/2eab4b9e3cefc523cba77d457b4a485c4806a0aa/apps/safari.lua) for usage and [`safari-quit-confirmation.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/99fc9c4300658d14d277ce94c693eaaa19ff9928/apple-scripts/safari-quit-confirmation.applescript).

### Move tab to left/right with a hotkey

Note that due to Safari limitations this will reload the moved tab.

See [`safari.lua`](https://github.com/certainlyakey/hammerspoon-config/blob/2eab4b9e3cefc523cba77d457b4a485c4806a0aa/apps/safari.lua) for usage and [`move-tab-to-left.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/2698041fb227f1f2e69e95fb4fdb1d6f930a01c8/apple-scripts/move-tab-to-left.applescript) and [`move-tab-to-right.applescript`](https://github.com/certainlyakey/hammerspoon-config/blob/2698041fb227f1f2e69e95fb4fdb1d6f930a01c8/apple-scripts/move-tab-to-right.applescript).

