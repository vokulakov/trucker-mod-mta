TruckRental = {}

local GUI = {}

local width, height = 650, 450

function TruckRental.renderWindow()
    GUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(GUI.wnd)
    guiWindowSetSizable(GUI.wnd, false)
    guiWindowSetMovable(GUI.wnd, false)
    GUI.wnd.alpha = 0.9

    --
    local offsetPosY = 25
    local lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(offsetPosY/sDH), sW*(width/sDW), sH*(40/sDH), "АРЕНДА\nТРАНСПОРТА", false, GUI.wnd)
    guiSetFont(lblTitle, guiFont.RB_10)
    lblTitle.enabled = false

    GUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(offsetPosY/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, GUI.wnd)
    guiSetFont(GUI.btnClose, guiFont.RB_10)
    guiSetProperty(GUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", GUI.btnClose, 
        function()
            TruckRental.closeWindow()
            Trucker.closeWindow()
        end, false)

    local line = exports.tmtaTextures:createStaticImage(sW*((width-35-10)/sDW), sH*(offsetPosY/sDH), 1, sH*(25/sDH), 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    GUI.btnBack = guiCreateButton(sW*((width-80-35-20)/sDW), sH*(offsetPosY/sDH), sW*(80/sDW), sH*(25/sDH), 'Назад', false, GUI.wnd)
    guiSetFont(GUI.btnBack, guiFont.RR_10)
    addEventHandler("onClientGUIClick", GUI.btnBack, 
        function()
            TruckRental.closeWindow()
            Trucker.setWindowVisible(true)
        end, false)

    offsetPosY = offsetPosY + 35
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 10
    GUI.truckList = guiCreateGridList(10, sH*((offsetPosY)/sDH), sW*(width/sDW), sH*((height-140)/sDH), false, GUI.wnd)
    guiGridListSetSortingEnabled(GUI.truckList, false)

    guiGridListAddColumn(GUI.truckList, "№", 0.07)
	guiGridListAddColumn(GUI.truckList, "Название", 0.25)
    guiGridListAddColumn(GUI.truckList, "Макс. груз", 0.1)
    guiGridListAddColumn(GUI.truckList, "Требование", 0.15)
    guiGridListAddColumn(GUI.truckList, "Условия аренды", 0.15)
    guiGridListAddColumn(GUI.truckList, "Категория", 0.25)

    TruckRental.renderTruckList()

    addEventHandler("onClientGUIClick", GUI.truckList, 
        function()
            local truck = TruckRental.getSelectedTruck()

            local btnRentText = "Арендовать"
            if not not truck then
                local price = exports.tmtaUtils:formatMoney(truck.price)
                btnRentText = string.format("%s %s за %s ₽/час", btnRentText, truck.name, price)
            end

            guiSetEnabled(GUI.btnRent, not not truck)
            guiSetText(GUI.btnRent, btnRentText)
        end, false)

    --
    offsetPosY = offsetPosY + (height-140) + 10
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    offsetPosY = offsetPosY + 10
    GUI.btnRent = guiCreateButton(10, sH*((offsetPosY)/sDH), sW*(width/sDW), sH*(40/sDH), "Арендовать", false, GUI.wnd)
    guiSetProperty(GUI.btnRent, "NormalTextColour", "ff00b9ff")
    guiSetFont(GUI.btnRent, guiFont.RR_11)
    guiSetEnabled(GUI.btnRent, false)
    addEventHandler("onClientGUIClick", GUI.btnRent, TruckRental.onClientGUIClickBtnRent, false)
end

local _truckList = nil
function TruckRental.renderTruckList()
    if not _truckList then
        _truckList = {}
        for truckId, truck in ipairs(Config.TRUCK_RENT) do
            local truckData = exports.tmtaTruck:getTruckConfigByModel(truck.model)
            local truckTypeStr = exports.tmtaTruck:getTruckTypeNameByModel(truck.model)
            if (truckData and truckTypeStr) then
                truckData.name = Utils.getVehicleNameFromModel(truck.model)
                truckData.loadCapacityStr = (truckData.loadCapacity) and Utils.formatWeightToString(truckData.loadCapacity) or '-'
                truckData.priceStr = exports.tmtaUtils:formatMoney(truck.price)
                truckData.typeStr = truckTypeStr

                _truckList[truckId] = exports.tmtaUtils:extendTable(truck, truckData)
            end
        end
    end
   
    for truckId, truck in pairs(_truckList) do
        local row = guiGridListAddRow(
            GUI.truckList,
            truckId..".",
            "  "..Utils.subStr(truck.name, 30),
            "  "..truck.loadCapacityStr,
            "["..truck.level.." уровень]",
            "  "..truck.priceStr.." ₽/час",
            "  "..truck.typeStr
        )

        guiGridListSetItemData(GUI.truckList, row, 1, truckId)

        local r, g, b = 255, 255, 255
        if (truck.level > exports.tmtaExperience:getPlayerLvl()) then
            r, g, b = 170, 0, 0
        end

        for i = 1, 6 do 
            guiGridListSetItemColor(GUI.truckList, row, i, r, g, b, 255)
        end
    end
end

function TruckRental.openWindow()
    if isElement(GUI.wnd) then 
        return 
    end
    TruckRental.renderWindow()
end 

function TruckRental.closeWindow()
    if not isElement(GUI.wnd) then 
        return 
    end 
    GUI.wnd.visible = false
	setTimer(destroyElement, 100, 1, GUI.wnd)
end

function TruckRental.getSelectedTruck()
    if (not isElement(GUI.truckList)) then
        return false
    end

    local truckId = guiGridListGetItemData(GUI.truckList, guiGridListGetSelectedItem(GUI.truckList), 1) or ""

    if (not _truckList[truckId]) then
        return false
    end
    
    return _truckList[truckId]
end

function TruckRental.onClientGUIClickBtnRent()
    local truck = TruckRental.getSelectedTruck()
    if not truck then
        return
    end

    if (truck.level > exports.tmtaExperience:getPlayerLvl() and not exports.tmtaCore:isTestServer()) then
        return Utils.showNotice("Вашего опыта не хватает для аренды #FFA07A"..truck.name)
    elseif (exports.tmtaMoney:getPlayerMoney() < tonumber(truck.price)) then
        return Utils.showNotice("У вас нехватает денежных средств для аренды #FFA07A"..truck.name)
    end

    triggerServerEvent('tmtaTrucker.onPlayerStartTruckRent', resourceRoot, Base.getPlayerCurrentBase(), truck)
    
    TruckRental.closeWindow()
    Trucker.closeWindow()
end

GUI.extendRent = {}

function TruckRental.renderExtendRentWindow(truckData, timeLeft)
    local width, height = 470, 230

    GUI.extendRent.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), "", false)
    exports.tmtaGUI:windowCentralize(GUI.extendRent.wnd)
    guiWindowSetSizable(GUI.extendRent.wnd, false)
    guiWindowSetMovable(GUI.extendRent.wnd, false)
    GUI.extendRent.wnd.alpha = 0.8

    --
    local offsetPosY = 25
    local lblTitle = guiCreateLabel(sW*((15)/sDW), sH*(offsetPosY/sDH), sW*(width/sDW), sH*(40/sDH), "АРЕНДА\nТРАНСПОРТА", false, GUI.extendRent.wnd)
    guiSetFont(lblTitle, guiFont.RB_10)
    lblTitle.enabled = false

    --
    offsetPosY = offsetPosY + 35
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.extendRent.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    -- -- Icon
    local iconSize = 96/2
    local icon = exports.tmtaTextures:createStaticImage(sW*((0) /sDW), sH*((height+10-iconSize)/2 /sDH), sW*(iconSize /sDW), sH*(iconSize /sDH), 'ui_i_question', false, GUI.extendRent.wnd)
    icon.enabled = false

    local offesetPosX = 15+iconSize
    offsetPosY = offsetPosY + 10

    local message = "До конца аренды %s осталось %s мин. Стоимость продления аренды составляет %s ₽/час. Вы хотите продлить аренду?"
    message = message.."\n\nВнимание! В случае отказа от аренды, транспорт будет эвакуирован на базу после завершения рейса!"

    timeLeft = string.format('%02d:%02d', exports.tmtaUtils:convertMsToTimeStr(timeLeft))
    message = string.format(message, truckData.name, timeLeft, truckData.price)

    local lbl = guiCreateLabel(sW*((offesetPosX) /sDW), sH*(offsetPosY/sDH), sW*((width-35-40) /sDW), sH*(height/sDH), message, false, GUI.extendRent.wnd)
    guiLabelSetHorizontalAlign(lbl, 'left', true)
    guiSetFont(lbl, guiFont.RR_10)
    lbl.enabled = false

    --
    local line = exports.tmtaTextures:createStaticImage(10, sH*((height-40-10)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.extendRent.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    GUI.extendRent.btnRefuse = guiCreateButton(sW*((10) /sDW), sH*((height-40) /sDH), sW*((width/2-15) /sDW), sH*((30) /sDH), 'Отказаться', false, GUI.extendRent.wnd)
    guiSetFont(GUI.extendRent.btnRefuse, guiFont.RR_11)

    addEventHandler('onClientGUIClick', GUI.extendRent.btnRefuse, 
        function()
            destroyElement(GUI.extendRent.wnd)
            showCursor(false)
            triggerServerEvent("tmtaTrucker.onPlayerRefuseRent", resourceRoot, localPlayer)
        end, false)

    GUI.extendRent.btnExtend = guiCreateButton(sW*((width/2+5) /sDW), sH*((height-40) /sDH), sW*((width/2-10) /sDW), sH*((30) /sDH), 'Продлить аренду', false, GUI.extendRent.wnd)
    guiSetProperty(GUI.extendRent.btnExtend, "NormalTextColour", "FF01D51A")
    guiSetFont(GUI.extendRent.btnExtend, guiFont.RR_11)

    addEventHandler('onClientGUIClick', GUI.extendRent.btnExtend, 
        function()
            destroyElement(GUI.extendRent.wnd)
            showCursor(false)
            triggerServerEvent("tmtaTrucker.onPlayerExtendRent", resourceRoot, localPlayer)
        end, false)

    showCursor(true)
end

addEvent('tmtaTrucker.onClientTruckRentalExpired', true)
addEventHandler('tmtaTrucker.onClientTruckRentalExpired', resourceRoot,
    function(truckData, timeLeft)
        local player = source
        if (not isElement(player) or type(truckData) ~= 'table' or type(timeLeft) ~= 'number') then 
            return
        end

        if isElement(GUI.extendRent.wnd) then
            return
        end

        local sound = exports.tmtaSounds:playSound('ui_info')
        setSoundVolume(sound, 0.2)
       
        Trucker.closeWindow()
        Cargo.closeWindow()
        TruckRental.renderExtendRentWindow(truckData, timeLeft)
    end
)

addEventHandler('onClientVehicleEnter', root, 
    function(player, seat)
        local truck = source
        if (
            not exports.tmtaTruck:isTruck(truck) or
            not truck:getData('truck:isRent') or
            player ~= localPlayer or 
            seat ~= 0 or
            truck:getData("truck:player") == player
        ) then
            return
        end

        Utils.showNotice("У вас нет ключей от данного транспорта")
        setPedControlState(player, "enter_exit", true)
    end
)