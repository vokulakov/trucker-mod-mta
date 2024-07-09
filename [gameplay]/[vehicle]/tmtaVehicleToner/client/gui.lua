local sWidth, sHeight = guiGetScreenSize()

GUI = {}

GUI.btn_toner = {}

GUI.wnd = GuiWindow(20, sHeight/2-560/2, 330, 560, "Тонировка", false)
guiWindowSetSizable(GUI.wnd, false)
guiWindowSetMovable(GUI.wnd, false)

GUI.tabPanel = guiCreateTabPanel(0, 335, 320, 185, false, GUI.wnd)

--
GUI.tab1 = guiCreateTab("Стекла", GUI.tabPanel)

GUI.chekBoxColor_zad = guiCreateCheckBox(10, 35, 140, 20, 'Задняя полусфера', false, false, GUI.tab1)
GUI.btn_toner[GUI.chekBoxColor_zad] = 'zad_steklo'

GUI.chekBoxColor_lob = guiCreateCheckBox(10, 55, 140, 20, 'Лобовое стекло', false, false, GUI.tab1)
GUI.btn_toner[GUI.chekBoxColor_lob] = 'lob_steklo'

GUI.chekBoxColor_pered = guiCreateCheckBox(160, 35, 140, 20, 'Передние стекла', false, false, GUI.tab1)
GUI.btn_toner[GUI.chekBoxColor_pered] = 'pered_steklo'

GUI.chekBoxColor_all = guiCreateCheckBox(160, 55, 140, 20, 'Выбрать все', false, false, GUI.tab1)

GUI.buttonRemove_toner = GuiButton(10, 115, 120, 35, "Снять тонировку", false, GUI.tab1) 
guiSetFont(GUI.buttonRemove_toner, "default-bold-small")
--guiSetEnabled(GUI.buttonRemove_toner, false)

GUI.buttonAccept_toner = GuiButton(140, 115, 160, 35, "Установить за "..convertNumber(Config.tonerPrice).." ₽", false, GUI.tab1)
guiSetFont(GUI.buttonAccept_toner, "default-bold-small")
guiSetProperty(GUI.buttonAccept_toner, "NormalTextColour", "FF21b1ff")
GUI.buttonAccept_toner.enabled = false
--

GUI.buttonExit = GuiButton(0, 525, 330, 25, "Закрыть", false, GUI.wnd)
guiSetFont(GUI.buttonExit, "default-bold-small")
guiSetProperty(GUI.buttonExit, "NormalTextColour", "fff01a21")
GUI.buttonExit:setData('operSounds.UI', 'ui_back')

GUI.wnd.visible = false

function GUI.setCheckBoxState(isState, isCheckBox)

	if isCheckBox and isCheckBox == GUI.chekBoxColor_all then
		guiCheckBoxSetSelected(GUI.chekBoxColor_all, isState)
		guiCheckBoxSetSelected(GUI.chekBoxColor_lob, isState)
		guiCheckBoxSetSelected(GUI.chekBoxColor_zad, isState)
		guiCheckBoxSetSelected(GUI.chekBoxColor_pered, isState)
	end

end

function GUI.getCheckBoxState()
	if 	guiCheckBoxGetSelected(GUI.chekBoxColor_all)
		or guiCheckBoxGetSelected(GUI.chekBoxColor_lob)
		or guiCheckBoxGetSelected(GUI.chekBoxColor_zad)
		or guiCheckBoxGetSelected(GUI.chekBoxColor_pered)
	then 
		return true 
	end 

	return false
end

function GUI.setVisible(isVisible)
	if not localPlayer.vehicle then
		return
	end

	if not isVisible then
		colorPickerDestroy()
	else
		createColorPicker(_, GUI.wnd, true)
 		GUI.setCheckBoxState(false, GUI.chekBoxColor_all)
 		GUI.setCheckBoxState(false, GUI.chekBoxColor_far_all)
		GUI.buttonAccept_toner.enabled = false
	end

	GUI.wnd.visible = isVisible
	--showCursor(isVisible)
end
--addEvent('lmxVehicleToner.setWndVisible', true)
--addEventHandler('lmxVehicleToner.setWndVisible', root, GUI.setVisible)

addEventHandler("onClientGUIClick", root, function()
	if not GUI.wnd.visible then
		return 
	end

	local vehicle = localPlayer.vehicle
	local r, g, b, a = getColorPickerColor()

	if not isElement(vehicle) then
		return
	end

	GUI.buttonAccept_toner.enabled =  GUI.getCheckBoxState()

	if source == GUI.buttonExit then
		Toner.stopPrewiew(vehicle)
		GUI.setVisible(false)
		--triggerEvent('TuningGarage.setWindowVisible', localPlayer, true)
		exports.tmtaVehicleTuning:setWindowVisible(true)
		return
	elseif source == GUI.buttonAccept_toner then

		triggerServerEvent("tmtaVehToner.setVehicleToner", 
			localPlayer, 
			vehicle,
			Config.tonerPrice,
			Toner.Vehicles[vehicle]['zad_steklo'],
			Toner.Vehicles[vehicle]['pered_steklo'],
			Toner.Vehicles[vehicle]['lob_steklo']
		)

		GUI.setCheckBoxState(false, GUI.chekBoxColor_all)
		GUI.setCheckBoxState(false, GUI.chekBoxColor_far_all)
	   	GUI.buttonAccept_toner.enabled = false

	    return
	elseif source == GUI.buttonRemove_toner then
		Toner.setData(vehicle, 'zad_steklo', false)
		Toner.setData(vehicle, 'pered_steklo', false)
		Toner.setData(vehicle, 'lob_steklo', false)

		return

	elseif source == GUI.chekBoxColor_all then
		GUI.setCheckBoxState(guiCheckBoxGetSelected(source), source)
		GUI.buttonAccept_toner.enabled = guiCheckBoxGetSelected(source)
	elseif GUI.btn_toner[source] then

		local steklo = GUI.btn_toner[source]

		if not Toner.Vehicles[vehicle] or not Toner.Vehicles[vehicle][steklo] then
			Toner.startPrewiew(vehicle, r, g, b, a)
			return
		end

		local r = Toner.Vehicles[vehicle][steklo].r or 255
		local g = Toner.Vehicles[vehicle][steklo].g or 0
		local b = Toner.Vehicles[vehicle][steklo].b or 0
		local a = Toner.Vehicles[vehicle][steklo].a or 255

		setColorPickerColor(r, g, b, a)

		return
 	end

	Toner.startPrewiew(vehicle, r, g, b, a)	
end)

addEventHandler('operVehicleToner.onColorPickerChange', root, function(hex, r, g, b, a)
	if not GUI.wnd.visible then
		return 
	end

	Toner.startPrewiew(localPlayer.vehicle, r, g, b, a)
end)

-- exports 
setWindowVisible = GUI.setVisible
--[[
bindKey('8', 'down', function()
	if GUI.wnd.visible then
		Toner.stopPrewiew(localPlayer.vehicle)
	end
	GUI.setVisible(not GUI.wnd.visible)
	showCursor(GUI.wnd.visible)
	triggerEvent('operShowUI.setVisiblePlayerUI', localPlayer, not GUI.wnd.visible)
end)
]]

addEventHandler('tmtaVehTuning.onPlayerExitGarage', root,
	function()
		if not GUI.wnd.visible then
			return 
		end
		Toner.stopPrewiew(localPlayer.vehicle)
		GUI.setVisible(false)
	end
)