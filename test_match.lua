local function check(str)
    local hasLower = str:match("[%aа-яё]")
    local hasUpper = str:match("[%AА-ЯЁ]")
    print(str, "hasLower:", hasLower ~= nil, "hasUpper:", hasUpper ~= nil)
end

check("btw ")
check("Btw ")
check("BTW ")
check("пжл ")
check("Пжл ")
check("ПЖЛ ")
