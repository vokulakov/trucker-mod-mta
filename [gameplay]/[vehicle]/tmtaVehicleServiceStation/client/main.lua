local sX, sY = guiGetScreenSize() 
local GUI = { }

local function createRepairWindow(hp, price)
	if isElement(GUI.window) then return end
	GUI.window = guiCreateWindow(sX/2-300/2, sY/2-160/2, 300, 160, 'СТО', false)
	guiWindowSetSizable(GUI.window, false)
	GUI.label_welcome = guiCreateLabel(0, 25, 300, 36, 'Добро пожаловать!', false, GUI.window)
	guiLabelSetHorizontalAlign(GUI.label_welcome, "center")
	guiLabelSetColor(GUI.label_welcome, 10, 183, 220)

	GUI.label_hp = guiCreateLabel(10, 50, 300, 36, 'Повреждения: ', false, GUI.window)
	GUI.label_hp_info = guiCreateLabel(100, 50, 300, 36, math.ceil(hp)..' %', false, GUI.window)
	guiLabelSetColor(GUI.label_hp_info, 255, 0, 0)

	GUI.label_price = guiCreateLabel(10, 70, 300, 36, 'Стоимость ремонта:', false, GUI.window)
	GUI.label_price_info = guiCreateLabel(132, 70, 300, 36, math.ceil(price)..' ₽', false, GUI.window)
	guiLabelSetColor(GUI.label_price_info, 0, 255, 0)

	GUI.b_pay = guiCreateButton(0, 100, 300, 25, 'Оплатить', false, GUI.window)
	guiSetFont(GUI.b_pay, "default-bold-small")
	guiSetProperty(GUI.b_pay, "NormalTextColour", "FF0ab7dc")

	GUI.b_close = guiCreateButton(0, 130, 300, 20, 'Закрыть', false, GUI.window)
	guiSetFont(GUI.b_close, "default-bold-small")
	guiSetProperty(GUI.b_close, "NormalTextColour", "FFCE070B")  

	showCursor(true)
end
addEvent('createRepairWindow', true)
addEventHandler('createRepairWindow', root, createRepairWindow)


addEventHandler("onClientGUIClick", root, function()
	if not isElement(GUI.window) then return end

	if source == GUI.b_close then
		destroyElement(GUI.window)
		showCursor(false)
	elseif source == GUI.b_pay then
		triggerServerEvent('repairPlayerVehicle', localPlayer, getPedOccupiedVehicle(localPlayer))
		destroyElement(GUI.window)
		showCursor(false)
	end

end)

-- 3D TEXT [BEGIN] --
local function dxDrawBorderedText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center")
end

addEventHandler("onClientHUDRender", root, function()
	for _, element in pairs(getElementsByType('pickup', root, true)) do
		if getElementData(element, 'posinka.isArrow') then
			local cx, cy, cz = getCameraMatrix()
			local px, py, pz = getElementPosition(element)
			local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
			local posx, posy = getScreenFromWorldPosition(px, py, pz+0.025*distance+0.40)
			if posx and distance <= 30 then
				dxDrawBorderedText("Станция технического обслуживания", posx-(0.5), posy-(20), posx-(0.5), posy-(20), tocolor(255, 255, 0, 255), 1, 1, "default-bold", "center", "top", false, false, false)
			end
		end
	end
end)
-- 3D TEXT [END] --