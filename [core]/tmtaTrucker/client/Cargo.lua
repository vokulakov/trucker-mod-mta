local GUI = {}
GUI.isVisible = false

ORDER_LIST = {} -- обший список заказов
local _cacheOrderByVehicleModel = {} -- кэшированный список заказов по моделям ТС
local _maxOrderListCount = 0

local _targetMarker
local _targetBlip
local _reloadTimer, _durationTimer

local width, height = 1024, 680

function Cargo.renderWindow()
    GUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), "Меню дальнобойщика [F10]", false)
    exports.tmtaGUI:windowCentralize(GUI.wnd)
    guiWindowSetSizable(GUI.wnd, false)
    guiWindowSetMovable(GUI.wnd, false)
    GUI.wnd.alpha = 0.9
    GUI.wnd.visible = false

    --
    local offsetPosY = 30

    local _offsetPosY = (offsetPosY + 30 + 10)-64/1.5-5
    local iconLogo = exports.tmtaTextures:createStaticImage(sW*((0)/sDW), sH*((_offsetPosY)/sDH), sW*((64/1.5)/sDW), sH*((64/1.5)/sDH), 'logo_tmta_64', false, GUI.wnd)
    iconLogo.enabled = false

    local lblTitle = guiCreateLabel(sW*((64/1.5+15)/sDW), sH*(offsetPosY/sDH), sW*(width/sDW), sH*(40/sDH), "ДАЛЬНОБОЙЩИК", false, GUI.wnd)
    guiSetFont(lblTitle, guiFont.RB_10)
    lblTitle.enabled = false

    local lblSubTitle = guiCreateLabel(sW*((64/1.5+15)/sDW), sH*((offsetPosY+15)/sDH), sW*(width/sDW), sH*(40/sDH), "Мчится тихий огонёк моей души!", false, GUI.wnd)
    guiSetFont(lblSubTitle, guiFont.RR_10)
    guiLabelSetColor(lblSubTitle, 155, 155, 155)
    lblSubTitle.enabled = false
    
    local offsetPosX = width-35
    GUI.btnClose = guiCreateButton(sW*((offsetPosX)/sDW), sH*(offsetPosY/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, GUI.wnd)
    guiSetFont(GUI.btnClose, guiFont.RB_10)
    guiSetProperty(GUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", GUI.btnClose, Cargo.closeWindow, false)

    offsetPosX = offsetPosX-10
    local line = exports.tmtaTextures:createStaticImage(sW*((offsetPosX)/sDW), sH*(offsetPosY/sDH), 1, sH*(25/sDH), 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosX = offsetPosX-150-10
    GUI.btnStopPlayerWork = guiCreateButton(sW*((offsetPosX)/sDW), sH*(offsetPosY/sDH), sW*(150/sDW), sH*(25/sDH), 'Завершить смену', false, GUI.wnd)
    guiSetFont(GUI.btnStopPlayerWork, guiFont.RR_11)
    guiSetProperty(GUI.btnStopPlayerWork, 'HoverTextColour', 'FF21b1ff')
    addEventHandler("onClientGUIClick", GUI.btnStopPlayerWork, GUI.onClientGUIClickBtnStopWork, false)

    offsetPosX = offsetPosX-10
    local line = exports.tmtaTextures:createStaticImage(sW*((offsetPosX)/sDW), sH*(offsetPosY/sDH), 1, sH*(25/sDH), 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosX = offsetPosX-10
    local lbl = guiCreateLabel(sW*((0)/sDW), sH*((offsetPosY)/sDH), sW*(offsetPosX/sDW), sH*(40/sDH), "Вы заработали сегодня:", false, GUI.wnd)
    guiLabelSetHorizontalAlign(lbl, "right")
    guiSetFont(lbl, guiFont.RR_10)
    guiLabelSetColor(lbl, 155, 155, 155)
    lbl.enabled = false

    local _offsetPosY = offsetPosY+20
    GUI.lblMoneyToday = GUI.createIconLabel(sW*((0)/sDW), sH*((_offsetPosY)/sDH), sW*(offsetPosX/sDW), sH*(40/sDH), 'i_money', 0, GUI.wnd)
    GUI.setIconLabelPosition(GUI.lblMoneyToday, 0, _, sW*(offsetPosX/sDW), _, 'right')

    offsetPosY = offsetPosY + 30 + 10
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 15

    local lbl = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), "БИРЖА ЗАКАЗОВ", false, GUI.wnd)
    guiLabelSetHorizontalAlign(lbl, "center", false)
    guiSetFont(lbl, guiFont.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    local _offsetPosX = width-20
    local _offsetPosY = offsetPosY-10
    local lbl = guiCreateLabel(sW*((0)/sDW), sH*((_offsetPosY)/sDH), sW*((_offsetPosX)/sDW), sH*(30/sDH), "Обновление заказов через:", false, GUI.wnd)
    guiLabelSetHorizontalAlign(lbl, "right", false)
    guiSetFont(lbl, guiFont.RR_10)
    guiLabelSetColor(lbl, 155, 155, 155)
    lbl.enabled = false

    local _offsetPosY = _offsetPosY + 15
    GUI.lblOrderTimeUpdate = GUI.createIconLabel(sW*((0)/sDW), sH*((_offsetPosY)/sDH), sW*((_offsetPosX)/sDW), sH*(40/sDH), 'i_clock', '00:00', GUI.wnd)
    GUI.setIconLabelPosition(GUI.lblOrderTimeUpdate, 0, _,  sW*((_offsetPosX)/sDW), _, 'right')

    offsetPosY = offsetPosY + 30
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 10
    local orderListHeight = height-240
    GUI.orderList = guiCreateGridList(10, sH*((offsetPosY)/sDH), sW*(width/sDW), sH*((orderListHeight)/sDH), false, GUI.wnd)
    guiGridListSetSortingEnabled(GUI.orderList, false)
    GUI.orderList.enabled = false
    addEventHandler("onClientGUIClick", GUI.orderList, GUI.onClientGUISelectOrder, false)
    
    guiGridListAddColumn(GUI.orderList, "Груз", 0.3)
    guiGridListAddColumn(GUI.orderList, "Вес", 0.07)
    guiGridListAddColumn(GUI.orderList, "Расстояние", 0.08)
    guiGridListAddColumn(GUI.orderList, "Пункт назначения", 0.12)
    guiGridListAddColumn(GUI.orderList, "Время на доставку", 0.12)
    guiGridListAddColumn(GUI.orderList, "Оплата", 0.1)
    guiGridListAddColumn(GUI.orderList, "Категория", 0.12)

    --
    offsetPosY = offsetPosY + orderListHeight + 10
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 5
    local line = exports.tmtaTextures:createStaticImage(sW*((width/2)/sDW), sH*((offsetPosY)/sDH), 1, sH*((height-offsetPosY)/sDH), 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    local _offsetPosY = offsetPosY
    local lbl = guiCreateLabel(0, sH*(_offsetPosY/sDH), sW*((width/2)/sDW), sH*(30/sDH), 'ИНФОРМАЦИЯ О ЗАКАЗЕ', false, GUI.wnd)
    guiLabelSetHorizontalAlign(lbl, "center", false)
    guiSetFont(lbl, guiFont.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    _offsetPosY = _offsetPosY + 20
    local line = exports.tmtaTextures:createStaticImage(10, sH*((_offsetPosY)/sDH), sW*((width/2-10)/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    local line = exports.tmtaTextures:createStaticImage(sW*((width/4)/sDW), sH*((_offsetPosY)/sDH), 1, sH*((height-_offsetPosY)/sDH), 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false
    --

    _offsetPosY = _offsetPosY + 5
    local lbl = guiCreateLabel(10, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(15/sDH), 'Груз:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetVerticalAlign(lbl, "center", false)
    lbl.enabled = false

    local offsetPosX = guiLabelGetTextExtent(lbl)+5
    GUI.lblOrderName = guiCreateLabel(10+offsetPosX, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(15/sDH), '—', false, GUI.wnd)
    guiSetFont(GUI.lblOrderName, guiFont.RB_10)
    guiLabelSetVerticalAlign(GUI.lblOrderName, "center", false)
    guiLabelSetColor(GUI.lblOrderName, 242, 171, 18)
    GUI.lblOrderName.enabled = false

    local offsetPosX = sW*((width/4)/sDW)
    local lbl = guiCreateLabel(10+offsetPosX, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(15/sDH), 'Время на доставку:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetVerticalAlign(lbl, "center", false)
    lbl.enabled = false

    local offsetPosX = offsetPosX + guiLabelGetTextExtent(lbl)+25
    GUI.lblOrderTime = GUI.createIconLabel(10+offsetPosX, sH*((_offsetPosY+1)/sDH), sW*(width/sDW), sH*(15/sDH), 'i_clock', '00:00 мин', GUI.wnd)
    guiLabelSetColor(GUI.lblOrderTime, 242, 171, 18)

    --
    _offsetPosY = _offsetPosY + 20
    local line = exports.tmtaTextures:createStaticImage(10, sH*((_offsetPosY)/sDH), sW*((width/2-10)/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    local lbl = guiCreateLabel(10, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*((20)/sDH), 'Маршрут:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetVerticalAlign(lbl, "center", false)
    lbl.enabled = false

    local offsetPosX = guiLabelGetTextExtent(lbl)+5
    GUI.lblRoute = guiCreateLabel(10+offsetPosX, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(20/sDH), '—', false, GUI.wnd)
    guiSetFont(GUI.lblRoute, guiFont.RB_10)
    guiLabelSetVerticalAlign(GUI.lblRoute, "center", false)
    guiLabelSetColor(GUI.lblRoute, 242, 171, 18)
    GUI.lblRoute.enabled = false

    local offsetPosX = sW*((width/4)/sDW)
    local lbl = guiCreateLabel(10+offsetPosX, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(20/sDH), 'Вес:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetVerticalAlign(lbl, "center", false)
    lbl.enabled = false

    local offsetPosX = offsetPosX + guiLabelGetTextExtent(lbl)+5
    GUI.lblOrderWeight = guiCreateLabel(10+offsetPosX, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(20/sDH), '—', false, GUI.wnd)
    guiSetFont(GUI.lblOrderWeight, guiFont.RB_10)
    guiLabelSetVerticalAlign(GUI.lblOrderWeight, "center", false)
    guiLabelSetColor(GUI.lblOrderWeight, 242, 171, 18)
    GUI.lblOrderWeight.enabled = false

    --
    _offsetPosY = _offsetPosY + 20
    local line = exports.tmtaTextures:createStaticImage(10, sH*((_offsetPosY)/sDH), sW*((width/2-10)/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    local lbl = guiCreateLabel(10, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'Расстояние:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetVerticalAlign(lbl, "center", false)
    lbl.enabled = false

    local offsetPosX = guiLabelGetTextExtent(lbl)+5
    GUI.lblDistance = guiCreateLabel(10+offsetPosX, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), '—', false, GUI.wnd)
    guiSetFont(GUI.lblDistance, guiFont.RB_10)
    guiLabelSetVerticalAlign(GUI.lblDistance, "center", false)
    guiLabelSetColor(GUI.lblDistance, 242, 171, 18)
    GUI.lblDistance.enabled = false

    local offsetPosX = sW*((width/4)/sDW)
    local lbl = guiCreateLabel(10+offsetPosX, sH*(_offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'Оплата:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetVerticalAlign(lbl, "center", false)
    lbl.enabled = false

    local offsetPosX = offsetPosX + guiLabelGetTextExtent(lbl)+35
    GUI.lblOrderReward = GUI.createIconLabel(10+offsetPosX, sH*((_offsetPosY+8)/sDH), sW*(width/sDW), sH*(30/sDH), 'i_money', 0, GUI.wnd)
    guiLabelSetColor(GUI.lblOrderReward, 242, 171, 18)

    --
    local offsetPosX = (width/2)+10
    local offsetPosY = offsetPosY+5

    GUI.btnService = guiCreateButton(sW*((offsetPosX)/sDW), sH*(offsetPosY/sDH), sW*((width/2)/sDW), sH*(35/sDH), 'Техническая помощь на дороге', false, GUI.wnd)
    guiSetFont(GUI.btnService, guiFont.RR_11)
    guiSetProperty(GUI.btnService, "NormalTextColour", "fff2ab12")
    guiSetProperty(GUI.btnService, 'HoverTextColour', 'FF21b1ff')
    addEventHandler('onClientGUIClick', GUI.btnService, RoadsideAssistance.openWindow, false)
    --GUI.btnService.enabled = false

    offsetPosY = offsetPosY+35+5
    local line = exports.tmtaTextures:createStaticImage(sW*(offsetPosX/sDW), sH*((offsetPosY)/sDH), sW*((width/2-10)/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosY = offsetPosY+10
    GUI.btnCancelOrder = guiCreateButton(sW*((offsetPosX)/sDW), sH*((offsetPosY)/sDH), sW*((width/5.5)/sDW), sH*(35/sDH), 'Отменить заказ', false, GUI.wnd)
    guiSetFont(GUI.btnCancelOrder, guiFont.RR_11)
    guiSetProperty(GUI.btnCancelOrder, 'HoverTextColour', 'FF21b1ff')
    GUI.btnCancelOrder.enabled = false
    addEventHandler('onClientGUIClick', GUI.btnCancelOrder, GUI.onClientGUIClickBtnCancelOrder, false)

    offsetPosX = offsetPosX + (width/5.5) + 10
    local line = exports.tmtaTextures:createStaticImage(sW*((offsetPosX)/sDW), sH*(offsetPosY/sDH), 1, sH*(35/sDH), 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosX = offsetPosX + 10
    GUI.btnAcceptOrder = guiCreateButton(sW*((offsetPosX)/sDW), sH*((offsetPosY)/sDH), sW*((width/3.5)/sDW), sH*(35/sDH), 'Принять заказ', false, GUI.wnd)
    guiSetFont(GUI.btnAcceptOrder, guiFont.RR_11)
    guiSetProperty(GUI.btnAcceptOrder, 'HoverTextColour', 'FF21b1ff')
    guiSetProperty(GUI.btnAcceptOrder, "NormalTextColour", "FF01D51A")
    GUI.btnAcceptOrder.enabled = false
    addEventHandler('onClientGUIClick', GUI.btnAcceptOrder, GUI.onClientGUIClickBtnAcceptOrder, false)
end

function Cargo.setWindowVisible(state)
    return guiSetVisible(GUI.wnd, not not state)
end

function GUI.updateLblOrderTimeUpdate()
    if not GUI.isVisible then
        return false
    end
    local m, s = exports.tmtaUtils:convertMsToTimeStr(resourceRoot:getData("cargoOrderTimerUpdate") or 0)
    GUI.lblOrderTimeUpdate.text = string.format("%02d:%02d", m, s)
end

function GUI.updateLblMoneyToday()
    local playerStatistic = localPlayer:getData("player:truckerStatistic") or {}
    GUI.lblMoneyToday.text = exports.tmtaUtils:formatMoney(playerStatistic.currentMoney) or 0
    GUI.setIconLabelPosition(GUI.lblMoneyToday, _, _, _, _, 'right')
end

function Cargo.openWindow()
    if (GUI.isVisible) then
        return false
    end

    if (localPlayer.interior ~= 0 or localPlayer.dimension ~= 0) then
        return false
    end

    if (not exports.tmtaUI:isPlayerComponentVisible("all")) then
        return false
    end

    if (not localPlayer:getData("player:isTrucker")) then
        return false
    end

    if (not Utils.getPlayerTruck(localPlayer, true)) then
        return Utils.showNotice('Планшет доступен только в рабочем транспорте!', player)
    end

    exports.tmtaUI:setPlayerComponentVisible("dashboard", false)
    setPlayerUI(true)
    showCursor(true)

    local isPlayerOrder = (Utils.getPlayerCurrentOrderId()) and true or false
    GUI.orderList.enabled = not isPlayerOrder
    GUI.btnCancelOrder.enabled = isPlayerOrder
    GUI.btnAcceptOrder.enabled = false

    if not isPlayerOrder then
        GUI.resetWindow()
    end

    GUI.renderOrderList()
    GUI.updateLblMoneyToday()

    addEventHandler("onClientHUDRender", root, GUI.updateLblOrderTimeUpdate)
    GUI.isVisible = true
    Cargo.setWindowVisible(true)

    exports.tmtaSounds:playSound('ui_window_open')

    return true
end

function Cargo.closeWindow()
    if not GUI.isVisible then
        return false
    end

    exports.tmtaUI:setPlayerComponentVisible("dashboard", true)
    setPlayerUI(false)
    showCursor(false)

    GUI.isVisible = false
    Cargo.setWindowVisible(false)

    removeEventHandler("onClientHUDRender", root, GUI.updateLblOrderTimeUpdate)

    if isElement(GUI.confirmWindow) then
        destroyElement(GUI.confirmWindow)
    end

    exports.tmtaSounds:playSound('ui_window_close')

    return true
end

function GUI.resetWindow()
    GUI.btnAcceptOrder.enabled = false

    GUI.lblOrderName.text = '—'
    GUI.lblDistance.text = '—'
    GUI.lblOrderReward.text = '0'
    GUI.lblOrderWeight.text = '—'
    GUI.lblOrderTime.text = '00:00 мин'
    GUI.lblRoute.text = '—'
end

--TODO: вынести в tmtaGUI для использования в других системах
function GUI.createIconLabel(posX, posY, width, height, icon, text, guiElement)
    local guiElement = guiElement or nil
    
    local _texture = exports.tmtaTextures:createTexture(icon)
    if not isElement(_texture) then
        return false
    end

    local iconWidth, iconHeight = dxGetMaterialSize(_texture)
    destroyElement(_texture)

    local _iconSizeCoef = 1.7
    iconWidth = iconWidth/_iconSizeCoef
    iconHeight = iconHeight/_iconSizeCoef

    local windowWidth, windowHeight = guiGetSize(guiElement, false)
    local width = width or windowWidth
    local height = height or windowHeight


    local label = guiCreateLabel(posX, posY, width, height, text, false, guiElement)
    guiSetFont(label, guiFont.RB_10)
    label.enabled = false

    local labelOffsetX = 10/_iconSizeCoef

    local icon = exports.tmtaTextures:createStaticImage(posX-iconWidth-labelOffsetX, posY+(guiLabelGetFontHeight(label)-iconHeight)/2, iconWidth, iconHeight, icon, false, guiElement)
    icon.enabled = false
    label:setData('icon', icon, false)
    setElementParent(icon, label)

    return label
end

function GUI.setIconLabelPosition(label, leftX, topY, rightX, bottomY, alignX, alignY)
    local rightX = rightX or leftX
    local bottomY = bottomY or topY

    local icon = label:getData('icon')
    local iconPosX, iconPosY = guiGetPosition(icon, false)
    local iconOriginalWidth, iconOriginalHeigth = guiStaticImageGetNativeSize(icon)
    local iconWidth, iconHeight = guiGetSize(icon, false)

    local _iconSizeCoef = iconOriginalWidth/iconWidth
    local labelOffsetX = 10/_iconSizeCoef

    local labelPosX, labelPosY = guiGetPosition(label, false)
    local labelTextExtent = guiLabelGetTextExtent(label)
    local labelWidth, labelHeight = guiGetSize(label, false)
    
    local frameLeftX = iconPosX
    local frameTopY = labelPosY--(iconPosY > labelPosY) and iconPosY or labelPosY
    local frameWidth = iconWidth + labelOffsetX + labelTextExtent
    local frameHeight = (iconHeight > labelHeight) and iconHeight or labelHeight
    local frameRightX = rightX or labelWidth
    local frameBottomY = bottomY or labelHeight

    local _iconPosX = frameLeftX
    local _iconPosY = frameTopY

    local _labelPosX = frameLeftX + iconWidth + labelOffsetX
    local _labelPosY = frameTopY

    if (alignX) then
        if (alignX == 'center') then
            _iconPosX = (frameRightX-frameWidth)/2
            _labelPosX = _iconPosX + iconWidth + labelOffsetX
        elseif (alignX == 'right') then
            _labelPosX = frameRightX - labelTextExtent
            _iconPosX = _labelPosX - iconWidth - labelOffsetX
        end
    end

    --TODO: костыль
    local _iconPosY = _labelPosY + (guiLabelGetFontHeight(label)-iconHeight)/2

    guiSetPosition(label, _labelPosX, _labelPosY)
    guiSetPosition(icon, _iconPosX, _iconPosY)
end

function GUI.onClientGUIClickBtnStopWork()
    Cargo.setWindowVisible(false)
    GUI.confirmWindow = Trucker.renderConfirmWindowOnClientStopWork()
end

addEvent('tmtaTrucker.onTruckerGUIConfirmWindowCancel', false)
addEventHandler('tmtaTrucker.onTruckerGUIConfirmWindowCancel', localPlayer,
    function()
        if (not GUI.isVisible) then
            return false
        end
        Cargo.setWindowVisible(true)
    end
)

addEvent('tmtaTrucker.onTruckerGUIConfirmWindowStopWork', false)
addEventHandler('tmtaTrucker.onTruckerGUIConfirmWindowStopWork', localPlayer,
    function()
        Cargo.closeWindow()
    end
)

function GUI.getClientGetSelectOrder()
    if (not isElement(GUI.orderList) or not GUI.orderList.enabled) then
        return false
    end

    local selectedItem = guiGridListGetSelectedItems(GUI.orderList)
    if not selectedItem[1] then
        return false
    end

    local orderId = guiGridListGetItemData(GUI.orderList, tonumber(selectedItem[1]["row"]), 1)

    return orderId
end

function GUI.onClientGUISelectOrder()
    local orderId = GUI.getClientGetSelectOrder()
    if not orderId then
        return GUI.resetWindow()
    end

    local orderData = Cargo.getOrderDataById(orderId)
    playSoundFrontEnd(33)

    GUI.lblOrderName.text = Utils.subStr(orderData.name, 29)
    GUI.lblRoute.text = Utils.subStr(orderData.route, 25)

    GUI.lblOrderWeight.text = Utils.formatWeightToString(orderData.weight)
    GUI.lblDistance.text = string.format('%s м', exports.tmtaUtils:comma_value(orderData.distance))

    GUI.lblOrderTime.text = string.format('%02d:%02d мин', exports.tmtaUtils:convertMsToTimeStr(orderData.deliveryTime))
    GUI.lblOrderReward.text = exports.tmtaUtils:formatMoney(orderData.reward)

    GUI.btnAcceptOrder.enabled = true
end

function GUI.onClientGUIClickBtnAcceptOrder()
    if (Utils.getPlayerCurrentOrderId()) then
        return Utils.showNotice("Вы не можете принять новый заказ пока не завершите другой!")
    end

    local orderId = GUI.getClientGetSelectOrder()
    if not orderId then
        return false
    end

    local orderData = Cargo.getOrderDataById(orderId)
    if not orderData then
        return false
    end

    local message = string.format(
        "Вы уверены, что хотите взять заказ на груз '%s' по маршруту %s (%s м) за %s ₽ ?",
        orderData.name,
        orderData.route,
        exports.tmtaUtils:comma_value(orderData.distance),
        exports.tmtaUtils:formatMoney(orderData.reward)
    )

    Cargo.setWindowVisible(false)
    GUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onTruckerGUIConfirmWindowAcceptOrder', 'onTruckerGUIConfirmWindowAcceptOrderCancel', 'onTruckerGUIConfirmWindowAcceptOrderCancel')
    exports.tmtaGUI:confirmSetBtnCancelLabel(GUI.confirmWindow, 'Отказаться')
    exports.tmtaGUI:confirmSetBtnOkLabel(GUI.confirmWindow, 'Принять')
end

function onTruckerGUIConfirmWindowAcceptOrder()
    local truck = Utils.getPlayerTruck(localPlayer, true)
    local orderId = GUI.getClientGetSelectOrder()
    local order = Cargo.getOrderDataById(orderId)

    if (not isElement(truck) or not orderId or not order) then
        Cargo.setWindowVisible(true)
        return Utils.showNotice("Не удалось принять заказ, попробуйте позже!")
    end

    protectedTriggerServerEvent('tmtaTrucker.requestPlayerOrderAccept', localPlayer, truck, orderId, order.deliveryTime)
end

function onTruckerGUIConfirmWindowAcceptOrderCancel()
    Cargo.setWindowVisible(true)
end

function GUI.onClientGUIClickBtnCancelOrder()
    local orderId = Utils.getPlayerCurrentOrderId()
    if not orderId then
        return false
    end

    local order = Cargo.getOrderDataById(orderId)
    if not order then
        return false
    end

    Cargo.setWindowVisible(false)

    local message = string.format(
        "Вы уверены, что хотите отменить заказ на груз '%s' и заплатить неустойку %s ₽?", 
        order.name, 
        math.floor(order.reward*Config.FORFEIT_PERCENT/100)
    )

    GUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onTruckerGUIConfirmWindowCancelOrder', 'onTruckerGUIConfirmWindowAcceptOrderCancel', 'onTruckerGUIConfirmWindowAcceptOrderCancel')
    exports.tmtaGUI:confirmSetBtnCancelLabel(GUI.confirmWindow, 'Продолжить')
    exports.tmtaGUI:confirmSetBtnOkLabel(GUI.confirmWindow, 'Отменить заказ')
end

function onTruckerGUIConfirmWindowCancelOrder()
    return Cargo.onPlayerOrderCancel()
end

function GUI.addOrderToList(order)
    if (not order or type(order) ~= 'table') then
        return
    end

    local row = guiGridListAddRow(GUI.orderList,
        Utils.subStr(order.name, 45),
        Utils.formatWeightToString(order.weight),
        string.format('%s м', exports.tmtaUtils:comma_value(order.distance)),
        Utils.subStr(order.deliveryPoint.location.city, 12),
        string.format('%02d:%02d мин', exports.tmtaUtils:convertMsToTimeStr(order.deliveryTime)),
        string.format('%s ₽', exports.tmtaUtils:formatMoney(order.reward)),
        Utils.subStr(order.category, 20)
    )

    guiGridListSetItemData(GUI.orderList, row, 1, tostring(order.orderId))

    if (GUI.orderList.enabled) then
        if (Utils.getPlayerCurrentOrderId()) then
            for columnIndex = 1, guiGridListGetColumnCount(GUI.orderList) do
                guiGridListSetItemColor(GUI.orderList, row, columnIndex, 255, 255, 255, 125)
            end
        else
            for _, columnIndex in pairs({ 2, 6 }) do
                guiGridListSetItemColor(GUI.orderList, row, columnIndex, 10, 183, 220, 255)
            end
        end
    else
        for columnIndex = 1, guiGridListGetColumnCount(GUI.orderList) do
            guiGridListSetItemColor(GUI.orderList, row, columnIndex, 255, 255, 255, 125)
        end
    end
end

function GUI.renderOrderList()
    guiGridListClear(GUI.orderList)

    local truck = Utils.getPlayerTruck(localPlayer, true)
    if (not isElement(truck)) then
        return false
    end

    local _cacheVehicleOrder = _cacheOrderByVehicleModel[truck.model] or {}

    local _cacheOrderList = _cacheVehicleOrder.orderList or {} -- список заказов (текущий)
    local _cacheOrderCounter = _cacheVehicleOrder.orderCounter or 0 -- количество заказов

    local _cacheCategoryCounter = _cacheVehicleOrder.orderCategoryCounter or {} -- счетчик категорий
    local _cacheCategoryMaxCounter = _cacheVehicleOrder.orderCategoryMaxCounter or {}

    local _cacheNameCounter = _cacheVehicleOrder.orderNameCounter or {} --  счетчик названий заказов
    local _cacheNameMaxCounter = _cacheVehicleOrder.orderNameMaxCounter or {}

    if (tonumber(_cacheOrderCounter) < tonumber(_maxOrderListCount)) then
        for orderId, order in pairs(ORDER_LIST) do
            if (tonumber(_cacheOrderCounter) >= tonumber(_maxOrderListCount)) then
                break
            end

            if (not _cacheCategoryMaxCounter[order.category]) then
                _cacheCategoryMaxCounter[order.category] = math.random(4, 8)
            end

            if (not _cacheCategoryCounter[order.category]) then
                _cacheCategoryCounter[order.category] = 0
            end

            if (not _cacheNameMaxCounter[order.name]) then
                _cacheNameMaxCounter[order.name] = math.random(1, 3)
            end

            if (not _cacheNameCounter[order.name]) then
                _cacheNameCounter[order.name] = 0
            end

            if (
                (not _cacheOrderList[orderId] and Utils.isOrderAvailable(orderId)) and
                (Utils.isOrderAvailableForTruck(orderId, truck)) and
                (_cacheNameCounter[order.name] < _cacheNameMaxCounter[order.name]) and
                (_cacheCategoryCounter[order.category] < _cacheCategoryMaxCounter[order.category])
            ) then
                _cacheOrderList[orderId] = order
                _cacheOrderList[orderId].deliveryTime = Cargo.getOrderDeliveryTime(order.distance)

                _cacheOrderCounter = _cacheOrderCounter + 1
                _cacheCategoryCounter[order.category] = _cacheCategoryCounter[order.category] + 1
                _cacheNameCounter[order.name] = _cacheNameCounter[order.name] + 1
            end
        end

        _cacheOrderByVehicleModel[truck.model] = {
            orderList = _cacheOrderList,
            orderCounter = tonumber(_cacheOrderCounter),
            orderCategoryCounter = _cacheCategoryCounter,
            orderCategoryMaxCounter = _cacheCategoryMaxCounter,
            orderNameCounter = _cacheNameCounter,
            orderNameMaxCounter = _cacheNameMaxCounter,
        }
    end
    
    for _, order in pairs(_cacheOrderList) do
        if (not order.isDelete) then
            GUI.addOrderToList(order)
        end
    end
end

function Cargo.addOrderToList(orderId)
    local order = Cargo.getOrderDataById(orderId)
    if (not order) then
        return false
    end

    for truckModel in pairs(_cacheOrderByVehicleModel) do
        if (_cacheOrderByVehicleModel[truckModel].orderList[orderId] and _cacheOrderByVehicleModel[truckModel].orderList[orderId].isDelete) then
            _cacheOrderByVehicleModel[truckModel].orderCounter = _cacheOrderByVehicleModel[truckModel].orderCounter + 1
            _cacheOrderByVehicleModel[truckModel].orderCategoryCounter[order.category] = _cacheOrderByVehicleModel[truckModel].orderCategoryCounter[order.category] + 1
            _cacheOrderByVehicleModel[truckModel].orderNameCounter[order.name] = _cacheOrderByVehicleModel[truckModel].orderNameCounter[order.name] + 1
            
            _cacheOrderByVehicleModel[truckModel].orderList[orderId].isDelete = false
        end
    end
   
    return true
end

function Cargo.removeOrderFromList(orderId)
    local order = Cargo.getOrderDataById(orderId)
    if (not order) then
        return false
    end

    for truckModel in pairs(_cacheOrderByVehicleModel) do
        if (_cacheOrderByVehicleModel[truckModel].orderList[orderId] and not _cacheOrderByVehicleModel[truckModel].orderList[orderId].isDelete) then
            _cacheOrderByVehicleModel[truckModel].orderCounter = _cacheOrderByVehicleModel[truckModel].orderCounter - 1
            _cacheOrderByVehicleModel[truckModel].orderCategoryCounter[order.category] = _cacheOrderByVehicleModel[truckModel].orderCategoryCounter[order.category] - 1
            _cacheOrderByVehicleModel[truckModel].orderNameCounter[order.name] = _cacheOrderByVehicleModel[truckModel].orderNameCounter[order.name] - 1
            
            _cacheOrderByVehicleModel[truckModel].orderList[orderId].isDelete = true
        end
    end

    return true 
end

--- Получить данные заказа по id
function Cargo.getOrderDataById(orderId)
    if type(orderId) ~= 'string' then
        return false
    end

    local order = Utils.getOrderById(orderId)
    if (not order) then
        return false
    end

    local truck = Utils.getPlayerTruck()
    if (isElement(truck)) then
        local _order = _cacheOrderByVehicleModel[truck.model].orderList[orderId]
        if (_order) then
            for data, value in pairs(_order) do
                order[data] = value
            end 
        end
    end

    return order
end

addEvent('tmtaTrucker.onOrderListUpdate', true)
addEventHandler('tmtaTrucker.onOrderListUpdate', resourceRoot,
    function(orderList)
        ORDER_LIST = orderList
        _maxOrderListCount = math.random(15, 25)
        _cacheOrderByVehicleModel = {}
        GUI.renderOrderList()
    end
)

addEvent('tmtaTrucker.onOrderUpdateData', true)
addEventHandler('tmtaTrucker.onOrderUpdateData', resourceRoot,
    function(orderId, order)
        ORDER_LIST[orderId] = order
    end
)

addEvent('tmtaTrucker.onOrderAccept', true)
addEventHandler('tmtaTrucker.onOrderAccept', resourceRoot,
    function(orderId)
        Cargo.removeOrderFromList(orderId)
    end
)

addEvent('tmtaTrucker.onOrderCanceled', true)
addEventHandler('tmtaTrucker.onOrderCanceled', resourceRoot,
    function(orderId)
        Cargo.addOrderToList(orderId)
    end
)

addEvent('tmtaTrucker.onOrderComplete', true)
addEventHandler('tmtaTrucker.onOrderComplete', resourceRoot,
    function(orderId)
        Cargo.removeOrderFromList(orderId)
    end
)

-- Получить (рассчитать) время для выполнения заказа
-- В расчет брать онлайн (т.к. игроки могут мешать)
-- В расчет брать характеристики ТС
function Cargo.getOrderDeliveryTime(distance)
    local time = (((distance/1000)/70)*(60 * 60 * 1000))

    local lvl = exports.tmtaExperience:getPlayerLvl()
    local coeff = 1.3

    --TODO: сделать ранги через константы и экспортом из системы опыта
    if (tostring(exports.tmtaExperience:getRankFromLvl(lvl)) == 'Новичок') then 
        coeff = 2.2
    end

    return math.floor(time + (time * coeff))
end

function Cargo.onPlayerOrderCancel()
    local orderId = Utils.getPlayerCurrentOrderId()
    if (not orderId) then
        return false
    end
    protectedTriggerServerEvent('tmtaTrucker.requestPlayerOrderCanceled', localPlayer, orderId)
end

local function isPlayerMarkerHit(player, matchingDimension)
    if (player ~= localPlayer or not matchingDimension) then
        return false
    end

    local verticalDistance = localPlayer.position.z - source.position.z
    if (verticalDistance > 5 or verticalDistance < -1) then
        return false
    end

    local truck = Utils.getPlayerTruck(localPlayer, true)
    if (not isElement(truck)) then
        return Utils.showNotice("А где ваш транспорт?")
    end

    setElementVelocity(truck, 0, 0, 0)

    return true
end

function Cargo.createTargetMarker(x, y, z)
    if isElement(_targetMarker) then
		destroyElement(_targetMarker)
	end
	if isElement(_targetBlip) then
		destroyElement(_targetBlip)
	end
	if x and y and z then
		_targetMarker = createMarker(x, y, z, "checkpoint", 10)
		_targetBlip = exports.tmtaBlip:createBlipAttachedTo(
            _targetMarker, 
            'blipCheckpoint',
            {name = 'Точка загрузки'},
            tocolor(255, 9, 0, 255)
        )

		return _targetMarker
	end
    return true
end

function Cargo.onTruckLoadMarkerHit(player, matchingDimension)
    if (not isPlayerMarkerHit(player, matchingDimension)) then
        return false
    end

    local truck = localPlayer.vehicle
    if (Utils.isTruckNeedsTrailer(truck) and getVehicleTowedByVehicle(truck)) then
        return Utils.showNotice("А где прицеп?")
    end 

    local orderId = Utils.getPlayerCurrentOrderId()
    local order = Utils.getOrderById(orderId)

    local weight = order.weight/1000
    _durationTimer = (weight < 1) and 10 * 1000 or weight * 1000
    
    _reloadTimer = setTimer(
        function()
            Cargo.onCompleteLoadToTruck(truck, orderId)
        end, _durationTimer, 1) 

    Cargo.createTargetMarker()
    Cargo.startWaitingMessage()

    toggleAllControls(false, true, true)
end

function Cargo.onCompleteLoadToTruck(truck, orderId)
    if (not isElement(truck)) then
        Cargo.onPlayerOrderCancel()
        return false
    end

    Cargo.stopWaitingMessage()
    protectedTriggerServerEvent('tmtaTrucker.requestAddCargoToTruck', localPlayer, truck, orderId)
	toggleAllControls(true)
end

addEvent('tmtaTrucker.onPlayerOrderAccept', true)
addEventHandler('tmtaTrucker.onPlayerOrderAccept', resourceRoot,
    function(success, orderId)
        if not success then
            Cargo.setWindowVisible(true)
            return Utils.showNotice("Не удалось принять заказ, попробуйте позже!")
        end

        Cargo.closeWindow()
        local order = Cargo.getOrderDataById(orderId)
        local point = Cargo.createTargetMarker(order.loadingPoint.position.x, order.loadingPoint.position.y, order.loadingPoint.position.z)
        exports.tmtaNavigation:setPoint(point, string.format("Точка загрузки\n(%s - %s)", order.loadingPoint.name, order.loadingPoint.location.city))
        addEventHandler("onClientMarkerHit", point, Cargo.onTruckLoadMarkerHit)
    end
)

function Cargo.onTruckUnloadMarkerHit(player, matchingDimension)
    if (not isPlayerMarkerHit(player, matchingDimension)) then
        return false
    end

    local truck = localPlayer.vehicle
    if (Utils.isTruckNeedsTrailer(truck)) then
        local trailer = getVehicleTowedByVehicle(truck)
        if (not isElement(trailer) or trailer:getData("trailer:truck") ~= truck) then
            return Utils.showNotice("А где груз то?")
        end
    end

    local orderId = Utils.getPlayerCurrentOrderId()
    local order = Utils.getOrderById(orderId)

    local weight = order.weight/1000
    _durationTimer = (weight < 1) and 10 * 1000 or weight * 1000

    _reloadTimer = setTimer(
        function()
            Cargo.onCompleteUnloadFromTruck(truck, orderId)
        end, _durationTimer, 1) 

    Cargo.createTargetMarker()
    Cargo.startWaitingMessage()
    toggleAllControls(false, true, true)

    protectedTriggerServerEvent('tmtaTrucker.onTruckUnloadMarkerHit', localPlayer, truck)
end

function Cargo.onCompleteUnloadFromTruck(truck, orderId)
    if (not isElement(truck)) then
        Cargo.onPlayerOrderCancel()
        return false
    end

    Cargo.stopWaitingMessage()
    protectedTriggerServerEvent('tmtaTrucker.onPlayerOrderComplete', localPlayer, truck, orderId)
	toggleAllControls(true)
end

addEvent('tmtaTrucker.onAddCargoToTruck', true)
addEventHandler('tmtaTrucker.onAddCargoToTruck', resourceRoot,
    function(success, deliveryPoint)
        if (not success) then
            return Utils.showNotice("Не удалось загрузить груз")
        end

        local point = Cargo.createTargetMarker(deliveryPoint.position.x, deliveryPoint.position.y, deliveryPoint.position.z)
        exports.tmtaNavigation:setPoint(point, string.format("Точка разгрузки\n(%s - %s)", deliveryPoint.name, deliveryPoint.location.city))
        addEventHandler("onClientMarkerHit", point, Cargo.onTruckUnloadMarkerHit)

        Utils.showNotice("Отправляйтесь на разгрузку. Координаты уже в #FFA07Aнавигаторе #FFFFFF(нажмите #FFA07A'F11'#FFFFFF)")
    end
)

addEvent('tmtaTrucker.onPlayerOrderComplete', true)
addEventHandler('tmtaTrucker.onPlayerOrderComplete', resourceRoot,
    function(success, orderRewardData)
        if (not success) then
            return Utils.showNotice("Не удалось разгрузить груз")
        end

        Cargo.closeWindow()
        Cargo.createTargetMarker()
        Cargo.stopWaitingMessage()

        CargoRewardGUI.showOrderCompleteWindow(orderRewardData)

        toggleAllControls(true)
    end
)

addEvent('tmtaTrucker.onPlayerOrderCanceled', true)
addEventHandler('tmtaTrucker.onPlayerOrderCanceled', resourceRoot, 
    function(success, orderRewardData)
        if (not success) then
            return Utils.showNotice("Не удалось отменить заказ, попробуйте позже!")
        end

        if (isTimer(_reloadTimer)) then
            killTimer(_reloadTimer)
        end

        Cargo.closeWindow()
        Cargo.createTargetMarker()
        Cargo.stopWaitingMessage()

        toggleAllControls(true)

        CargoRewardGUI.showOrderCancelWindow(orderRewardData)

        Utils.showNotice("Вы прекратили выполнение заказа!")
    end
)

local function drawWaitingMessage()
    local width, height = 320, 40
    local posX, posY = (sDW-width)/2, (sDH-height-100)

    local _timeLeft = isTimer(_reloadTimer) and getTimerDetails(_reloadTimer) or 0

    local progress = (_durationTimer-_timeLeft)/_durationTimer

    dxDrawRectangle(sW*(posX /sDW), sH*(posY /sDH), sW*((width) /sDW), sH*((height) /sDH), tocolor(0, 0, 0, 155))
    dxDrawRectangle(sW*((posX+5) /sDW), sH*((posY+5) /sDH), sW*((width-10) /sDW), sH*((height-10) /sDH), tocolor(242, 171, 18, 100))
    dxDrawRectangle(sW*((posX+5) /sDW), sH*((posY+5) /sDH), sW*(((width-10)*progress) /sDW), sH*((height-10) /sDH), tocolor(242, 171, 18, 255))
    dxDrawText('Ожидайте: идёт загрузка/разгрузка груза...', sW*(posX /sDW), sH*((posY+5) /sDH), sW*((posX+width) /sDW), sH*((posY+5+height-10) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, dxFont.RR_10, 'center', 'center')
end

function Cargo.startWaitingMessage()
	addEventHandler("onClientRender", root, drawWaitingMessage)
end

function Cargo.stopWaitingMessage()
	removeEventHandler("onClientRender", root, drawWaitingMessage)
end

bindKey('f10', 'up', 
    function()
        if not GUI.isVisible then
            Cargo.openWindow()
        else
            Cargo.closeWindow()
        end
    end
)

addEventHandler('tmtaDashboard.onChangeVisible', root,
	function()
		if not GUI.isVisible then
            return
        end
		Cargo.closeWindow()
	end
)

addEventHandler('onClientVehicleStartExit', root, 
    function(player, seat)
        if (player ~= localPlayer or seat ~= 0) then
            return
        end
        local truck = Utils.getPlayerTruck(player, true)
        if (truck == source) then
            Cargo.closeWindow()
        end
    end
)

-- Повреждение груза
addEventHandler("onClientVehicleDamage", root, 
    function(_, _, loss)
        local truck = source

        if (Utils.isTruckNeedsTrailer(truck)) then
            local trailer = getVehicleTowedByVehicle(truck)
            if (not isElement(trailer) or trailer:getData("trailer:truck") ~= truck) then
                return
            end
        end

        if (getVehicleType(truck) == 'Trailer') then
            local truck = truck:getData("trailer:truck")
            if (not isElement(truck)) then 
                return
            end
            truck = truck
        end

        local cargoIntegrity = truck:getData("truck:cargoIntegrity")
        if (type(cargoIntegrity) ~= 'number') then 
            return
        end

        local cargoIntegrity = cargoIntegrity - loss*0.4
        truck:setData("truck:cargoIntegrity", (cargoIntegrity < 0) and 0 or cargoIntegrity)
    end
)