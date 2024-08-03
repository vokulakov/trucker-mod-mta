UI = {}
local GUI = {}

local Fonts = {
	['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
}

local sW, sH = guiGetScreenSize()
local sDW, sDH = 1600, 900
local width, height = 250, sDH - 25
local posX, posY = 20, (sDH-height) /2

function UI.showWindow()
	GUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), "Тюнинг центр", false)
	guiWindowSetSizable(GUI.wnd, false)
	guiWindowSetMovable(GUI.wnd, false)

	GUI.btn_wheel = guiCreateButton(0, sH*((35) /sDH), sW*((width) /sDW), sH*((30) /sDH), "Диски (настройка колес)", false, GUI.wnd)
	guiSetFont(GUI.btn_wheel, Fonts.RR_10)

	GUI.btn_handling = guiCreateButton(0, sH*((70) /sDH), sW*((width) /sDW), sH*((30) /sDH), "Чип-тюнинг (handling)", false, GUI.wnd)
	guiSetFont(GUI.btn_handling, Fonts.RR_10)

	GUI.btn_tuning = guiCreateButton(0, sH*((105) /sDH), sW*((width) /sDW), sH*((30) /sDH), "Компоненты (обвесы)", false, GUI.wnd)
	guiSetFont(GUI.btn_tuning, Fonts.RR_10)

	GUI.btn_toner = guiCreateButton(0, sH*((140) /sDH), sW*((width) /sDW), sH*((30) /sDH), "Тонировка", false, GUI.wnd)
	guiSetFont(GUI.btn_toner, Fonts.RR_10)

	GUI.btn_xenon = guiCreateButton(0, sH*((175) /sDH), sW*((width) /sDW), sH*((30) /sDH), "Ксенон", false, GUI.wnd)
	guiSetFont(GUI.btn_xenon, Fonts.RR_10)

	GUI.btn_horn = guiCreateButton(0, sH*((210) /sDH), sW*((width) /sDW), sH*((30) /sDH), "Звуковой сигнал", false, GUI.wnd)
	guiSetFont(GUI.btn_horn, Fonts.RR_10)
	
    GUI.btn_exit = guiCreateButton(0, sH*((height-40) /sDH), sW*((width) /sDW), sH*((30) /sDH), "Выйти", false, GUI.wnd)
	guiSetFont(GUI.btn_exit, Fonts.RR_10)
	guiSetProperty(GUI.btn_exit, "NormalTextColour", "fff01a21")
end

function UI.setVisibleHelpPanel(state)
	if state then
		if isElement(GUI.keyPane) then
			return
		end
		GUI.keyPane = exports.tmtaUI:createKeyPane(sW*((sDW-570) /sDW), sH*((sDH-70) /sDH), {
			{"keyMouseRight", "Режим просмотра"},
			{"keyMouse", "Вращать камеру"},
			{"keyMouseWheel", "Отдалить/приблизить камеру"},
		}, true)
	else
		if not isElement(GUI.keyPane) then
			return
		end
		destroyElement(GUI.keyPane)
	end
end

function UI.setWindowVisible(state)
	if state then
		if isElement(GUI.wnd) then 
			return
		end 
		UI.showWindow()
		exports.tmtaHUD:moneyShow(sDW-20, 20)
	else
		if not isElement(GUI.wnd) then 
			return
		end
		destroyElement(GUI.wnd)
	end
end

addEventHandler('onClientGUIClick', root, function()
	if not isElement(GUI.wnd) then
		return
	end

	if source == GUI.btn_exit then
		UI.setWindowVisible(false)
		triggerServerEvent("tmtaVehTuning.onPlayerExitGarage", localPlayer)
		exports.tmtaHUD:moneyHide()
		UI.setVisibleHelpPanel(false)
		showCursor(false)
	elseif source == GUI.btn_handling then 
		UI.setWindowVisible(false)
		exports.hedit:toggleEditor()
	elseif source == GUI.btn_tuning then 
		UI.setWindowVisible(false)
		openGUITunning(localPlayer)
	elseif source == GUI.btn_toner then 
		UI.setWindowVisible(false)
		exports.tmtaVehToner:setWindowVisible(true)
	elseif source == GUI.btn_wheel then 
		UI.setWindowVisible(false)
		exports.tmtaVehWheel:setWindowVisible()
	elseif source == GUI.btn_horn then 
		UI.setWindowVisible(false)
		exports.tmtaVehHorn:setVisibleHornWindow(true)
	elseif source == GUI.btn_xenon then 
		UI.setWindowVisible(false)
		exports.tmtaVehXenon:showXenonUI(true)
	end 

end)

--Test
--[[
bindKey("f7", "down", function()
	UI.setWindowVisible(true)
end)
]]
-- Exports
setWindowVisible = UI.setWindowVisible