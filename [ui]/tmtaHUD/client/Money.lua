Money = {}
Money.visible = false

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local isChangeMoney = false
local interpolateOldMoney = 0
local interpolateNewMoney = 0

local tempChangeMoney = 0

local countMoneyColor = {255, 0, 0} -- цвет для счетчика денег
local countMoneyAmount = 0 -- количество денег для счетчика денег
local countMoneySign = "+" -- знак для счетчика денег

local moneyChangeTimer = 2000 -- время изменения денег (дефолтное)
local timeToChangeStart = 1000 -- через сколько мс начать изменять деньги
local moneyChangeTimeStart = 0 -- когда началось изменение денег

local isTimerStopChangeMoney

local TextureMoney = exports.tmtaTextures:createTexture('i_money')
local FontMoney = exports.tmtaFonts:createFontDX("GothamProBold", 16, false, "antialiased")

function Money.draw(posX, posY)
    -- MONEY
    local PLAYER_MONEY = exports.tmtaMoney:getPlayerMoney()
    PLAYER_MONEY = PLAYER_MONEY -tempChangeMoney +math.floor(interpolateOldMoney)

    local money = exports.tmtaUtils:formatMoney(PLAYER_MONEY)
    local textMoneyWidth = dxGetTextWidth(money, sW/sDW*1.0, FontMoney)

    
    dxDrawImage(sW*((posX) /sDW)-textMoneyWidth-sW*((32) /sDW)-20, sH*((posY) /sDH), sW*((32) /sDW), sH*((28) /sDH), TextureMoney, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText(money, sW*((posX) /sDW), sH*((posY) /sDH), sW*((posX-10) /sDW), sH*((posY+28) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, FontMoney, "right", "center")

    -- Анимация выдачи денег
    if isChangeMoney then
        interpolateOldMoney = interpolateBetween(0, 0, 0, countMoneyAmount, 0, 0, (getTickCount()-moneyChangeTimeStart)/moneyChangeTimer, "Linear")
        interpolateNewMoney = interpolateBetween(math.abs(countMoneyAmount), 0, 0, 0, 0, 0, (getTickCount()-moneyChangeTimeStart)/moneyChangeTimer, "Linear")
    end

    if interpolateNewMoney > 0 then
        dxDrawText(
            countMoneySign..''..math.floor(interpolateNewMoney), 
            sW*((posX) /sDW), sH*((posY+60) /sDH), 
            sW*((posX-10) /sDW), sH*((posY+28) /sDH), 
            tocolor(countMoneyColor[1], countMoneyColor[2], countMoneyColor[3], 155), 
            sW/sDW*1.0, FontMoney, 
            "right", "center"
        )
    end
end

local function startChangeAmountMoney(amount)
    if isTimer(isTimerStopChangeMoney) then
        killTimer(isTimerStopChangeMoney)
        amount = tempChangeMoney + amount
    end

    tempChangeMoney = amount
    if tempChangeMoney < 0 then
        countMoneyColor = {255, 0, 0}
        countMoneySign = "-"
    else
        countMoneyColor = {0, 255, 0}
        countMoneySign = "+"
    end

    countMoneyAmount = amount -- может быть и отрицательное число 
    moneyChangeTimer = (math.abs(amount) < moneyChangeTimer) and moneyChangeTimer or math.abs(amount*0.05)
    interpolateNewMoney = math.abs(amount)

    -- Начать изменять количество денег
    setTimer(
        function()
            moneyChangeTimeStart = getTickCount()
            isChangeMoney = true
        end, timeToChangeStart, 1)
    
    -- Завершение смены денег
    isTimerStopChangeMoney = setTimer(
        function()
            isChangeMoney = false
            interpolateOldMoney = 0
            interpolateNewMoney = 0
            countMoneyAmount = 0
            tempChangeMoney = 0
        end, moneyChangeTimer + timeToChangeStart, 1)
end

addEventHandler("tmtaMoney.onPlayerGiveMoney", root, function(amount)
    startChangeAmountMoney(amount)
end)

addEventHandler("tmtaMoney.onPlayerTakeMoney", root, function(amount)
    startChangeAmountMoney(-math.ceil(amount))
end)

function Money.show(posX, posY)
    if type(posX) ~= 'number' or type(posY) ~= 'number' then
        outputDebugString('Money.show: bad arguments', 1)
        return false
    end

    if Money.visible then
        return false
    end

    moneyDraw = function() Money.draw(posX, posY) end
    addEventHandler('onClientHUDRender', root, moneyDraw, false)

    Money.visible = true
    return true
end

function Money.hide()
    if not Money.visible then
        return false
    end

    removeEventHandler('onClientHUDRender', root, moneyDraw)
    
    Money.visible = false
    return true
end

-- Exports
moneyShow = Money.show
moneyHide = Money.hide