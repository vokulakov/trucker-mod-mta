RoadsideAssistance = {}

local REPAIR_PRICE = 15
local REFUEL_PRICE = 120
local DEFAULT_PRICE = 500

local GUI = {}

--[[
local width, height = 450, 300
function RoadsideAssistance.renderWindow()
    GUI.wnd = guiCreateWindow(sW*(0/sDW), sH*(0/sDH), sW*(width/sDW), sH*(height/sDH), '', false)
    exports.tmtaGUI:windowCentralize(GUI.wnd)
    guiWindowSetSizable(GUI.wnd, false)
    guiWindowSetMovable(GUI.wnd, false)
    GUI.wnd.alpha = 0.8

    --
    local offsetPosY = 25
    GUI.btnClose = guiCreateButton(sW*((width-35)/sDW), sH*(offsetPosY/sDH), sW*(25/sDW), sH*(25/sDH), 'Х', false, GUI.wnd)
    guiSetFont(GUI.btnClose, guiFont.RB_10)
    guiSetProperty(GUI.btnClose, "NormalTextColour", "FFCE070B")
    addEventHandler("onClientGUIClick", GUI.btnClose, RoadsideAssistance.closeWindow, false)

    local line = exports.tmtaTextures:createStaticImage(sW*((width-35-10)/sDW), sH*(offsetPosY/sDH), 1, sH*(25/sDH), 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    GUI.btnBack = guiCreateButton(sW*((width-80-35-20)/sDW), sH*(offsetPosY/sDH), sW*(80/sDW), sH*(25/sDH), 'Назад', false, GUI.wnd)
    guiSetFont(GUI.btnBack, guiFont.RR_10)

    local lblTitle = guiCreateLabel(sW*((15)/sDW), sH*((offsetPosY)/sDH), sW*(width/sDW), sH*((25)/sDH), "СЛУЖБА ПОМОЩИ НА ДОРОГЕ", false, GUI.wnd)
    guiSetFont(lblTitle, guiFont.RB_10)
    guiLabelSetVerticalAlign(lblTitle, "center", false)
    lblTitle.enabled = false

    offsetPosY = offsetPosY + 35
    local line = exports.tmtaTextures:createStaticImage(10, sH*((offsetPosY)/sDH), sW*(width/sDW), 1, 'part_dot', false, GUI.wnd)
    guiSetProperty(line, "ImageColours", 'tl:FF696969 tr:FF696969 bl:FF696969 br:FF696969')
    line.enabled = false

    --
    offsetPosY = offsetPosY + 10
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'Диспетчер:', false, GUI.wnd)
    guiSetFont(lbl, guiFont.RB_10)
    guiLabelSetColor(lbl, 242, 171, 18)
    lbl.enabled = false

    local offsetPosX = guiLabelGetTextExtent(lbl)+5
    local lbl = guiCreateLabel(10+offsetPosX, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), '- Здравствуйте! Вы обратились в службу', false,  GUI.wnd)
    guiSetFont(lbl, guiFont.RR_10)
    lbl.enabled = false

    offsetPosY = offsetPosY + 15
    local lbl = guiCreateLabel(10, sH*(offsetPosY/sDH), sW*(width/sDW), sH*(30/sDH), 'помощи на дороге. Чем мы можем вам помочь?', false,  GUI.wnd)
    guiSetFont(lbl, guiFont.RR_10)
    lbl.enabled = false

    --
end
]]

local addFuelCount = 0
local addHealthCount = 0
local totalPrice = 0

function RoadsideAssistance.openWindow()
    local truck = Utils.getPlayerTruck(localPlayer, true)
    if not isElement(truck) then
        return
    end

    local currentSpeed = getDistanceBetweenPoints3D(0, 0, 0, getElementVelocity(truck)) * 180 -- в км
    if (currentSpeed > 20) then
        return Utils.showNotice('Остановите транспорт, чтобы впоспользоваться #FFA07Aтехнической помощью на дороге!')
    end

    setElementVelocity(truck, 0, 0, 0)

    local curHealth = getElementHealth(truck)

    local curFuel = truck:getData('fuel') or 0
	local fuelMax = truck:getData('fuelMax') or 0
    local curFuelPercent = (fuelMax/curFuel)*100

    addFuelCount = 0
    addHealthCount = 0
    totalPrice = DEFAULT_PRICE

    if (curFuelPercent < 20) then
        addFuelCount = math.floor(((fuelMax*20)/100)-curFuel)
        totalPrice = math.floor(addFuelCount*REFUEL_PRICE)
    end

    if (curHealth < 600) then
        addHealthCount = math.floor(600-curHealth)
        totalPrice = totalPrice + math.floor(addHealthCount*REPAIR_PRICE)
    end

    if (addFuelCount ~= 0 or addHealthCount ~= 0 or not Utils.isVehicleWheelOnGround(truck)) then
        local message = string.format(
            "Вы уверены, что хотите воспользоваться услугами технической помощи?\nДвигатель вашего транспорт будет восстановлен и заправлен на %s л за %s ₽",
            addFuelCount,
            exports.tmtaUtils:formatMoney(totalPrice)
        )
    
        Cargo.setWindowVisible(false)
        GUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onTruckerGUIConfirmWindowAcceptTruckMaintenance', 'onTruckerGUIConfirmWindowTruckMaintenanceCancel', 'onTruckerGUIConfirmWindowTruckMaintenanceCancel')
        exports.tmtaGUI:confirmSetBtnCancelLabel(GUI.confirmWindow, 'Отказаться')
        exports.tmtaGUI:confirmSetBtnOkLabel(GUI.confirmWindow, 'Принять')
    else
        return Utils.showNotice("Ваш транспорт не нуждается в технической помощи!")
    end
end

function onTruckerGUIConfirmWindowTruckMaintenanceCancel()
    Cargo.setWindowVisible(true)
end

function onTruckerGUIConfirmWindowAcceptTruckMaintenance()
    Cargo.closeWindow()

    local truck = Utils.getPlayerTruck(localPlayer, true)
    if not isElement(truck) then
        return
    end

    triggerServerEvent('tmtaTrucker.onPlayerTruckMaintenance', localPlayer, truck, addFuelCount, addHealthCount, totalPrice)
end

function RoadsideAssistance.closeWindow()
end