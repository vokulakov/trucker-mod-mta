Trucker = {}

local GUI = {}

local width, height = 400, 280

function Trucker.renderWindow()
    GUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(GUI.wnd)
    guiWindowSetSizable(GUI.wnd, false)
    guiWindowSetMovable(GUI.wnd, false)
    GUI.wnd.alpha = 0.8

    --
    local offsetPosY = 25
    GUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(offsetPosY/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, GUI.wnd)
    guiSetFont(GUI.btnClose, guiFont.RB_10)
    guiSetProperty(GUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", GUI.btnClose, Trucker.closeWindow, false)

    local lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(offsetPosY/sDH), sW*(width/sDW), sH*(40/sDH), "ДИСПЕТЧЕР\nТРАНСПОРТНОЙ КОМПАНИИ", false, GUI.wnd)
    guiSetFont(lblTitle, guiFont.RB_10)
    lblTitle.enabled = false

    offsetPosY = offsetPosY + 35
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 10
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'Дальнобойщик:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    local offsetPosX = guiLabelGetTextExtent(lbl)+5
    local lbl = guiCreateLabel(10+offsetPosX, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'доставляй грузы на дальние расстояния,', false,  GUI.wnd)
    guiSetFont(lbl, guiFont.RR_10)
    lbl.enabled = false

    offsetPosY = offsetPosY + 15
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'прокачивай опыт и открывай новые возможности!', false,  GUI.wnd)
    guiSetFont(lbl, guiFont.RR_10)
    lbl.enabled = false

    --
    local playerStatistic = localPlayer:getData("player:truckerStatistic") or {}

    offsetPosY = offsetPosY + 30
    local lbl = guiCreateLabel(0, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'ВАШ ПРОГРЕСС', false, GUI.wnd)
    guiLabelSetHorizontalAlign(lbl, 'center', false)
    guiSetFont(lbl, guiFont.RB_11)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    --
    offsetPosY = offsetPosY + 25
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'Выполнено рейсов:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    lbl.enabled = false

    local offsetPosX = guiLabelGetTextExtent(lbl)+5
    local lbl = guiCreateLabel(10+offsetPosX, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), playerStatistic.totalOrders or 0, false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    -- 
    offsetPosY = offsetPosY + 25
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'Тонн груза перевезено:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    lbl.enabled = false

    local offsetPosX = guiLabelGetTextExtent(lbl)+5
    local totalWeight = Utils.formatWeightToString(playerStatistic.totalWeight or 0)
    local lbl = guiCreateLabel(10+offsetPosX, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), totalWeight, false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    --
    offsetPosY = offsetPosY + 25
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'Киллометров пройдено:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    lbl.enabled = false
    
    local offsetPosX = guiLabelGetTextExtent(lbl)+5
    local totalDistance = string.format("%.f км", math.floor((playerStatistic.totalDistance or 0)/1000))
    local lbl = guiCreateLabel(10+offsetPosX, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), totalDistance, false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    --
    offsetPosY = offsetPosY + 35
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosY = offsetPosY + 10
    GUI.btnChangeTruckerState = guiCreateButton(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(35/sDH), 'Начать смену', false, GUI.wnd)
    guiSetFont(GUI.btnChangeTruckerState, guiFont.RR_11)
    guiSetProperty(GUI.btnChangeTruckerState, "NormalTextColour", "FF01D51A")
    addEventHandler("onClientGUIClick", GUI.btnChangeTruckerState, Trucker.onClientGUIClickBtnChangeTruckerState, false)

    if (localPlayer:getData("player:isTrucker")) then
        GUI.btnChangeTruckerState.text = 'Завершить смену'
        guiSetProperty(GUI.btnChangeTruckerState, "NormalTextColour", "ffd43422")
    end
end

function Trucker.setWindowVisible(state)
    GUI.wnd.visible = not not state
end

function Trucker.openWindow()
    if isElement(GUI.wnd) then 
        return 
    end
    setPlayerUI(true)
    Trucker.renderWindow()
end

function Trucker.closeWindow()
    if not isElement(GUI.wnd) then 
        return 
    end
    GUI.wnd.visible = false
	setTimer(destroyElement, 100, 1, GUI.wnd)
    setPlayerUI(false)
end

function Trucker.onClientGUIClickBtnChangeTruckerState()
    if (localPlayer:getData("player:isTrucker")) then
        Trucker.renderConfirmWindowOnClientStopWork()
    else
        TruckRental.openWindow()
    end
    Trucker.setWindowVisible(false)
end

function Trucker.renderConfirmWindowOnClientStopWork()
    local message = 'Вы действительно хотите завершить рабочую смену?\n\nМы заберем арендованный транспорт и снимем неустойку за отказ от заказа.'
    GUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onTruckerGUIConfirmWindowStopWork', 'onTruckerGUIConfirmWindowCancel', 'onTruckerGUIConfirmWindowCancel')
    exports.tmtaGUI:confirmSetBtnOkLabel(GUI.confirmWindow, 'Завершить')

    return GUI.confirmWindow
end

function onTruckerGUIConfirmWindowCancel()
    Trucker.closeWindow()
    triggerEvent('tmtaTrucker.onTruckerGUIConfirmWindowCancel', localPlayer)
end

function onTruckerGUIConfirmWindowStopWork()
    Trucker.closeWindow()
    triggerEvent('tmtaTrucker.onTruckerGUIConfirmWindowStopWork', localPlayer)
    triggerServerEvent("tmtaTrucker.onPlayerStopWork", resourceRoot, localPlayer)
end

function Trucker.onPlayerMarkerHit(player, matchingDimension)
    if (player ~= localPlayer or player.vehicle or not matchingDimension) then
        return
    end

    local verticalDistance = localPlayer.position.z - source.position.z
    if (verticalDistance > 5 or verticalDistance < -1) then
        return
    end

    Trucker.openWindow()
    Base.setPlayerCurrentBase(source)
end

function Trucker.onPlayerMarkerLeave(player, matchingDimension)
    if (player ~= localPlayer or not matchingDimension) then
        return
    end

    Trucker.closeWindow()
    Base.setPlayerCurrentBase(nil)
end