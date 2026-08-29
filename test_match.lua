local str = "пжл "
local hasUpper = str:match("[%uА-ЯЁ]")
print("Testing:", str)
print("hasUpper:", hasUpper)

local c1 = str:sub(1,1)
local c2 = str:sub(2,2)
print("byte1:", string.byte(c1), "byte2:", string.byte(c2))

local map = "[%uА-ЯЁ]"
print("match byte1:", c1:match(map))
print("match byte2:", c2:match(map))
