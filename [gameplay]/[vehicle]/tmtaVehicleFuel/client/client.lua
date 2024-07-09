local sW, sH = guiGetScreenSize()
local UI = { ['refills'] = { } }

local totals_price = 0
local totals_litres = 0
local fuel_type = -1
local fuel_type_text = "-"

local _prices = nil

local function getVehicleFuelType()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	local fuel_type = {"АИ-92", "АИ-95", "АИ-98", "ДТ"}
	local result = ""

	local veh_fuel_type = getElementData(veh, 'typeOfFuel')
	for w in string.gmatch(veh_fuel_type, "%d+") do
		local fuel = fuel_type[tonumber(w)]
		if fuel ~= nil  then
			result = result..' '..tostring(fuel)..', '
		end
	end

	return string.sub(result, 1, result:len() - 2)
end

local function showFuelingWindow()
	UI['refills'].wnd = guiCreateWindow(sW/2-250/2, sH/2-330/2, 250, 330, "АЗС", false)

	UI['refills'].but_ai92 = guiCreateButton(0, 0.13, 1, 0.07, "АИ-92", true, UI['refills'].wnd)
	UI['refills'].but_ai95 = guiCreateButton(0, 0.21, 1, 0.07, "АИ-95", true, UI['refills'].wnd)
	UI['refills'].but_ai98 = guiCreateButton(0, 0.29, 1, 0.07, "АИ-98", true, UI['refills'].wnd)
	UI['refills'].but_dt = guiCreateButton(0, 0.37, 1, 0.07, "ДТ", true, UI['refills'].wnd)

	UI['refills'].lbl_type = guiCreateLabel(0, 0.07, 1, 0.06, 'Вам подходит: '..getVehicleFuelType(), true, UI['refills'].wnd)
	guiSetFont(UI['refills'].lbl_type, "default-bold-small")
    guiLabelSetHorizontalAlign(UI['refills'].lbl_type, "center", false)
    guiLabelSetVerticalAlign(UI['refills'].lbl_type, "top")
    guiLabelSetColor(UI['refills'].lbl_type, 0, 185, 255)

	UI['refills'].lbl_info = guiCreateLabel(0, 0.43, 1, 0.25, 'Тип топлива: -\nЦена за 1 л: -\nЗалить: 0 л\nНа: 0 ₽\n', true, UI['refills'].wnd)
	guiSetFont(UI['refills'].lbl_info, "default-bold-small")
    guiLabelSetHorizontalAlign(UI['refills'].lbl_info, "center", false)
    guiLabelSetVerticalAlign(UI['refills'].lbl_info, "center")
    guiLabelSetColor(UI['refills'].lbl_info, 0, 185, 255)

    UI['refills'].scroll_bar = guiCreateScrollBar(0, 0.67, 1, 0.07, true, true, UI['refills'].wnd)

    UI['refills'].but_fill = guiCreateButton(0, 0.76, 1, 0.1, "Заправить", true, UI['refills'].wnd)
    guiSetProperty(UI['refills'].but_fill, "NormalTextColour", "ff00b9ff")

    UI['refills'].but_close = guiCreateButton(0, 0.88, 1, 0.08, "Закрыть", true, UI['refills'].wnd)
    guiSetProperty(UI['refills'].but_close, "NormalTextColour", "ffd43422")
end

addEvent('fuel_system.showFuelingWindow', true)
addEventHandler('fuel_system.showFuelingWindow', root, function(prices)
	if (isElement(UI['refills'].wnd) or type(prices) ~= 'table') then 
		return 
	end

	_prices = prices


	totals_price = 0
	totals_litres = 0
	fuel_type = -1
	fuel_type_text = "-"

	showFuelingWindow()
	showCursor(true)
end)

addEventHandler("onClientGUIClick", getRootElement(), function(button)
	if button == "left" and isElement(UI['refills'].wnd) then
		if source == UI['refills'].but_close then
			destroyElement(UI['refills'].wnd)
			showCursor(false)
			return
		-- ЗАПРАВКА --
		elseif source == UI['refills'].but_fill then
			if totals_litres == 0 then return end
			
			local veh = getPedOccupiedVehicle(localPlayer)
			if not veh then return end

			local vehicleFuel = getElementData(veh, 'fuel')
			local vehicleFuelMax = getElementData(veh, 'fuelMax')
			local veh_fuel_type = getElementData(veh, 'typeOfFuel')

			if string.find(veh_fuel_type, fuel_type) == nil then
				--triggerEvent('tmtaNotify.addNotification', localPlayer, 'Выбранный вид топлива не\nподходит для вашего транспорта.', 2)
				
				exports.tmtaNotification:showInfobox(
					"info", 
					"#FFA07AАЗС", 
					"#FFFFFFВыбранный вид топлива не подходит для вашего транспорта", 
					_, 
					{240, 146, 115}
				)
				
				return
			end

			local playerMoney = exports.tmtaMoney:getPlayerMoney()
			if playerMoney < totals_price then
				--outputChatBox('У вас недостаточно средств.', 170, 0, 0)
				--triggerEvent('tmtaNotify.addNotification', localPlayer, 'У вас недостаточно средств.', 2)
				
				exports.tmtaNotification:showInfobox(
					"info", 
					"#FFA07AАЗС", 
					"#FFFFFFУ вас недостаточно денежных средств", 
					_, 
					{240, 146, 115}
				)
				
				return
			end

			local total_fuel = math.ceil(vehicleFuelMax - vehicleFuel)
			if total_fuel < totals_litres or vehicleFuel == vehicleFuelMax then
				totals_litres = total_fuel
				totals_price = total_fuel*_prices[fuel_type_text]

				if totals_price == 0 then
					--outputChatBox('Бак полный!', 170, 0, 0)
					--triggerEvent('tmtaNotify.addNotification', localPlayer, 'Бак полный!', 2)
				
					exports.tmtaNotification:showInfobox(
						"info", 
						"#FFA07AАЗС", 
						"#FFFFFFБак полный!", 
						_, 
						{240, 146, 115}
					)
				
					return
				end
			end

			triggerServerEvent('arst_fueling.onVehicleRefuel', localPlayer, veh, totals_litres, totals_price)
	
			destroyElement(UI['refills'].wnd)
			showCursor(false)

			return
		--------------
		elseif source == UI['refills'].but_ai92 then 
			fuel_type = 1
			fuel_type_text = 'АИ-92'
		elseif source == UI['refills'].but_ai95 then 
			fuel_type = 2
			fuel_type_text = 'АИ-95'
		elseif source == UI['refills'].but_ai98 then 
			fuel_type = 3
			fuel_type_text = 'АИ-98'
		elseif source == UI['refills'].but_dt then 
			fuel_type = 4 
			fuel_type_text = 'ДТ'
		end

		if fuel_type ~= -1 then
			totals_price = totals_litres*_prices[fuel_type_text]
			guiSetText(UI['refills'].lbl_info, 'Тип топлива: '..fuel_type_text..'\nЦена за 1 л: '.._prices[fuel_type_text]..' ₽\nЗалить: '..totals_litres..' л\nНа: '..totals_price..' ₽\n')
		end

	end
end)

addEventHandler("onClientGUIScroll", root, function()
	if not isElement(UI['refills'].wnd) then return end
	local scroll_pos = guiScrollBarGetScrollPosition(source)

	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	local fuel = getElementData(veh, 'fuel')
	local maxFuel = getElementData(veh, 'fuelMax')

	if not fuel or not maxFuel then return end

	totals_litres = math.floor(((maxFuel*scroll_pos)/100))

	if fuel_type ~= -1 then
		totals_price = totals_litres*_prices[fuel_type_text]
		guiSetText(UI['refills'].lbl_info, 'Тип топлива: '..fuel_type_text..'\nЦена за 1 л: '.._prices[fuel_type_text]..' ₽\nЗалить: '..totals_litres..' л\nНа: '..totals_price..' ₽\n')
	end

end)

if showCoeff then
	addEventHandler('onClientRender', root, function()
		local veh = getPedOccupiedVehicle(localPlayer)
		if not veh then return end

		local fuel = getElementData(veh, 'fuel') or nil
		local maxFuel = getElementData(veh, 'fuelMax') or nil

		dxDrawText('Показатель расхода топлива: '..fuel..'/'..maxFuel, 10, sH-20, sW, sH)
	end)
end