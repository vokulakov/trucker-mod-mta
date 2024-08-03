VehicleShop = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

VehicleShop_Window = guiCreateWindow(sW-343-10, sH-436-35, 343, 436, "Автосалон", false)
guiSetVisible(VehicleShop_Window, false)
guiWindowSetSizable(VehicleShop_Window , false)
guiWindowSetMovable(VehicleShop_Window , false)
guiSetAlpha(VehicleShop_Window, 0.8)

carGrid = guiCreateGridList(0, 25, 324, 329, false, VehicleShop_Window)
guiGridListSetSortingEnabled(carGrid, false)
guiGridListSetSelectionMode(carGrid, 0)
carColumn = guiGridListAddColumn(carGrid, "Транспортное средство", 0.57)
costColumn = guiGridListAddColumn(carGrid, "Стоимость", 0.35)

carButton = guiCreateButton(0, 360, 400, 35, "Оформить покупку", false, VehicleShop_Window)
guiSetFont(carButton, "default-bold-small")
guiSetProperty(carButton, "NormalTextColour", "FF01D51A")

closeButton = guiCreateButton(0, 400, 340, 25, "Выйти из автосалона", false, VehicleShop_Window)
guiSetFont(closeButton, "default-bold-small")
guiSetProperty(closeButton, "NormalTextColour", "FFCE070B") 

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

function VehicleShop.exitCarDealership()
    if not VehicleShop_Window.visible then 
        return
    end 

    guiSetVisible(VehicleShop_Window, false)
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

addEventHandler("onClientGUIClick", root, function()
    if not VehicleShop_Window.visible then 
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
    veh = createVehicle(carID, 2371.03125, -1641.1905517578, 76.9, 0.00016500883793924, -0.0091034332290292, 210)
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

-- Вход в автосалон
addEventHandler("onClientMarkerHit", resourceRoot, function(player)
	if getElementType(player) ~= "player" or player ~= localPlayer or isPedInVehicle(player) then 
        return 
    end

	if not ShopMarkersTable[source] then
        return
    end 

    i = tonumber(getElementID(source))
    guiGridListClear(carGrid)

    for i, v in ipairs(ShopTable[i]["ID"]) do
        local carName = customCarNames[ v[1] ] or getVehicleNameFromModel(v[1])
        local carID = getVehicleModelFromNewName(carName) or getVehicleModelFromName(carName)
        local row = guiGridListAddRow(carGrid)
        guiGridListSetItemText(carGrid, row, 1, utf8.sub(carName, 0, 22) .. '...', false, true)
        guiGridListSetItemData(carGrid, row, 1, carID)
        guiGridListSetItemText(carGrid, row, 2, convertNumber(v[2])..' ₽', false, true)
        guiGridListSetItemData(carGrid, row, 2, v[2])
    end

    setCameraMatrix(2377.3974609375, -1645.8415527344, 78.485366821289, 2376.392578125, -1645.2175292969, 78.298706054688)
    setElementDimension(player, 1)

    guiSetVisible(VehicleShop_Window, true)
    setVisibleHelpPanel(true)
    exports.tmtaHUD:moneyShow(sDW-20, 20)

    exports.tmtaUI:setPlayerComponentVisible("all", false)
    exports.tmtaUI:setPlayerComponentVisible("notifications", true)
	showChat(false)

    showCursor(true)
    guiGridListSetSelectedItem(carGrid, 0, 1)
    
    setElementFrozen(localPlayer, true)
    local carID = guiGridListGetItemData(carGrid, 0, 1)
    VehicleShop.showVehicle(carID)

    addEventHandler("onClientRender", root, VehicleShop.drawColorPicker)
end)