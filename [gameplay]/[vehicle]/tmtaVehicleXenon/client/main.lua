local screenW, screenH = guiGetScreenSize()
local LIGHT_COLOR = {}

UI = { }

local width, height = 330, 360

UI.sectionsWindow = GuiWindow(20, screenH-height-20, width, height, "Ксенон", false)
guiWindowSetSizable(UI.sectionsWindow, false)
guiWindowSetMovable(UI.sectionsWindow, false)

UI.buttonPaint = GuiButton(10, 295, 330, 30, "Установить за "..convertNumber(Config.price).." ₽", false, UI.sectionsWindow)
guiSetProperty(UI.buttonPaint, "NormalTextColour", "ff5af542")

UI.buttonExit = GuiButton(10, 330, 330, 20, "Закрыть", false, UI.sectionsWindow)
guiSetProperty(UI.buttonExit, "NormalTextColour", "ffd43422")

UI.sectionsWindow.visible = false

function showXenonUI(visible)
	LIGHT_COLOR['R'], LIGHT_COLOR['G'], LIGHT_COLOR['B'] = getVehicleHeadLightColor(localPlayer.vehicle)

	if not visible then
		colorPickerDestroy()
	else
		local r, g, b = getVehicleHeadLightColor(localPlayer.vehicle, true)
		createColorPicker(tocolor(r, g, b))
	end

	UI.sectionsWindow.visible = visible
end

-------------------------- EVENTS --------------------------
addEventHandler("onClientGUIClick", UI.buttonPaint, function()
	if not UI.sectionsWindow.visible then
		return 
	end

	if tonumber(exports.tmtaMoney:getPlayerMoney()) >= tonumber(Config.price) then
		local r, g, b = getVehicleHeadLightColor(localPlayer.vehicle, true)
		triggerServerEvent("arst_carXenon.setXenonVehicle", localPlayer, r, g, b, tonumber(Config.price))
	else
		exports.tmtaNotification:showInfobox( 
			"info", 
			"Внимание!", 
			"У вас недостаточно средств", 
			_, 
			{240, 146, 115}
		)
		--outputChatBox("#1E90FF[Ксенон] #FFFFFFУ вас недостаточно средств.", 255, 255, 255, true)
		setVehicleOverrideLights(localPlayer.vehicle, 1)
		setVehicleHeadLightColor(localPlayer.vehicle, LIGHT_COLOR['R'], LIGHT_COLOR['G'], LIGHT_COLOR['B'])
	end

end, false)

addEventHandler("onClientGUIClick", UI.buttonExit, function()
	if not UI.sectionsWindow.visible then
		return 
	end

	showXenonUI(false)
	exports.tmtaVehicleTuning:setWindowVisible(true)

    setVehicleOverrideLights(localPlayer.vehicle, 1)
    setVehicleHeadLightColor(localPlayer.vehicle, LIGHT_COLOR['R'], LIGHT_COLOR['G'], LIGHT_COLOR['B'])
end, false)

addEventHandler('arst_carXenon.onColorPickerChange', root, function(hex, r, g, b)
	if not localPlayer.vehicle then
		return
	end
	setVehicleOverrideLights(localPlayer.vehicle, 2)
    setVehicleHeadLightColor(localPlayer.vehicle, r, g, b)
end)

addEventHandler('tmtaVehTuning.onPlayerExitGarage', root,
	function()
		if not UI.sectionsWindow.visible then
			return 
		end
		showXenonUI(false)
	end
)