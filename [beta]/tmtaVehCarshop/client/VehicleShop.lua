VehicleShop = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local width, height = 350, sH-200

local RB_10 = exports.tmtaFonts:createFontGUI('RobotoBold', 10)

VehicleShop.wnd = guiCreateWindow(sW*((sW-width-20) /sDW), sH*((sH-height)/2 /sDH), sW*((width) /sDW), sH*((height) /sDH), '', false)
guiSetVisible(VehicleShop.wnd , false)
guiWindowSetSizable(VehicleShop.wnd  , false)
guiWindowSetMovable(VehicleShop.wnd  , false)
guiSetAlpha(VehicleShop.wnd , 0.8)

carGrid = guiCreateGridList(sW*((0) /sDW), sH*((25) /sDH), sW*((width) /sDW), sH*((height-130) /sDH), false, VehicleShop.wnd )
guiGridListSetSortingEnabled(carGrid, false)
guiGridListSetSelectionMode(carGrid, 0)
carColumn = guiGridListAddColumn(carGrid, "Название", 0.65)
costColumn = guiGridListAddColumn(carGrid, "Цена", 0.25)

local buyButton = guiCreateButton(0, sH*((height-45-50) /sDH), sW*((width-10) /sDW), sH*(40 /sDH), 'Оформить покупку', false, VehicleShop.wnd)
guiSetFont(buyButton, RB_10)
guiSetProperty(buyButton, "NormalTextColour", "FF01D51A")

local closeButton = guiCreateButton(0, sH*((height-45) /sDH), sW*((width-10) /sDW), sH*(35 /sDH), 'Выйти из автосалона', false, VehicleShop.wnd)
guiSetFont(closeButton, RB_10)

function setVisibleHelpPanel(state)
	if state then
		if isElement(keyPane) then
			return
		end

        keyPane = exports.tmtaUI:guiKeyPanelCreate(0, 0, {
			{"keyMouseRight", "Режим просмотра"},
            {"keyMouse", "Вращать камеру"},
            {"keyMouseWheel", "Отдалить/приблизить камеру"},
		}, true)

        local width, height = exports.tmtaUI:guiKeyPanelGetSize(keyPane)
        exports.tmtaUI:guiKeyPanelSetPosition(keyPane, sW*((10) /sDW), sH*((sDH-height-10) /sDH))

	else
		if not isElement(keyPane) then
			return
		end
		destroyElement(keyPane)
	end
end 

addEventHandler("onClientGUIClick", root, function()
    if not VehicleShop.wnd.visible then 
        return
    end 

    if (source == carGrid) then
        local item = guiGridListGetSelectedItem(carGrid)

        if item == -1 then 
            guiGridListSetSelectedItem(carGrid, 0, 1)
            item = guiGridListGetSelectedItem(carGrid)
        end 

        local carID = guiGridListGetItemData(carGrid, item, 1)
        VehicleShop.showVehicle(carID)

    elseif (source == carButton) then -- покупка ТС

        local item = guiGridListGetSelectedItem(carGrid)

        if item ~= -1 then 
            local carName = guiGridListGetItemText(carGrid, item, 1)
            local carID = guiGridListGetItemData(carGrid, item, 1)
            local carCost = guiGridListGetItemData(carGrid, item, 2)
            local r1, g1, b1, r2, g2, b2 = getVehicleColor(veh, true)

            triggerServerEvent("tmtaVehCarshop.onBuyVehicle", localPlayer, carID, carCost, r1, g1, b1, r2, g2, b2)
        end
    elseif (source == closeButton) then
        VehicleShop.exitCarDealership()
    end
end)

local function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing ( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
		return true
	else
		return false
	end
end

local currentColor = math.random(1, #vehShopColors)
function VehicleShop.drawColorPicker()
    local posX, posY = sW/2-(#vehShopColors*40)/2, 32+35
    dxDrawRectangle(posX-4, posY-4, (#vehShopColors*40), 40, tocolor(33, 33, 33, 255), false)
    for k, v in pairs(vehShopColors) do
        local color = tocolor(v[1], v[2], v[3])
        if isMouseInPosition(posX, posY, 32, 32) or currentColor == k then
            dxDrawImage(posX, posY, 32, 32, "assets/color.png", 0, 0, 0, tocolor(v[1], v[2], v[3], 255), false)
            if getKeyState("mouse1") then
                currentColor = k
                if isElement(veh) then
                    setVehicleColor(veh, v[1], v[2], v[3], v[1], v[2], v[3])
                end
            end
        end
        dxDrawImage(posX, posY, 32, 32, "assets/color.png", 0, 0, 0, tocolor(v[1], v[2], v[3], 175), false)
        posX = posX + 40
    end
end 

function VehicleShop.showVehicle(carID)
    if isElement(veh) then
        setElementModel(veh, carID)
        return 
    end
    local r, g, b = vehShopColors[currentColor][1], vehShopColors[currentColor][2], vehShopColors[currentColor][3]
    veh = createVehicle(carID, 2371.03125, -1641.1905517578, 76.9, 0.00016500883793924, -0.0091034332290292, 220)
    CameraManager.start(veh)
    veh.dimension = 1
    setVehicleDamageProof(veh, true)
    setVehicleColor(veh, r, g, b, r, g, b)

    -- Номерок
    veh:setData("numberType", "c")
    veh:setData("number:plate", "TRUCKER MTA")
end

ShopMarkersTable = {}	

for i, M in ipairs(ShopTable) do
	ShopMarker = createMarker(M["PosX"], M["PosY"], M["PosZ"], "cylinder", 1.5, 38, 122, 20)
	ShopMarkerShader = createMarker(M["PosX"], M["PosY"], M["PosZ"], "cylinder", 1.5, 38, 122, 20)
	ShopMarkersTable[ShopMarker] = true
	setElementData ( ShopMarker, "shopID", i )
	setElementID(ShopMarker, tostring(i))

    exports.tmtaBlip:createAttachedTo(
        ShopMarker, 
        'blipCarshop',
        'Автосалон',
        tocolor(252, 186, 3, 255)
    )
end

function VehicleShop.enterCarDealership(carShopId)
    guiGridListClear(carGrid)

    for i, v in ipairs(ShopTable[i]["vehicles"]) do
        local carName = customCarNames[ v[1] ] or getVehicleNameFromModel(v[1])
        local carID = getVehicleModelFromNewName(carName) or getVehicleModelFromName(carName)
        local row = guiGridListAddRow(carGrid)

        if utf8.len(carName) >= 30 then
            carName = utf8.sub(carName, 0, 30) .. '...'
        end

        guiGridListSetItemText(carGrid, row, 1, carName, false, true)
        guiGridListSetItemData(carGrid, row, 1, carID)
        guiGridListSetItemText(carGrid, row, 2, convertNumber(v[2])..' ₽', false, true)
        guiGridListSetItemData(carGrid, row, 2, v[2])
    end

    setCameraMatrix(2377.3974609375, -1645.8415527344, 78.485366821289, 2376.392578125, -1645.2175292969, 78.298706054688)
    setElementDimension(localPlayer, 1)
    fadeCamera(true, 1)

    setTime(12, 0)
    setMinuteDuration(2147483647)

    guiSetVisible(VehicleShop.wnd, true)
    setVisibleHelpPanel(true)
    exports.tmtaHUD:moneyShow(sDW-20, 20)

    showCursor(true)
    guiGridListSetSelectedItem(carGrid, 0, 1)
    
    setElementFrozen(localPlayer, true)
    local carID = guiGridListGetItemData(carGrid, 0, 1)
    VehicleShop.showVehicle(carID)

    addEventHandler("onClientRender", root, VehicleShop.drawColorPicker)
end

-- Вход в автосалон
addEventHandler("onClientMarkerHit", resourceRoot, function(player)
	if getElementType(player) ~= "player" or player ~= localPlayer or isPedInVehicle(player) then 
        return 
    end

	if not ShopMarkersTable[source] then
        return
    end 

    i = tonumber(getElementID(source))
    
    fadeCamera(false, 1)
    
    exports.tmtaUI:setPlayerComponentVisible("all", false)
    exports.tmtaUI:setPlayerComponentVisible("notifications", true)
	showChat(false)

    setTimer(function()
        VehicleShop.enterCarDealership(i)
    end, 1500, 1)

end)

-- Выход из автосалона
function VehicleShop.exitCarDealership()
    if not VehicleShop.wnd.visible then 
        return
    end 

    guiSetVisible(VehicleShop.wnd, false)
    setVisibleHelpPanel(false)
    exports.tmtaHUD:moneyHide()
    removeEventHandler("onClientRender", root, VehicleShop.drawColorPicker)
    showCursor(false)
    fadeCamera(false, 1.0)

    setTimer(function() 
        setElementFrozen(localPlayer, false)
        setElementDimension(localPlayer, 0)
        CameraManager.stop()
        fadeCamera(true, 0.5)
	    setCameraTarget(localPlayer, localPlayer)

        if isElement(veh) then
            destroyElement(veh)
        end

        exports.tmtaUI:setPlayerComponentVisible("all", true)
        showChat(true)
    end, 1000, 1)
end
addEvent("tmtaVehCarshop.exitCarDealership", true)
addEventHandler("tmtaVehCarshop.exitCarDealership", root, VehicleShop.exitCarDealership)


-- НАДПИСЬ НАД ПИКАПОМ [НАЧАЛО] --
local STREAMED_MARKER = {}

local function dxDrawCustomText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center")
end

addEventHandler("onClientRender", root, 
    function()
        if not exports.tmtaUI:isPlayerComponentVisible("text3d") then
            return
        end

        local cX, cY, cZ = getCameraMatrix()
        for marker, _ in pairs(STREAMED_MARKER) do
            local x, y, z = getElementPosition(marker)
            local posX, posY = getScreenFromWorldPosition(x, y, z + 1.)
            if posX and posY then
                local distance = getDistanceBetweenPoints3D(cX, cY, cZ, x, y, z)
                if distance < 65 then
                    if isLineOfSightClear(cX, cY, cZ, x, y, z, true, true, false, true, false, false, false, marker) then
                        dxDrawCustomText('Автосалон', posX, posY, posX, posY, tocolor(255, 255, 0), 1)
                    end
                end
            end
        end
    end
)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "marker" and ShopMarkersTable[source] then
		STREAMED_MARKER[source] = source
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "marker" and STREAMED_MARKER[source] then
		STREAMED_MARKER[source] = nil
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --