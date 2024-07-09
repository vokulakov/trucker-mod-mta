local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

Control = {}
Control.visible = true
Control.isCurrentPanel = 'player'

local FONTS = {
	['TITTLE'] 		= exports.tmtaFonts:createFontDX("RobotoBold", 8, false, "draft"),
	['CONTROL'] 	= exports.tmtaFonts:createFontDX("RobotoRegular", 8, false, "draft"),
	['HELP'] 		= exports.tmtaFonts:createFontDX("RobotoRegular", 7, false, "draft"),
}

local CONTROLS = { }

--TODO: сделать постоянные подсказки с проверкой на ограничения (например в работе дальнобоя)
--TODO: оставлять подсказку с тем, как открыть окно помощи

local plControl = { 
	{'F1', 'Главное меню'},
	{'F3', 'Личный транспорт'},
	{'F9', 'Помощь по игре'},
	{'F11', 'Карта штата'},
	{'T', 'Сообщение в чат'},
	{'TAB', 'Список игроков'},
}

local offset = 30
local width, height 
local posX, posY

local function drawHelpControl()
    if not Control.visible or not exports.tmtaUI:isPlayerComponentVisible("controlHelp") then
        return
    end


	width, height = 250, #CONTROLS*offset+20
	posX = 20
	posY = (Camera.interior == 0) and sDH-215 or sDH-40

	-- ШАПКА --
	dxDrawRectangle(sW*((posX) /sDW), sH*((posY-24-height) /sDH), sW*((width) /sDW), sH*((20) /sDH), tocolor(33, 33, 33, 255))
	dxDrawText('Управление', sW*((posX+5) /sDW), sH*((posY-21-height) /sDH), sW*((width) /sDW), sH*((20) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, FONTS['TITTLE'], 'left', 'top')
	dxDrawRectangle(sW*((posX) /sDW), sH*((posY-height-4) /sDH), sW*((width) /sDW), sH*((height) /sDH), tocolor(33, 33, 33, 200))

	local prev = 15
	for index, data in pairs(CONTROLS) do
		-- КНОПКА --
		dxDrawRectangle(sW*((posX+5) /sDW), sH*((posY-(prev)-offset) /sDH), sW*((30) /sDW), sH*((18) /sDH), tocolor(242, 171, 18, 100))
		dxDrawText(data[1], sW*((posX+5) /sDW), sH*((posY-(10+prev)) /sDH), sW*((posX+5+30) /sDW), sH*((posY-(prev)-offset) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, FONTS['TITTLE'], 'center', 'center')
		
		-- ДЕЙСТВИЕ --
		dxDrawText(data[2], sW*((posX) /sDW), sH*((posY-(10+prev)) /sDH), sW*((posX+width-5) /sDW), sH*((posY-(prev)-offset) /sDH), tocolor(255, 255, 255, 150), sW/sDW*1.0, FONTS['CONTROL'], 'right', 'center')
		
		-- ПОЛОСКА --
		dxDrawRectangle(sW*((posX+5) /sDW), sH*((posY-(10+prev)) /sDH), sW*((width-10) /sDW), 1, tocolor(255, 255, 255, 100))
		prev = prev + offset
	end
	
	dxDrawText("Скрыть/показать окно помощи 'F5'", sW*((posX+5) /sDW), sH*((posY-20) /sDH), sW*((width) /sDW), sH*((20) /sDH), tocolor(255, 255, 255, 100), sW/sDW*1.0, FONTS['HELP'])
end
addEventHandler("onClientHUDRender", root, drawHelpControl)

addEventHandler('onClientResourceStart', resourceRoot, function()
	for _, control in pairs(plControl) do
		Control.addControl(control[1], control[2])
	end
	CONTROLS = exports.tmtaUtils:tableReverseOrder(CONTROLS)
	Control.isCurrentPanel = 'player'
end)

function Control.addControl(but, act)
	table.insert(CONTROLS, {but, act})
end

function Control.removeControl(but)
	for i, control in ipairs(CONTROLS) do
		if control[1] == but then
			table.remove(CONTROLS, i)
			return true
		end
	end

	return false
end

function Control.setVisible()
	Control.visible = not Control.visible
end

-- VEHICLES --
local vehControl = {
	{'H', 'Гудок'},
	--{'B', 'Ремень безопасности'},
	--{'K', 'Двери'},
	--{'L', 'Фары'},
	--{'2', 'Двигатель'},
	{',', 'Левый поворотник'},
	{'.', 'Правый поворотник'},
	{'/', 'Аварийка'},
	{'4|5', 'Радио'},
	--{'C', 'Круиз-контроль'}
}

function Control.onClientVehicle(state)
	if not state then
		for _, control in pairs(vehControl) do
			Control.removeControl(control[1])
		end

		for _, control in pairs(plControl) do
			Control.addControl(control[1], control[2])
		end
		CONTROLS = exports.tmtaUtils:tableReverseOrder(CONTROLS)
		return
	end

	for _, control in pairs(plControl) do
		Control.removeControl(control[1], control[2])
	end

	for _, control in pairs(vehControl) do
		Control.addControl(control[1], control[2])
	end
	CONTROLS = exports.tmtaUtils:tableReverseOrder(CONTROLS)
end

addEventHandler("onClientVehicleEnter", root, function(thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 then
		if Control.isCurrentPanel == 'player' then
			Control.onClientVehicle(true)
			Control.isCurrentPanel = 'vehicle'
		end
	end
end)

addEventHandler("onClientVehicleExit", root, function(thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 then
		if Control.isCurrentPanel == 'vehicle' then
			Control.onClientVehicle(false)
			Control.isCurrentPanel = 'player'
		end
	end
end)

bindKey("F5", "down", Control.setVisible)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) == "vehicle" then
		if localPlayer.vehicle == source and localPlayer.vehicle.controller == localPlayer then
			if Control.isCurrentPanel == 'vehicle' then
		   		Control.onClientVehicle(false)
				Control.isCurrentPanel = 'player'
			end
		end
	end
end)

addEventHandler("onClientVehicleExplode", root, function()
	if localPlayer.vehicle == source and localPlayer.vehicle.controller == localPlayer then
		if Control.isCurrentPanel == 'vehicle' then
			Control.onClientVehicle(false)
			Control.isCurrentPanel = 'player'
		end
	end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
		if Control.isCurrentPanel == 'vehicle' then
			Control.onClientVehicle(false)
		 	Control.isCurrentPanel = 'player'
	 	end
	end
end)