addEventHandler("onClientResourceStart", resourceRoot,
    function()
        CreateHouseGUI.render()
        HouseBlip.update()
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        for _, houseMarker in pairs(getElementsByType('marker', resourceRoot)) do
            HouseBlip.remove(houseMarker)
        end
    end
)

addEventHandler("onClientMarkerHit", resourceRoot, 
    function(player, matchingDimension)
        local marker = source
        if getElementType(player) ~= "player" or player ~= localPlayer or isPedInVehicle(player) then 
            return 
        end

        local verticalDistance = player.position.z - source.position.z
        if verticalDistance > 5 or verticalDistance < -1 then
            return
        end

        if not matchingDimension then
            return
        end
    
        -- Вход в дом
        if marker:getData('isHouseMarker') then
            local houseData = marker:getData('houseData')
		    houseData.number = tostring(houseData.houseId)
		    houseData.price = tostring(exports.tmtaUtils:formatMoney(houseData.price))
            HouseGUI.openWindow(houseData)
        elseif marker:getData('isHouseExitMarker') then
            local houseId = marker:getData('houseId')
            House.exit(houseId)
        end

    end
)