local GUI = {}
local sWeight, sHeight = guiGetScreenSize()

GUI.horn = {}

local horn_sound = {
	{'Стоковый', 'stock'},
	{'Сигнал #1', 'veh_horn_sound_1'},
	{'Сигнал #2', 'veh_horn_sound_2'},
	{'Сигнал #3', 'veh_horn_sound_3'},
	{'Сигнал #4', 'veh_horn_sound_4'},
	{'Сигнал #5', 'veh_horn_sound_5'},
	{'Сигнал #6', 'veh_horn_sound_6'},
	{'Сигнал #7', 'veh_horn_sound_7'},
	{'Сигнал #8', 'veh_horn_sound_8'},
}

local isHornListen

GUI.horn.wnd = GuiWindow(20, sHeight/2-300/2, 230, 300, "Сигнал", false)
guiWindowSetSizable(GUI.horn.wnd, false)
guiWindowSetMovable(GUI.horn.wnd, false)

GUI.horn.gridlist = guiCreateGridList(0, 30, 230, 180, false, GUI.horn.wnd)
guiGridListSetSortingEnabled(GUI.horn.gridlist, false)
local column = guiGridListAddColumn(GUI.horn.gridlist, "Сигналы", 0.8)

GUI.horn.buttonAccept = GuiButton(0, 225, 230, 35, "Установить за "..exports.tmtaUtils:formatMoney(tonumber(Config.price)).." ₽", false, GUI.horn.wnd)
guiSetFont(GUI.horn.buttonAccept, "default-bold-small")
guiSetProperty(GUI.horn.buttonAccept, "NormalTextColour", "FF21b1ff")

GUI.horn.buttonExit = GuiButton(0, 265, 230, 25, "Закрыть", false, GUI.horn.wnd)
guiSetFont(GUI.horn.buttonExit, "default-bold-small")
guiSetProperty(GUI.horn.buttonExit, "NormalTextColour", "fff01a21")
GUI.horn.buttonExit:setData('operSounds.UI', 'ui_back')

GUI.horn.wnd.visible = false

function GUI.horn.updateGridList()
	guiGridListClear(GUI.horn.gridlist)

	local currentHorn = localPlayer.vehicle:getData('CarHorn') or 'stock'

	for id, horn in pairs(horn_sound) do
		local row = guiGridListAddRow(GUI.horn.gridlist)

		guiGridListSetItemText(GUI.horn.gridlist, row, 1, horn[1], false, false)
		guiGridListSetItemData(GUI.horn.gridlist, row, 1, horn[2])

		if horn[2] == currentHorn then
			guiGridListSetItemColor(GUI.horn.gridlist, row, 1, 33, 177, 255)
		end
	end
end

function setVisibleHornWindow(visible)

	if visible then
		GUI.horn.updateGridList()
	end

	--showCursor(visible)
	GUI.horn.wnd.visible = visible
end

addEventHandler("onClientGUIClick", root, function()

	if not GUI.horn.wnd.visible then
		return 
	end

	local sel = guiGridListGetSelectedItem(GUI.horn.gridlist)
    local item = guiGridListGetItemData(GUI.horn.gridlist, sel, 1) or ""

    if source == GUI.horn.gridlist and item ~= "" and type(item) == 'string' then
    	if isElement(isHornListen) then
    		stopSound(isHornListen)
    	end

    	isHornListen = exports.tmtaSounds:playSound(item)
    	return
    elseif source == GUI.horn.buttonExit then
    	if isElement(isHornListen) then
    		stopSound(isHornListen)
    	end
		setVisibleHornWindow(false)
		exports.tmtaVehicleTuning:setWindowVisible(true)
    elseif source == GUI.horn.buttonAccept then
    	if item ~= "" then
			if item == 'stock' then
				item = false
			end

			if (tonumber(exports.tmtaMoney:getPlayerMoney()) >= tonumber(Config.price)) then
				triggerServerEvent("tmtaVehicleHorn.onPlayerBuyHorn", localPlayer, tonumber(Config.price))
			else
				exports.tmtaNotification:showInfobox( 
					"info", 
					"#FFA07AТюнинг ателье", 
					"У вас недостаточно средств", 
					_, 
					{240, 146, 115}
				)
			end

    		localPlayer.vehicle:setData('CarHorn', item)
    		setVehicleHorn(localPlayer.vehicle)
    	end
    end

end)
