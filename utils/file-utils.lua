local util = {}

function util.fileExists(file)
  local f = io.open(file, 'rb')
  if f then f:close() end
  return f ~= nil
end

function util.linesInFile(file)
  if not util.fileExists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

return util
