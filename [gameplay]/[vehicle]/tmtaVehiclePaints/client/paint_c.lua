UI = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = 1600, 900

local width, height = 330, 435
local currentColorType

UI.sectionsWindow = GuiWindow(20, sH-height-20, width, height, "Покраска", false)
guiWindowSetSizable(UI.sectionsWindow, false)
guiWindowSetMovable(UI.sectionsWindow, false)

-- ТИП ПОКРАСКИ --
UI.rButStock = guiCreateRadioButton(0, 300, 100, 20, "Стандартный", false, UI.sectionsWindow)
UI.rButGloss = guiCreateRadioButton(0, 320, 100, 20, "Глянец", false, UI.sectionsWindow)
UI.rButMatte = guiCreateRadioButton(0, 340, 100, 20, "Матовый", false, UI.sectionsWindow)
UI.rButChrome = guiCreateRadioButton(0, 360, 150, 20, "Хром", false, UI.sectionsWindow)
UI.rButChameleon = guiCreateRadioButton(0, 380, 150, 20, "Перламутровый", false, UI.sectionsWindow)
------------------

UI.chekBoxColor1 = guiCreateCheckBox(170, 300, 90, 20, 'Цвет кузова', true, false, UI.sectionsWindow)
UI.chekBoxColor3 = guiCreateCheckBox(170, 320, 150, 20, 'Дополнительный цвет', false, false, UI.sectionsWindow)
UI.chekBoxColor2 = guiCreateCheckBox(170, 340, 90, 20, 'Цвет блеска', false, false, UI.sectionsWindow)

UI.buttonPaint = GuiButton(170, 370, 150, 30, "Покрасить", false, UI.sectionsWindow)
guiSetProperty(UI.buttonPaint, "NormalTextColour", "ff5af542")

UI.buttonExit = GuiButton(10, 405, 330, 20, "Выход", false, UI.sectionsWindow)
guiSetProperty(UI.buttonExit, "NormalTextColour", "ffd43422")

UI.sectionsWindow.visible = false

function UI.setVisibleHelpPanel(state)
	if state then
		if isElement(UI.keyPane) then
			return
		end
		
		UI.keyPane = exports.tmtaUI:guiKeyPanelCreate(0, 0, {
			{"keyMouseRight", "Режим просмотра"},
			{"keyMouse", "Вращать камеру"},
			{"keyMouseWheel", "Отдалить/приблизить камеру"},
		}, true)
	
		local keyPanelWidth, keyPanelHeight = exports.tmtaUI:guiKeyPanelGetSize(UI.keyPane)
		exports.tmtaUI:guiKeyPanelSetPosition(UI.keyPane, sW*((sDW-keyPanelWidth-20) /sDW), sH*((sDH-keyPanelHeight-40) /sDH))
	else
		if not isElement(UI.keyPane) then
			return
		end
		destroyElement(UI.keyPane)
	end
end 

function showPaintUI(visible)
	----------------------------
	local currentColorType = localPlayer.vehicle:getData('BodyPaintType') 
	if (not currentColorType or currentColorType == "" or currentColorType == 0) then
		guiRadioButtonSetSelected(UI.rButStock, true)
		guiSetText(UI.buttonPaint, 'Покрасить за '..exports.tmtaUtils:formatMoney(tonumber(Config.paintPrice['stock']))..' ₽')
		colorType = 'stock'
	else
		if currentColorType == 'matte' then
			guiRadioButtonSetSelected(UI.rButMatte, true)
		elseif currentColorType == 'gloss' then
			guiRadioButtonSetSelected(UI.rButGloss, true)
		elseif currentColorType == 'chrome' then
			guiRadioButtonSetSelected(UI.rButChrome, true)
		elseif currentColorType == 'chameleon' then
			guiRadioButtonSetSelected(UI.rButChameleon, true)
		end
		guiSetText(UI.buttonPaint, 'Покрасить за '..exports.tmtaUtils:formatMoney(tonumber(Config.paintPrice[currentColorType]))..' ₽')
		colorType = currentColorType
	end

	----------------------------
	if not visible then
		colorPickerDestroy()
		exports.tmtaHUD:moneyHide()
	else
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(localPlayer.vehicle, true)
		createColorPicker(tocolor(r1, g1, b1))
		exports.tmtaHUD:moneyShow(sDW-20, 20)
	end

	UI.sectionsWindow.visible = visible
	UI.setVisibleHelpPanel(visible)
end

-------------------------- EVENTS --------------------------
addEventHandler("onClientGUIClick", UI.buttonPaint, function()
	if not UI.sectionsWindow.visible then
		return 
	end
	-- ПОКРАСИМ ? :) --
	if not colorType then
		return
	end

  
	local money = tonumber(Config.paintPrice[colorType])
	if tonumber(exports.tmtaMoney:getPlayerMoney()) >= money then
		playSound("assets/sound.mp3", false)
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(localPlayer.vehicle, true)
		triggerServerEvent('tmtaVehPaints.paintGarageBuyVehicleColor', localPlayer, money, r1, g1, b1, r2, g2, b2)
        showPaintUI(false)
        setTimer(function()
            triggerServerEvent("tmtaVehPaint.onPlayerExitGarage", localPlayer)
        end, 3000, 1)
    else
        exports.tmtaNotification:showInfobox( 
            "info", 
            "Внимание!", 
            "У вас недостаточно средств", 
            _, 
            {240, 146, 115}
        )
	end
	
end, false)

addEventHandler("onClientGUIClick", UI.buttonExit, function()
	if not UI.sectionsWindow.visible then
		return 
	end
    showPaintUI(false)
    triggerServerEvent("tmtaVehPaint.onPlayerExitGarage", localPlayer)
    --exitPaintGarage()
    resetVehiclePreview() 
end, false)

addEventHandler('arst_carPaint.onColorPickerChange', root, function(hex, r, g, b)
    setVehiclePreviewColor(r, g, b)
end)

addEventHandler("onClientGUIClick", root, function()
	if not UI.sectionsWindow.visible then
		return 
	end
    
    if source == UI.rButStock or source == UI.rButGloss or source == UI.rButMatte or source == UI.rButChrome or source == UI.rButChameleon then
	    if source == UI.rButStock then colorType = 'stock'
	    elseif source == UI.rButGloss then colorType = 'gloss'
	    elseif source == UI.rButMatte then colorType = 'matte'
	    elseif source == UI.rButChrome then colorType = 'chrome'
	    elseif source == UI.rButChameleon then colorType = 'chameleon'
	    end
	    guiSetText(UI.buttonPaint, 'Покрасить за '..exports.tmtaUtils:formatMoney(tonumber(Config.paintPrice[colorType]))..' ₽')
	    setVehiclePreviewFX(colorType)
	end
end)
------------------------------------------------------------

