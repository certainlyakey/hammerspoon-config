local replaceTextSelection = require('../utils/replace-text-selection')
local globals = require('globals')

-- Shortcut: Convert keyboard layout of text selection En<->Ru
hs.hotkey.bind({'ctrl', 'shift'}, 'p', function()
  replaceTextSelection(function(selectedText)
    local layout = hs.keycodes.currentLayout()

    if layout == globals.keyboardLayoutEn then
      selectedText = string.gsub(selectedText, 'q', 'й')
      selectedText = string.gsub(selectedText, 'Q', 'Й')
      selectedText = string.gsub(selectedText, 'w', 'ц')
      selectedText = string.gsub(selectedText, 'W', 'Ц')
      selectedText = string.gsub(selectedText, 'e', 'у')
      selectedText = string.gsub(selectedText, 'E', 'У')
      selectedText = string.gsub(selectedText, 'r', 'к')
      selectedText = string.gsub(selectedText, 'R', 'К')
      selectedText = string.gsub(selectedText, 't', 'е')
      selectedText = string.gsub(selectedText, 'T', 'Е')
      selectedText = string.gsub(selectedText, 'y', 'н')
      selectedText = string.gsub(selectedText, 'Y', 'Н')
      selectedText = string.gsub(selectedText, 'u', 'г')
      selectedText = string.gsub(selectedText, 'U', 'Г')
      selectedText = string.gsub(selectedText, 'i', 'ш')
      selectedText = string.gsub(selectedText, 'I', 'Ш')
      selectedText = string.gsub(selectedText, 'o', 'щ')
      selectedText = string.gsub(selectedText, 'O', 'Щ')
      selectedText = string.gsub(selectedText, 'p', 'з')
      selectedText = string.gsub(selectedText, 'P', 'З')
      selectedText = string.gsub(selectedText, 'a', 'ф')
      selectedText = string.gsub(selectedText, 'A', 'Ф')
      selectedText = string.gsub(selectedText, 's', 'ы')
      selectedText = string.gsub(selectedText, 'S', 'Ы')
      selectedText = string.gsub(selectedText, 'd', 'в')
      selectedText = string.gsub(selectedText, 'D', 'В')
      selectedText = string.gsub(selectedText, 'f', 'а')
      selectedText = string.gsub(selectedText, 'F', 'А')
      selectedText = string.gsub(selectedText, 'g', 'п')
      selectedText = string.gsub(selectedText, 'G', 'П')
      selectedText = string.gsub(selectedText, 'h', 'р')
      selectedText = string.gsub(selectedText, 'H', 'Р')
      selectedText = string.gsub(selectedText, 'j', 'о')
      selectedText = string.gsub(selectedText, 'J', 'О')
      selectedText = string.gsub(selectedText, 'k', 'л')
      selectedText = string.gsub(selectedText, 'K', 'Л')
      selectedText = string.gsub(selectedText, 'l', 'д')
      selectedText = string.gsub(selectedText, 'L', 'Д')
      selectedText = string.gsub(selectedText, 'z', 'я')
      selectedText = string.gsub(selectedText, 'Z', 'Я')
      selectedText = string.gsub(selectedText, 'x', 'ч')
      selectedText = string.gsub(selectedText, 'X', 'Ч')
      selectedText = string.gsub(selectedText, 'c', 'с')
      selectedText = string.gsub(selectedText, 'C', 'С')
      selectedText = string.gsub(selectedText, 'v', 'м')
      selectedText = string.gsub(selectedText, 'V', 'М')
      selectedText = string.gsub(selectedText, 'b', 'и')
      selectedText = string.gsub(selectedText, 'B', 'И')
      selectedText = string.gsub(selectedText, 'n', 'т')
      selectedText = string.gsub(selectedText, 'N', 'Т')
      selectedText = string.gsub(selectedText, 'm', 'ь')
      selectedText = string.gsub(selectedText, 'M', 'Ь')
      selectedText = string.gsub(selectedText, '%[', 'х')
      selectedText = string.gsub(selectedText, '{', 'Х')
      selectedText = string.gsub(selectedText, ']', 'ъ')
      selectedText = string.gsub(selectedText, '}', 'Ъ')
      selectedText = string.gsub(selectedText, ';', 'ж')
      selectedText = string.gsub(selectedText, ':', 'Ж')
      selectedText = string.gsub(selectedText, '\'', 'э')
      selectedText = string.gsub(selectedText, '"', 'Э')
      selectedText = string.gsub(selectedText, ',', 'б')
      selectedText = string.gsub(selectedText, '<', 'Б')
      selectedText = string.gsub(selectedText, '%.', 'ю')
      selectedText = string.gsub(selectedText, '>', 'Ю')
      selectedText = string.gsub(selectedText, '/', '.')
      selectedText = string.gsub(selectedText, '%?', ',')
    
      hs.keycodes.setLayout(globals.keyboardLayoutRu)
    else
      selectedText = string.gsub(selectedText, 'й', 'q')
      selectedText = string.gsub(selectedText, 'Й', 'Q')
      selectedText = string.gsub(selectedText, 'ц', 'w')
      selectedText = string.gsub(selectedText, 'Ц', 'W')
      selectedText = string.gsub(selectedText, 'у', 'e')
      selectedText = string.gsub(selectedText, 'У', 'E')
      selectedText = string.gsub(selectedText, 'к', 'r')
      selectedText = string.gsub(selectedText, 'К', 'R')
      selectedText = string.gsub(selectedText, 'е', 't')
      selectedText = string.gsub(selectedText, 'Е', 'T')
      selectedText = string.gsub(selectedText, 'н', 'y')
      selectedText = string.gsub(selectedText, 'Н', 'Y')
      selectedText = string.gsub(selectedText, 'г', 'u')
      selectedText = string.gsub(selectedText, 'Г', 'U')
      selectedText = string.gsub(selectedText, 'ш', 'i')
      selectedText = string.gsub(selectedText, 'Ш', 'I')
      selectedText = string.gsub(selectedText, 'щ', 'o')
      selectedText = string.gsub(selectedText, 'Щ', 'O')
      selectedText = string.gsub(selectedText, 'з', 'p')
      selectedText = string.gsub(selectedText, 'З', 'P')
      selectedText = string.gsub(selectedText, 'ф', 'a')
      selectedText = string.gsub(selectedText, 'Ф', 'A')
      selectedText = string.gsub(selectedText, 'ы', 's')
      selectedText = string.gsub(selectedText, 'Ы', 'S')
      selectedText = string.gsub(selectedText, 'в', 'd')
      selectedText = string.gsub(selectedText, 'В', 'D')
      selectedText = string.gsub(selectedText, 'а', 'f')
      selectedText = string.gsub(selectedText, 'А', 'F')
      selectedText = string.gsub(selectedText, 'п', 'g')
      selectedText = string.gsub(selectedText, 'П', 'G')
      selectedText = string.gsub(selectedText, 'р', 'h')
      selectedText = string.gsub(selectedText, 'Р', 'H')
      selectedText = string.gsub(selectedText, 'о', 'j')
      selectedText = string.gsub(selectedText, 'О', 'J')
      selectedText = string.gsub(selectedText, 'л', 'k')
      selectedText = string.gsub(selectedText, 'Л', 'K')
      selectedText = string.gsub(selectedText, 'д', 'l')
      selectedText = string.gsub(selectedText, 'Д', 'L')
      selectedText = string.gsub(selectedText, 'я', 'z')
      selectedText = string.gsub(selectedText, 'Я', 'Z')
      selectedText = string.gsub(selectedText, 'ч', 'x')
      selectedText = string.gsub(selectedText, 'Ч', 'X')
      selectedText = string.gsub(selectedText, 'с', 'c')
      selectedText = string.gsub(selectedText, 'С', 'C')
      selectedText = string.gsub(selectedText, 'м', 'v')
      selectedText = string.gsub(selectedText, 'М', 'V')
      selectedText = string.gsub(selectedText, 'и', 'b')
      selectedText = string.gsub(selectedText, 'И', 'B')
      selectedText = string.gsub(selectedText, 'т', 'n')
      selectedText = string.gsub(selectedText, 'Т', 'N')
      selectedText = string.gsub(selectedText, 'ь', 'm')
      selectedText = string.gsub(selectedText, 'Ь', 'M')
      selectedText = string.gsub(selectedText, 'х', '[')
      selectedText = string.gsub(selectedText, 'Х', '{')
      selectedText = string.gsub(selectedText, 'ъ', ']')
      selectedText = string.gsub(selectedText, 'Ъ', '}')
      selectedText = string.gsub(selectedText, 'ж', ';')
      selectedText = string.gsub(selectedText, 'Ж', ':')
      selectedText = string.gsub(selectedText, 'э', '\'')
      selectedText = string.gsub(selectedText, 'Э', '"')
      selectedText = string.gsub(selectedText, 'б', ',')
      selectedText = string.gsub(selectedText, 'Б', '<')
      selectedText = string.gsub(selectedText, 'ю', '.')
      selectedText = string.gsub(selectedText, 'Ю', '>')
      
      hs.keycodes.setLayout(globals.keyboardLayoutEn)
    end

    return selectedText
  end)
end)
