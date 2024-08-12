HouseGUI = {}

local sW, sH = Utils.sW, Utils.sH
local sDW, sDH = Utils.sDW, Utils.sDH

local width, height = 350, 240
local posX, posY = (sDW-width) /2, (sDH-height) /2

local _houseData = nil

function HouseGUI.renderInfoHouseWindow()
    local isSell = (not _houseData.owner) and true or false
    local height = isSell and height + 80 or height

    _houseData.owner = _houseData.owner or 'государство'

    HouseGUI.wnd = guiCreateWindow(sW*(posX/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(HouseGUI.wnd)
    guiWindowSetSizable(HouseGUI.wnd, false)
    guiWindowSetMovable(HouseGUI.wnd, false)
    HouseGUI.wnd.alpha = 0.8

    HouseGUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, HouseGUI.wnd)
    guiSetFont(HouseGUI.btnClose, Utils.fonts.RR_10)
    guiSetProperty(HouseGUI.btnClose, "NormalTextColour", "FFCE070B")

    local offsetPosY = 35

    addEventHandler("onClientGUIClick", HouseGUI.btnClose, HouseGUI.closeWindow, false)
    HouseGUI.lblHome = guiCreateLabel(0, sH*((offsetPosY)/sDH), sW*(width/sDW), 30, "Информация о доме", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHome, "center", false)
    guiSetFont(HouseGUI.lblHome, Utils.fonts.RB_11)
    HouseGUI.lblHome.enabled = false

    --
    offsetPosY = offsetPosY + 45
    HouseGUI.lblHomeNumber = guiCreateLabel(15, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, "Номер дома:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeNumber, "left", false)
    guiSetFont(HouseGUI.lblHomeNumber, Utils.fonts.RR_11)
    HouseGUI.lblHomeNumber.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeNumber)+5
    HouseGUI.lblHomeNumber = guiCreateLabel(15+offsetX, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, _houseData.houseId, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeNumber, "left", false)
    guiSetFont(HouseGUI.lblHomeNumber, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeNumber, 242, 171, 18)
    HouseGUI.lblHomeNumber.enabled = false

    --
    offsetPosY = offsetPosY + 25
    HouseGUI.lblHomeOwner = guiCreateLabel(15, sH*((offsetPosY)/sDH), sW*(width/sDW), 30, "Владелец:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeOwner, "left", false)
    guiSetFont(HouseGUI.lblHomeOwner, Utils.fonts.RR_11)
    HouseGUI.lblHomeOwner.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeOwner)+5
    HouseGUI.lblHomeOwner = guiCreateLabel(15+offsetX, sH*((offsetPosY)/sDH), sW*(width/sDW), 30, _houseData.owner, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeOwner, "left", false)
    guiSetFont(HouseGUI.lblHomeOwner, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeOwner, 242, 171, 18)
    HouseGUI.lblHomeOwner.enabled = false

    --
    offsetPosY = offsetPosY + 25
    HouseGUI.lblHomeClass = guiCreateLabel(15, sH*((offsetPosY)/sDH), sW*(width/sDW), 30, "Класс:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeClass, "left", false)
    guiSetFont(HouseGUI.lblHomeClass, Utils.fonts.RR_11)
    HouseGUI.lblHomeClass.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeClass)+5
    HouseGUI.lblHomeClass = guiCreateLabel(15+offsetX, sH*((offsetPosY)/sDH), sW*(width/sDW), 30, _houseData.class, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeClass, "left", false)
    guiSetFont(HouseGUI.lblHomeClass, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeClass, 242, 171, 18)
    HouseGUI.lblHomeClass.enabled = false

    --
    offsetPosY = offsetPosY + 25
    HouseGUI.lblHomeSpaces = guiCreateLabel(15, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, "Парковачных мест:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomeSpaces, Utils.fonts.RR_11)
    HouseGUI.lblHomeSpaces.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeSpaces)+5
    HouseGUI.lblHomeSpaces = guiCreateLabel(15+offsetX, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, _houseData.parkingSpaces, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomeSpaces, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeSpaces, 242, 171, 18)
    HouseGUI.lblHomeSpaces.enabled = false

    --
    offsetPosY = offsetPosY + 25
    HouseGUI.lblHomePrice = guiCreateLabel(15, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, "Цена:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomePrice, Utils.fonts.RR_11)
    HouseGUI.lblHomePrice.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomePrice)+10
    HouseGUI.lblHomePrice = Utils.guiCreateMoneyLabel(15+offsetX, sH*((offsetPosY) /sDH), _houseData.formattedPrice, HouseGUI.wnd)
    guiSetFont(HouseGUI.lblHomePrice, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomePrice, 242, 171, 18)
    HouseGUI.lblHomePrice.enabled = false

    if isSell then
        HouseGUI.btnBuy = guiCreateButton(sW*(0/sDW), sH*((height-95)/sDH), sW*(width/sDW), sH*(40/sDH), "Купить", false, HouseGUI.wnd)
        guiSetFont(HouseGUI.btnBuy, Utils.fonts.RR_10)
        guiSetProperty(HouseGUI.btnBuy, "NormalTextColour", "FF01D51A")
        addEventHandler("onClientGUIClick", HouseGUI.btnBuy, HouseGUI.onPlayerBuyHouse, false)
    end

    HouseGUI.btnEnter = guiCreateButton(sW*(0/sDW), sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), "Войти в дом", false, HouseGUI.wnd)
    guiSetFont(HouseGUI.btnEnter, Utils.fonts.RR_10)
    addEventHandler("onClientGUIClick", HouseGUI.btnEnter, 
        function()
            House.enter(tonumber(_houseData.houseId))
        end, false
    )
end

function HouseGUI.renderManagerHouseWindow()
    local height = height + 170

    HouseGUI.wnd = guiCreateWindow(sW*(posX/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(HouseGUI.wnd)
    guiWindowSetSizable(HouseGUI.wnd, false)
    guiWindowSetMovable(HouseGUI.wnd, false)
    HouseGUI.wnd.alpha = 0.8

    HouseGUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(25/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, HouseGUI.wnd)
    guiSetFont(HouseGUI.btnClose, Utils.fonts.RR_10)
    guiSetProperty(HouseGUI.btnClose, "NormalTextColour", "FFCE070B")

    HouseGUI.lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(25/sDH), sW*(width/sDW), sH*(30/sDH), "Мой дом", false, HouseGUI.wnd)
    guiSetFont(HouseGUI.lblTitle, Utils.fonts.RB_10)
    guiLabelSetVerticalAlign(HouseGUI.lblTitle, "center", false)
    HouseGUI.lblTitle.enabled = false

    --
    local offsetPosY = 45
    local line = guiCreateLabel(0, sH*((offsetPosY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    offsetPosY = offsetPosY + 25
    addEventHandler("onClientGUIClick", HouseGUI.btnClose, HouseGUI.closeWindow, false)
    HouseGUI.lblHome = guiCreateLabel(0, sH*((offsetPosY)/sDH), sW*(width/sDW), 30, "ОБЩАЯ ИНФОРМАЦИЯ", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHome, "center", false)
    guiSetFont(HouseGUI.lblHome, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHome, 242, 171, 18)
    HouseGUI.lblHome.enabled = false

    --
    offsetPosY = offsetPosY + 35
    HouseGUI.lblHomeNumber = guiCreateLabel(15, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, "Номер дома:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeNumber, "left", false)
    guiSetFont(HouseGUI.lblHomeNumber, Utils.fonts.RR_11)
    HouseGUI.lblHomeNumber.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeNumber)+5
    HouseGUI.lblHomeNumber = guiCreateLabel(15+offsetX, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, _houseData.houseId, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeNumber, "left", false)
    guiSetFont(HouseGUI.lblHomeNumber, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeNumber, 242, 171, 18)
    HouseGUI.lblHomeNumber.enabled = false
    
    --
    offsetPosY = offsetPosY + 25
    HouseGUI.lblHomeClass = guiCreateLabel(15, sH*((offsetPosY)/sDH), sW*(width/sDW), 30, "Класс:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeClass, "left", false)
    guiSetFont(HouseGUI.lblHomeClass, Utils.fonts.RR_11)
    HouseGUI.lblHomeClass.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeClass)+5
    HouseGUI.lblHomeClass = guiCreateLabel(15+offsetX, sH*((offsetPosY)/sDH), sW*(width/sDW), 30, _houseData.class, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeClass, "left", false)
    guiSetFont(HouseGUI.lblHomeClass, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeClass, 242, 171, 18)
    HouseGUI.lblHomeClass.enabled = false

    --
    offsetPosY = offsetPosY + 25
    HouseGUI.lblHomeSpaces = guiCreateLabel(15, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, "Парковачных мест:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomeSpaces, Utils.fonts.RR_11)
    HouseGUI.lblHomeSpaces.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeSpaces)+5
    HouseGUI.lblHomeSpaces = guiCreateLabel(15+offsetX, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, _houseData.parkingSpaces, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomeSpaces, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeSpaces, 242, 171, 18)
    HouseGUI.lblHomeSpaces.enabled = false

    --
    offsetPosY = offsetPosY + 25
    HouseGUI.lblHomePrice = guiCreateLabel(15, sH*((offsetPosY) /sDH), sW*(width/sDW), 30, "Гос. цена:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomePrice, Utils.fonts.RR_11)
    HouseGUI.lblHomePrice.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomePrice)+10
    HouseGUI.lblHomePrice = Utils.guiCreateMoneyLabel(15+offsetX, sH*((offsetPosY) /sDH), _houseData.formattedPrice, HouseGUI.wnd)
    guiSetFont(HouseGUI.lblHomePrice, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomePrice, 242, 171, 18)
    HouseGUI.lblHomePrice.enabled = false
    
    --
    offsetPosY = offsetPosY + 35
    local line = guiCreateLabel(0, sH*((offsetPosY)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)

    offsetPosY = offsetPosY + 20
    local lblHouse = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), 30, 'УПРАВЛЕНИЕ ДОМОМ', false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(lblHouse, "center", false)
    guiSetFont(lblHouse, Utils.fonts.RB_11)
    guiLabelSetColor(lblHouse, 242, 171, 18)
    lblHouse.enabled = false

    offsetPosY = offsetPosY + 25
    HouseGUI.btnSell = guiCreateButton(sW*(0/sDW), sH*((offsetPosY)/sDH), sW*(width/sDW), sH*(40/sDH), 'Продать дом', false, HouseGUI.wnd)
    guiSetFont(HouseGUI.btnSell, Utils.fonts.RB_10)
    guiSetProperty(HouseGUI.btnSell, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", HouseGUI.btnSell, HouseGUI.onPlayerSellHouse, false)

    --
    local line = guiCreateLabel(0, sH*((height-80)/sDH), sW*(width/sDW), sH*(30/sDH), ('_'):rep(width/4), false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(line, "center")
    guiSetFont(line, "default-bold-small")
    guiLabelSetColor(line, 105, 105, 105)
    guiSetEnabled(line, false)
    
    HouseGUI.btnEnter = guiCreateButton(sW*(0/sDW), sH*((height-50)/sDH), sW*(width/sDW), sH*(40/sDH), "Войти в дом", false, HouseGUI.wnd)
    guiSetFont(HouseGUI.btnEnter, Utils.fonts.RR_10)
    addEventHandler("onClientGUIClick", HouseGUI.btnEnter, 
        function()
            House.enter(tonumber(_houseData.houseId))
        end, false
    )
end

function HouseGUI.onPlayerBuyHouse()
    HouseGUI.wnd.visible = false

    local message = string.format("Вы хотите приобрести дом №%s за %s ₽ ?", _houseData.houseId, exports.tmtaUtils:formatMoney(_houseData.price))
    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onHouseConfirmWindowBuy', 'onHouseConfirmWindowCancel', 'onHouseConfirmWindowClose')
    exports.tmtaGUI:setBtnOkLabel(confirmWindow, 'Купить')
end

function HouseGUI.onPlayerSellHouse()
    HouseGUI.wnd.visible = false

    local price = tonumber(_houseData.price - (_houseData.price * Config.SELL_COMMISSION/100))
    local message = string.format("Вы действительно хотите продать дом государству за %s ₽ ?", exports.tmtaUtils:formatMoney(price))
    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onHouseConfirmWindowSell', 'onHouseConfirmWindowCancel', 'onHouseConfirmWindowClose')
    exports.tmtaGUI:setBtnOkLabel(confirmWindow, 'Продать')
end

function HouseGUI.openWindow(houseData)
    if (type(houseData) ~= 'table' or isElement(HouseGUI.wnd)) then
        return
    end
    _houseData = houseData

    if (_houseData.owner) then
        if (_houseData.owner ~= localPlayer:getData('nickname')) then
            return
        end
        HouseGUI.renderManagerHouseWindow()
    else
        HouseGUI.renderInfoHouseWindow()
    end

    showCursor(true)
    showChat(false)
    exports.tmtaUI:setPlayerBlurScreen(true)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end

function HouseGUI.closeWindow()
    if (not isElement(HouseGUI.wnd)) then
        return
    end

    HouseGUI.wnd.visible = false
    setTimer(destroyElement, 100, 1, HouseGUI.wnd)
    showCursor(false)
    showChat(true)
    exports.tmtaUI:setPlayerBlurScreen(false)
    exports.tmtaUI:setPlayerComponentVisible("all", true)
end

function onHouseConfirmWindowBuy()
    HouseGUI.closeWindow()
    House.buy(tonumber(_houseData.houseId))
end

function onHouseConfirmWindowSell()
    HouseGUI.closeWindow()
    House.sell(tonumber(_houseData.houseId))
end

function onHouseConfirmWindowClose()
    return HouseGUI.closeWindow()
end

function onHouseConfirmWindowCancel()
    HouseGUI.wnd.visible = true
end