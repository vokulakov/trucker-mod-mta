Garage = {}
Garage.visible = true

local sW, sH = guiGetScreenSize()

Window_VS = guiCreateWindow(sW/2-500/2, sH/2-450/2, 500, 450, "Личный транспорт [F3]",false)
guiSetAlpha(Window_VS, 0.88)
guiWindowSetMovable(Window_VS, false)
guiWindowSetSizable(Window_VS, false)
guiSetVisible(Window_VS, false)

Grid_VS = guiCreateGridList(10, 28, 300, 380, false, Window_VS)
guiGridListSetSelectionMode(Grid_VS, 0)
guiGridListSetSortingEnabled(Grid_VS, false)

guiGridListAddColumn(Grid_VS, "Транспортное средство", 0.6)
--guiGridListAddColumn(Grid_VS, "Пробег", 0.15)
--guiGridListAddColumn(Grid_VS, "Топливо", 0.15)
guiGridListAddColumn(Grid_VS, "Госномер", 0.34)
guiSetAlpha(Window_VS, 0.88)
--
lbl = guiCreateLabel(10, 410, 300, 36, 'Парковочных мест', false, Window_VS)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "center")
guiLabelSetColor(lbl, 10, 183, 220)

lbl_limit_veh = guiCreateLabel(10, 425, 300, 36, '0 из 0', false, Window_VS)
guiLabelSetHorizontalAlign(lbl_limit_veh, "center")
--
lbl = guiCreateLabel(300, 30, 200, 36, 'Транспортное средство', false, Window_VS)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "center")
guiLabelSetColor(lbl, 10, 183, 220)

lbl_veh_name = guiCreateLabel(300, 50, 200, 36, '', false, Window_VS)
guiLabelSetHorizontalAlign(lbl_veh_name, "center")
--
lbl = guiCreateLabel(320, 80, 200, 36, 'Госномер:', false, Window_VS)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "left")
guiLabelSetColor(lbl, 10, 183, 220)

lbl_veh_number = guiCreateLabel(320, 80, 200, 36, '-', false, Window_VS)
guiLabelSetHorizontalAlign(lbl_veh_number, "center")
--
lbl = guiCreateLabel(320, 100, 200, 36, 'Пробег:', false, Window_VS)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "left")
guiLabelSetColor(lbl, 10, 183, 220)

lbl_veh_mileage = guiCreateLabel(320, 100, 200, 36, '-', false, Window_VS)
guiLabelSetHorizontalAlign(lbl_veh_mileage, "center")
--
lbl = guiCreateLabel(320, 120, 200, 36, 'Топливо:', false, Window_VS)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "left")
guiLabelSetColor(lbl, 10, 183, 220)

lbl_veh_fuel = guiCreateLabel(320, 120, 200, 36, '-', false, Window_VS)
guiLabelSetHorizontalAlign(lbl_veh_fuel, "center")
--
lbl = guiCreateLabel(320, 140, 200, 36, 'Состояние:', false, Window_VS)
guiSetFont(lbl, "default-bold-small")
guiLabelSetHorizontalAlign(lbl, "left")
guiLabelSetColor(lbl, 10, 183, 220)

lbl_veh_hp = guiCreateLabel(320, 140, 200, 36, '-', false, Window_VS)
guiLabelSetHorizontalAlign(lbl_veh_hp, "center")

Button_VS_spawn = guiCreateButton(320, 170, 170, 35, "Респавн", false, Window_VS)
guiSetFont(Button_VS_spawn, "default-bold-small")
guiSetProperty(Button_VS_spawn, "NormalTextColour", "FF01D51A")
guiSetEnabled(Button_VS_spawn, false)

Button_VS_destroy = guiCreateButton(320, 210, 170, 30, "Убрать", false, Window_VS)
guiSetFont(Button_VS_destroy, "default-bold-small")
guiSetProperty(Button_VS_destroy, "NormalTextColour", "FFCE070B")
guiSetEnabled(Button_VS_destroy, false)

Button_VS_destroy_all = guiCreateButton(320, 245, 170, 25, "Убрать все", false, Window_VS)
guiSetFont(Button_VS_destroy_all, "default-bold-small")

Button_VS_sell = guiCreateButton(320, 348, 170, 35, "Продать", false, Window_VS)
guiSetFont(Button_VS_sell, "default-bold-small")
guiSetEnabled(Button_VS_sell, false)

Button_VS_reset_handlings = guiCreateButton(320, 388, 170, 20, "Сбросить настройки", false, Window_VS)
guiSetFont(Button_VS_reset_handlings, "default-bold-small")
guiSetEnabled(Button_VS_reset_handlings, false)


function Garage.updateGridList(vehicles, parking_lots)
	if not vehicles then 
		return
	end 
	local rw, cl = guiGridListGetSelectedItem(Grid_VS)
	guiGridListClear(Grid_VS)
	for i, vehicle in ipairs(vehicles) do
		local carName = customCarNames[tonumber(vehicle['model'])] or getVehicleNameFromModel(vehicle["model"])
		local ID = vehicle["ID"]

		local row = guiGridListAddRow(Grid_VS)
		
		guiGridListSetItemText(Grid_VS, row, 1, utf8.sub(carName, 0, 22) .. '...', false, true)
		guiGridListSetItemData(Grid_VS, row, 1, ID)

		local vehicleData = {
			fuel = math.floor(vehicle["fuel"]),
			mileage = vehicle["mileage"],
			healt = vehicle["health"],
			number = fromJSON(vehicle["number"])[2],
			price = vehicle["price"]
		}

		guiGridListSetItemText(Grid_VS, row, 2, vehicleData.number, false, true)
		guiGridListSetItemData(Grid_VS, row, 2, vehicleData)
	end
	guiGridListSetSelectedItem(Grid_VS, rw, cl)

	lbl_limit_veh.text = #vehicles..' из '..parking_lots
end
addEvent("tmtaVehCarshop.onPlayerUpdateVehicles", true)
addEventHandler("tmtaVehCarshop.onPlayerUpdateVehicles", root, Garage.updateGridList)

addEventHandler("onClientGUIClick", root, function()
	if not Window_VS.visible then
		return
	end

	local item = guiGridListGetSelectedItem(Grid_VS)
	local ID = guiGridListGetItemData(Grid_VS, item, 1)
	local carName = guiGridListGetItemText(Grid_VS, item, 1)
	local carData = guiGridListGetItemData(Grid_VS, item, 2)

	-- если в списке не выбрано ни одно авто, то кнопки делать неактивными
	if item ~= -1 then 
		Button_VS_spawn.enabled = true
		Button_VS_destroy.enabled = true
		--Button_VS_reset_handlings.enabled = true
		Button_VS_sell.enabled = true
		Button_VS_sell.text = "Продать за "..convertNumber(carData.price*.7).." ₽"

		lbl_veh_name.text = carName
		lbl_veh_number.text = carData.number
		lbl_veh_fuel.text = carData.fuel..' л'

		local mileage = fromJSON(carData.mileage)
		lbl_veh_mileage.text = math.floor(mileage.km)..' км'
		lbl_veh_hp.text = math.floor(carData.healt/10)..'%'
	else 
		Button_VS_spawn.enabled = false
		Button_VS_destroy.enabled = false
		Button_VS_sell.enabled = false

		Button_VS_sell.text = 'Продать'
		--Button_VS_reset_handlings.enabled = false

		lbl_veh_name.text = ''
		lbl_veh_number.text = '-'
		lbl_veh_fuel.text = '-'
		lbl_veh_mileage.text = '-'
		lbl_veh_hp.text = '-'
		
	end
	
	if (source == Button_VS_spawn) then
		triggerServerEvent("tmtaVehCarshop.spawnPlayerVehicle", localPlayer, tonumber(ID))
		Garage.setWindowVisible(false)
	elseif (source == Button_VS_destroy) then 
		triggerServerEvent("tmtaVehCarshop.destroyPlayerVehicle", localPlayer, tonumber(ID))
	elseif (source == Button_VS_destroy_all) then 
		triggerServerEvent("tmtaVehCarshop.destroyPlayerAllVehicles", localPlayer)
	elseif (source == Button_VS_sell) then 
		triggerServerEvent("tmtaVehCarshop.sellPlayerVehicle", localPlayer, tonumber(ID))
	end

end)

function Garage.setWindowVisible(state)
	local state = (type(state) == 'boolean') and state or not Window_VS.visible
	exports.tmtaUI:setPlayerComponentVisible("dashboard", not state)
	exports.tmtaUI:setPlayerComponentVisible("all", not state, {"notifications"})
	exports.tmtaUI:setPlayerBlurScreen(state)
	showCursor(state)
	showChat(not state)
	guiSetVisible(Window_VS, state)
end

bindKey("F3", "down", function()
    if localPlayer.interior ~= 0 or localPlayer.dimension ~= 0 then
		return
	end

	if not Window_VS.visible and not exports.tmtaUI:isPlayerComponentVisible("all") then
        return
    end

	Garage.setWindowVisible()
end)

addEventHandler("tmtaDashboard.onChangeVisible", root,
	function()
		if Window_VS.visible then
			Garage.setWindowVisible(false)
		end
	end
)

-- Event
addEvent("onClientVehicleCreated", true)