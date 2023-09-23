-- From https://github.com/jasonrudolph/keyboard/blob/e5e351f1cc80f62cca2ce688a5d4a3dd7f3a4b36/hammerspoon/markdown.lua
local isAppFocused = require('../utils/is-app-focused')
local globals = require('globals')

local keyUpDown = function(modifiers, key)
  -- Un-comment & reload config to log each keystroke that we're triggering
  -- log.d('Sending keystroke:', hs.inspect(modifiers), key)

  hs.eventtap.keyStroke(modifiers, key, 0)
end

local function wrapSelectedText(wrapCharacters)
  -- Preserve the current contents of the system clipboard
  local originalClipboardContents = hs.pasteboard.getContents()

  -- Copy the currently-selected text to the system clipboard
  keyUpDown('cmd', 'c')

  -- Allow some time for the command+c keystroke to fire asynchronously before
  -- we try to read from the clipboard
  hs.timer.doAfter(0.2, function()
    -- Construct the formatted output and paste it over top of the
    -- currently-selected text
    local selectedText = hs.pasteboard.getContents()
    local wrappedText = wrapCharacters .. selectedText .. wrapCharacters
    hs.pasteboard.setContents(wrappedText)
    keyUpDown('cmd', 'v')

    -- Allow some time for the command+v keystroke to fire asynchronously before
    -- we restore the original clipboard
    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(originalClipboardContents)
    end)
  end)

  hs.timer.doAfter(0.4, function()
    if isAppFocused('Microsoft Teams') then
      keyUpDown('', 'delete')
      hs.eventtap.keyStrokes(wrapCharacters)
    end
  end)

end

local function inlineLink()
  -- Fetch URL from the system clipboard
  local linkUrl = hs.pasteboard.getContents()

  -- Copy the currently-selected text to use as the link text
  keyUpDown('cmd', 'c')

  -- Allow some time for the command+c keystroke to fire asynchronously before
  -- we try to read from the clipboard
  hs.timer.doAfter(0.2, function()
    -- Construct the formatted output and paste it over top of the
    -- currently-selected text
    local linkText = hs.pasteboard.getContents()
    local markdown = '[' .. linkText .. '](' .. linkUrl .. ')'
    hs.pasteboard.setContents(markdown)
    keyUpDown('cmd', 'v')

    -- Allow some time for the command+v keystroke to fire asynchronously before
    -- we restore the original clipboard
    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(linkUrl)
    end)
  end)
end

--------------------------------------------------------------------------------
-- Define Markdown Mode
--
-- Markdown Mode allows you to perform common Markdown-formatting tasks anywhere
-- that you're editing text. Use Control+m to turn on Markdown mode. Then, use
-- any shortcut below to perform a formatting action. For example, to format the
-- selected text as bold in Markdown, hit Control+m, and then b.
--
--   b => wrap the selected text in double asterisks ("b" for "bold")
--   c => wrap the selected text in backticks ("c" for "code")
--   i => wrap the selected text in single asterisks ("i" for "italic")
--   s => wrap the selected text in double tildes ("s" for "strikethrough")
--   l => convert the currently-selected text to an inline link, using a URL
--        from the clipboard ("l" for "link")
--------------------------------------------------------------------------------

local markdownMode = hs.hotkey.modal.new({}, 'F20')

markdownMode.entered = function()
  hs.alert.show('Markdown mode started', globals.alertStyle)
end
markdownMode.exited = function()
  hs.timer.doAfter(2, function()
    hs.alert.show('Markdown mode exited', globals.alertStyle)
  end)
end

-- Bind the given key to call the given function and exit Markdown mode
function markdownMode.bindWithAutomaticExit(mode, mods, key, fn)
  mode:bind(mods, key, function()
    mode:exit()
    fn()
  end)
end

markdownMode:bindWithAutomaticExit({}, 'b', function()
  wrapSelectedText('*')
end)

markdownMode:bindWithAutomaticExit({}, 'i', function()
  wrapSelectedText('_')
end)

markdownMode:bindWithAutomaticExit({}, 's', function()
  wrapSelectedText('~')
end)

markdownMode:bindWithAutomaticExit({}, '\'', function()
  wrapSelectedText('\'')
end)

markdownMode:bindWithAutomaticExit({'shift'}, '\'', function()
  wrapSelectedText('"')
end)

markdownMode:bindWithAutomaticExit({'cmd'}, 'v', function()
  inlineLink()
end)

markdownMode:bindWithAutomaticExit({}, '`', function()
  wrapSelectedText('`')
end)

-- Use Control+m to toggle Markdown Mode
hs.hotkey.bind({'ctrl'}, 'm', function()
  markdownMode:enter()
end)
markdownMode:bind({'ctrl'}, 'm', function()
  markdownMode:exit()
end)
