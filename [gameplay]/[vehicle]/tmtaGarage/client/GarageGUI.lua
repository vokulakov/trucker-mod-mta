GarageGUI = {}
GarageGUI.visible = false

GarageGUI._cerrentSelectVehicle = nil

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

GarageGUI.params = {}
GarageGUI.params['windowTitle'] = "Личный транспорт [F3]"
GarageGUI.params['bindKey'] = 'f3'

local width, height = 500, 450

GarageGUI.wnd = guiCreateWindow(0, 0, sW*((width) /sDW), sH*((height) /sDH), GarageGUI.params['windowTitle'], false)
exports.tmtaGUI:windowCentralize(GarageGUI.wnd)
guiWindowSetSizable(GarageGUI.wnd, false)
guiWindowSetMovable(GarageGUI.wnd, false)
GarageGUI.wnd.alpha = 0.8
GarageGUI.wnd.visible = false

GarageGUI.vehicleList = guiCreateGridList(10, 28, 300, 380, false, GarageGUI.wnd)
guiGridListSetSelectionMode(GarageGUI.vehicleList, 0)
guiGridListSetSortingEnabled(GarageGUI.vehicleList, false)

guiGridListAddColumn(GarageGUI.vehicleList, "Транспортное средство", 0.6)
guiGridListAddColumn(GarageGUI.vehicleList, "Госномер", 0.34)

--
local lbl = guiCreateLabel(10, 410, 300, 36, 'Парковочных мест', false, GarageGUI.wnd)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "center")
guiLabelSetColor(lbl, 10, 183, 220)

GarageGUI.lblGarageSlot = guiCreateLabel(10, 425, 300, 36, '0 из 0', false, GarageGUI.wnd)
guiLabelSetHorizontalAlign(GarageGUI.lblGarageSlot, "center")

--
local lbl = guiCreateLabel(300, 30, 200, 36, 'Транспортное средство', false, GarageGUI.wnd)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "center")
guiLabelSetColor(lbl, 10, 183, 220)

GarageGUI.lblVehicleName = guiCreateLabel(300, 50, 200, 36, '', false, GarageGUI.wnd)
guiLabelSetHorizontalAlign(GarageGUI.lblVehicleName, "center")

--
local lbl = guiCreateLabel(320, 80, 200, 36, 'Госномер:', false, GarageGUI.wnd)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "left")
guiLabelSetColor(lbl, 10, 183, 220)

local offsetX = guiLabelGetTextExtent(lbl)+10
GarageGUI.lblVehicleNumberPlate = guiCreateLabel(320+offsetX, 80, 200, 36, '-', false, GarageGUI.wnd)

--
local lbl = guiCreateLabel(320, 100, 200, 36, 'Пробег:', false, GarageGUI.wnd)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "left")
guiLabelSetColor(lbl, 10, 183, 220)

local offsetX = guiLabelGetTextExtent(lbl)+10
GarageGUI.lblVehicleMileage = guiCreateLabel(320+offsetX, 100, 200, 36, '-', false, GarageGUI.wnd)

--
local lbl = guiCreateLabel(320, 120, 200, 36, 'Топливо:', false, GarageGUI.wnd)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "left")
guiLabelSetColor(lbl, 10, 183, 220)

local offsetX = guiLabelGetTextExtent(lbl)+10
GarageGUI.lblVehicleFuel = guiCreateLabel(320+offsetX, 120, 200, 36, '-', false, GarageGUI.wnd)

--
local lbl = guiCreateLabel(320, 140, 200, 36, 'Состояние:', false, GarageGUI.wnd)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "left")
guiLabelSetColor(lbl, 10, 183, 220)

local offsetX = guiLabelGetTextExtent(lbl)+5
GarageGUI.lblVehicleHP = guiCreateLabel(320+offsetX, 140, 200, 36, '-', false, GarageGUI.wnd)

--
GarageGUI.btnVehicleSpawn = guiCreateButton(320, 170, 170, 35, "Выгнать", false, GarageGUI.wnd)
guiSetFont(GarageGUI.btnVehicleSpawn, "default-bold-small")
guiSetProperty(GarageGUI.btnVehicleSpawn, "NormalTextColour", "FF01D51A")
guiSetEnabled(GarageGUI.btnVehicleSpawn, false)

GarageGUI.btnVehicleDestroy = guiCreateButton(320, 210, 170, 30, "Загнать", false, GarageGUI.wnd)
guiSetFont(GarageGUI.btnVehicleDestroy, "default-bold-small")
guiSetProperty(GarageGUI.btnVehicleDestroy, "NormalTextColour", "FFCE070B")
guiSetEnabled(GarageGUI.btnVehicleDestroy, false)

GarageGUI.btnVehicleAllDestroy = guiCreateButton(320, 245, 170, 25, "Загнать все", false, GarageGUI.wnd)
guiSetFont(GarageGUI.btnVehicleAllDestroy, "default-bold-small")

GarageGUI.btnVehicleSell = guiCreateButton(320, 28+380-35, 170, 35, "Продать", false, GarageGUI.wnd)
guiSetFont(GarageGUI.btnVehicleSell, "default-bold-small")
guiSetEnabled(GarageGUI.btnVehicleSell, false)


function GarageGUI.updateVehicleList(playerVehicles)
    local vehicleSelected = guiGridListGetSelectedItem(GarageGUI.vehicleList)
    guiGridListClear(GarageGUI.vehicleList)

    if (type(playerVehicles) == 'table' and #playerVehicles > 0) then
        for _, vehicle in ipairs(playerVehicles) do
            local name = Utils.getVehicleNameFromModel(vehicle.model)
            if name then
                local row = guiGridListAddRow(GarageGUI.vehicleList)
    
                local numberPlate = '-'
                if (vehicle.numberPlateType and vehicle.numberPlate) then
                    numberPlate = exports.tmtaVehicleLicensePlate:formatLicensePlateToString(vehicle.numberPlateType, vehicle.numberPlate)
                end
    
                guiGridListSetItemText(GarageGUI.vehicleList, row, 1, utf8.len(name) >= 22 and utf8.sub(name, 0, 22) .. '...' or name, false, true)
                guiGridListSetItemData(GarageGUI.vehicleList, row, 1, {
                    userVehicleId = vehicle.userVehicleId,
                    model = vehicle.model,
                    name = name,
                    price = vehicle.price,
                    fuel = vehicle.fuel,
                    health = vehicle.health,
                    mileage = vehicle.mileage,
                    numberPlate = numberPlate,
                })
    
                guiGridListSetItemText(GarageGUI.vehicleList, row, 2, numberPlate, false, true)
            end
        end
    end

    guiGridListSetSelectedItem(GarageGUI.vehicleList, vehicleSelected, 1)
	GarageGUI.updateLabelGarageSlot()
    GarageGUI.onClientGUISelectVehicle()
end

function GarageGUI.updateLabelGarageSlot()
    GarageGUI.lblGarageSlot.text = exports.tmtaVehicle:getPlayerVehiclesCount()..' из '..getPlayerGarageSlotCount()
end

function GarageGUI.setVisible(state)
    GarageGUI.visible = (type(state) == 'boolean') and state or not GarageGUI.wnd.visible

    exports.tmtaUI:setPlayerComponentVisible("dashboard", not GarageGUI.visible)
	exports.tmtaUI:setPlayerComponentVisible("all", not GarageGUI.visible, {"notifications"})
	exports.tmtaUI:setPlayerBlurScreen(GarageGUI.visible)
	showCursor(GarageGUI.visible)
	showChat(not GarageGUI.visible)

    if (GarageGUI.visible) then
        GarageGUI.onClientGUISelectVehicle()
    end

    if (isElement(GarageGUI.confirmWindow)) then
        destroyElement(GarageGUI.confirmWindow)
    end
    
	GarageGUI.wnd.visible = GarageGUI.visible
end

function GarageGUI.getSelectedVehicle()
    if (not isElement(GarageGUI.vehicleList)) then
        return GarageGUI._cerrentSelectVehicle
    end

    local selectedItem = guiGridListGetSelectedItem(GarageGUI.vehicleList)

    if (selectedItem == -1) then
        GarageGUI._cerrentSelectVehicle = nil
        return false
    end

    GarageGUI._cerrentSelectVehicle = selectedItem
    return guiGridListGetItemData(GarageGUI.vehicleList, selectedItem, 1)
end

function GarageGUI.onClientGUISelectVehicle()
    local vehicle = GarageGUI.getSelectedVehicle()
    if (not vehicle or type(vehicle) ~= 'table') then
        GarageGUI.btnVehicleSpawn.enabled = false
		GarageGUI.btnVehicleDestroy.enabled = false
		GarageGUI.btnVehicleSell.enabled = false

		GarageGUI.btnVehicleSell.text = 'Продать'
        GarageGUI.lblVehicleName.text = ''
        GarageGUI.lblVehicleFuel.text = '-'
        GarageGUI.lblVehicleHP.text = '-'
        GarageGUI.lblVehicleNumberPlate.text = '-'
        GarageGUI.lblVehicleMileage.text = '-'
        return
    end

    GarageGUI.btnVehicleSpawn.enabled = true
    GarageGUI.btnVehicleSell.enabled = true
    GarageGUI.btnVehicleDestroy.enabled = false

    local price = tonumber(vehicle.price - (vehicle.price * Config.SELL_COMMISSION/100))
    GarageGUI.btnVehicleSell.text = "Продать за "..tostring(exports.tmtaUtils:formatMoney(price)) .." ₽"

    GarageGUI.lblVehicleName.text = vehicle.name
    GarageGUI.lblVehicleNumberPlate.text = vehicle.numberPlate

    local fuel = vehicle.fuel
    local health = vehicle.health
    local mileage = vehicle.mileage

    local vehicle = exports.tmtaVehicle:getVehicleById(vehicle.userVehicleId)
    if isElement(vehicle) then
        GarageGUI.btnVehicleSpawn.enabled = false
        GarageGUI.btnVehicleDestroy.enabled = true
        fuel = vehicle:getData('fuel') 
        health = vehicle.health
        mileage = vehicle:getData('mileage')
    end

    GarageGUI.lblVehicleFuel.text = math.floor(fuel)..' л'
    GarageGUI.lblVehicleHP.text = math.floor(health/10)..'%'

    local mileage = exports.tmtaUtils:convertMetersToKm(mileage)
    GarageGUI.lblVehicleMileage.text = math.floor(mileage)..' км'
end
addEventHandler('onClientGUIClick', GarageGUI.vehicleList, GarageGUI.onClientGUISelectVehicle, false)

function GarageGUI.onPlayerClickBtnVehicleSell()
    GarageGUI.wnd.visible = false

    local vehicle = GarageGUI.getSelectedVehicle()
    local price = tonumber(vehicle.price - (vehicle.price * Config.SELL_COMMISSION/100))
    local message = string.format("Вы действительно хотите продать %s государству за %s ₽ ?\nЕсли на транспорте установлен номерной знак, то он будет удален навсегда.", vehicle.name, exports.tmtaUtils:formatMoney(price))

    GarageGUI.confirmWindow = exports.tmtaGUI:createConfirm(message, 'onGarageConfirmWindowSell', 'onGarageConfirmWindowClose', 'onGarageConfirmWindowClose')
    exports.tmtaGUI:confirmSetBtnOkLabel(GarageGUI.confirmWindow, 'Продать')
    
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end
addEventHandler('onClientGUIClick', GarageGUI.btnVehicleSell, GarageGUI.onPlayerClickBtnVehicleSell, false)

function onGarageConfirmWindowClose()
    GarageGUI.setVisible(true)
end

function onGarageConfirmWindowSell()
    GarageGUI.setVisible(false)
    Garage.sellVehicle(GarageGUI.getSelectedVehicle())
end

addEventHandler('onClientGUIClick', resourceRoot, 
    function()
        if not GarageGUI.visible then
            return
        end

        local vehicle = GarageGUI.getSelectedVehicle()
        if (vehicle and type(vehicle) == 'table') then
            if (source == GarageGUI.btnVehicleSpawn) then
                Garage.spawnVehicle(vehicle)
            elseif (source == GarageGUI.btnVehicleDestroy) then
                Garage.destroyVehicle(vehicle)
            end
        end

        if (source == GarageGUI.btnVehicleAllDestroy) then
            Garage.returnVehiclesToGarage(vehicle)
        end
    end
)

addEventHandler('tmtaDashboard.onChangeVisible', root,
	function()
		if not GarageGUI.visible then
			return
		end
        GarageGUI.setVisible(false)
	end
)

bindKey(GarageGUI.params['bindKey'], 'down', 
    function()
        if (localPlayer.interior ~= 0 or localPlayer.dimension ~= 0) then
            return
        end

        if (not GarageGUI.visible and not exports.tmtaUI:isPlayerComponentVisible("all")) then
            return
        end

        triggerServerEvent('tmtaGarage.getPlayerVehicles', resourceRoot)
        GarageGUI.setVisible()
    end
)