HouseGUI = {}

local sW, sH = Utils.sW, Utils.sH
local sDW, sDH = Utils.sDW, Utils.sDH

local width, height = 400, 280
local posX, posY = (sDW-width) /2, (sDH-height) /2

local _houseData = nil

function HouseGUI.render()
    local isSell = (not _houseData.owner) and true or false
    _houseData.owner = _houseData.owner or 'государство'
    local height = isSell and height+40 or height

    HouseGUI.wnd = guiCreateWindow(sW*(posX/sDW), sH*(posY/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(HouseGUI.wnd)
    guiWindowSetSizable(HouseGUI.wnd, false)
    guiWindowSetMovable(HouseGUI.wnd, false)
    HouseGUI.wnd.alpha = 0.8
    
    --
    HouseGUI.lblHome = guiCreateLabel(0, sH*(35/sDH), sW*(width/sDW), 30, "Информация о доме", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHome, "center", false)
    guiSetFont(HouseGUI.lblHome, Utils.fonts.RB_11)
    HouseGUI.lblHome.enabled = false

    --
    HouseGUI.lblHomeNumber = guiCreateLabel(15, sH*(80/sDH), sW*(width/sDW), 30, "Номер дома:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeNumber, "left", false)
    guiSetFont(HouseGUI.lblHomeNumber, Utils.fonts.RR_11)
    HouseGUI.lblHomeNumber.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeNumber)+5
    HouseGUI.lblHomeNumber = guiCreateLabel(15+offsetX, sH*(80/sDH), sW*(width/sDW), 30, _houseData.number, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeNumber, "left", false)
    guiSetFont(HouseGUI.lblHomeNumber, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeNumber, 242, 171, 18)
    HouseGUI.lblHomeNumber.enabled = false

    --
    HouseGUI.lblHomeOwner = guiCreateLabel(15, sH*(105/sDH), sW*(width/sDW), 30, "Владелец:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeOwner, "left", false)
    guiSetFont(HouseGUI.lblHomeOwner, Utils.fonts.RR_11)
    HouseGUI.lblHomeOwner.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeOwner)+5
    HouseGUI.lblHomeOwner = guiCreateLabel(15+offsetX, sH*(105/sDH), sW*(width/sDW), 30, _houseData.owner, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeOwner, "left", false)
    guiSetFont(HouseGUI.lblHomeOwner, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeOwner, 242, 171, 18)
    HouseGUI.lblHomeOwner.enabled = false

    --
    HouseGUI.lblHomeClass = guiCreateLabel(15, sH*(130/sDH), sW*(width/sDW), 30, "Класс:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeClass, "left", false)
    guiSetFont(HouseGUI.lblHomeClass, Utils.fonts.RR_11)
    HouseGUI.lblHomeClass.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeClass)+5
    HouseGUI.lblHomeClass = guiCreateLabel(15+offsetX, sH*(130/sDH), sW*(width/sDW), 30, _houseData.class, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeClass, "left", false)
    guiSetFont(HouseGUI.lblHomeClass, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeClass, 242, 171, 18)
    HouseGUI.lblHomeClass.enabled = false

    --
    HouseGUI.lblHomeSpaces = guiCreateLabel(15, sH*(155/sDH), sW*(width/sDW), 30, "Парковачных мест:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomeSpaces, Utils.fonts.RR_11)
    HouseGUI.lblHomeSpaces.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomeSpaces)+5
    HouseGUI.lblHomeSpaces = guiCreateLabel(15+offsetX, sH*(155/sDH), sW*(width/sDW), 30, _houseData.parkingSpaces, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomeSpaces, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomeSpaces, 242, 171, 18)
    HouseGUI.lblHomeSpaces.enabled = false
    --
    HouseGUI.lblHomePrice = guiCreateLabel(15, sH*(180/sDH), sW*(width/sDW), 30, "Цена:", false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomeSpaces, "left", false)
    guiSetFont(HouseGUI.lblHomePrice, Utils.fonts.RR_11)
    HouseGUI.lblHomePrice.enabled = false

    local offsetX = guiLabelGetTextExtent(HouseGUI.lblHomePrice)+10
    HouseGUI.iconMoney = exports.tmtaTextures:createStaticImage(15+offsetX, sH*((180)/sDH), sW*(32 /sDW), sH*(28 /sDH), 'i_money', false, HouseGUI.wnd)
    HouseGUI.iconMoney.enabled = false

    HouseGUI.lblHomePrice = guiCreateLabel(15+offsetX+32+5, sH*((180+5)/sDH), sW*(width/sDW), 30, _houseData.price, false, HouseGUI.wnd)
    guiLabelSetHorizontalAlign(HouseGUI.lblHomePrice, "left", false)
    guiSetFont(HouseGUI.lblHomePrice, Utils.fonts.RB_11)
    guiLabelSetColor(HouseGUI.lblHomePrice, 242, 171, 18)
    HouseGUI.lblHomePrice.enabled = false

    -- Кнопки
    if isSell then
        HouseGUI.btnBuy = guiCreateButton(sW*(0/sDW), sH*((height-95)/sDH), sW*(width/sDW), sH*(40/sDH), "Купить", false, HouseGUI.wnd)
        guiSetFont(HouseGUI.btnBuy, Utils.fonts.RR_10)
        guiSetProperty(HouseGUI.btnBuy, "NormalTextColour", "FF01D51A")
        addEventHandler("onClientGUIClick", HouseGUI.btnBuy, HouseGUI.onPlayerBuyHouse, false)
    else
        HouseGUI.btnSell = guiCreateButton(sW*(0/sDW), sH*((height-95)/sDH), sW*(width/sDW), sH*(40/sDH), "Продать", false, HouseGUI.wnd)
        guiSetFont(HouseGUI.btnSell, Utils.fonts.RR_10)
        addEventHandler("onClientGUIClick", HouseGUI.btnSell, HouseGUI.onPlayerSellHouse, false)
    end
    
    HouseGUI.btnEnter = guiCreateButton(sW*(0/sDW), sH*((height-50)/sDH), sW*((width+40)/2/sDW), sH*(40/sDH), "Войти в дом", false, HouseGUI.wnd)
    guiSetFont(HouseGUI.btnEnter, Utils.fonts.RR_10)
    guiSetProperty(HouseGUI.btnEnter, "NormalTextColour", "FF01D51A")
    addEventHandler("onClientGUIClick", HouseGUI.btnEnter, 
        function()
            House.enter(tonumber(_houseData.houseId))
        end, false
    )
    
    HouseGUI.btnClose = guiCreateButton(sW*((width+75)/2/sDW), sH*((height-50)/sDH), sW*((width-75)/2/sDW), sH*(40/sDH), 'Закрыть', false, HouseGUI.wnd)
    guiSetFont(HouseGUI.btnClose, Utils.fonts.RR_10)
    addEventHandler("onClientGUIClick", HouseGUI.btnClose, HouseGUI.closeWindow, false)
end

function HouseGUI.onPlayerBuyHouse()
    HouseGUI.wnd.visible = false

    local message = string.format("Вы хотите приобрести дом №'%s' за %s ₽ ?", _houseData.houseId, exports.tmtaUtils:formatMoney(_houseData.price))
    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onHouseConfirmWindowBuy', 'onHouseConfirmWindowCancel', 'onHouseConfirmWindowClose')
    exports.tmtaGUI:setBtnOkLabel(confirmWindow, 'Купить')
end

function HouseGUI.onPlayerSellHouse()
    HouseGUI.wnd.visible = false

    local price = tonumber(_houseData.price - (_houseData.price * Config.SELL_COMMISSION/100))
    local message = string.format("Вы действительно хотите продать дом №'%s' государству за %s ₽ ?", _houseData.houseId, exports.tmtaUtils:formatMoney(price))
    local confirmWindow = exports.tmtaGUI:createConfirm(message, 'onHouseConfirmWindowSell', 'onHouseConfirmWindowCancel', 'onHouseConfirmWindowClose')
    exports.tmtaGUI:setBtnOkLabel(confirmWindow, 'Продать')
end

function HouseGUI.openWindow(houseData)
    if type(houseData) ~= 'table' or isElement(HouseGUI.wnd) then
        return
    end
    _houseData = houseData

    HouseGUI.render()
    showCursor(true)
    showChat(false)
    exports.tmtaUI:setPlayerBlurScreen(true)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end

function HouseGUI.closeWindow()
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