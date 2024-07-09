local PaintGarageMarkers = {}
PlayerCurrentGarageMarker = nil

addEvent('onClientVehicleSetColor', true)

addEventHandler("onClientMarkerHit", root, function(player)
    if player.type ~= "player" or not player.vehicle or player.vehicle.controller ~= player or not PaintGarageMarkers[source] then
        return
    end 

    local verticalDistance = localPlayer.position.z - source.position.z
    if verticalDistance > 5 or verticalDistance < -1 then
        return
    end

    if PlayerCurrentGarageMarker then 
        return
    end 

    --[[
    local owner = player.vehicle:getData("owner")
    if not owner or owner ~= player then
        exports.tmtaNotification:showInfobox( 
            "info", 
            "Внимание!", 
            "Посещать покрасочную можно только на #FFA07Aличном транспорте", 
            _, 
            {240, 146, 115}
        )
        return
    end
    ]]

    exports.tmtaUI:setPlayerComponentVisible("all", false)
    exports.tmtaUI:setPlayerComponentVisible("notifications", true)
	showChat(false)
    fadeCamera(false, 1)
    setElementVelocity(player.vehicle, 0, 0, 0)
    toggleAllControls(false, true, true)
    
    PlayerCurrentGarageMarker = source
    triggerServerEvent("tmtaVehPaint.onPlayerEnterGarage", localPlayer)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    GarageObject = createObject(Config.paintGarageModel, Config.paintGaragePosition)
    GarageObject.dimension = 1871
    GarageObject.interior = Config.garageInterior

    for _, markerData in ipairs(Config.paintGarageMarkers) do
        
    	local marker = createMarker(
            markerData.position - Vector3(0, 0, 1),
            "cylinder",
            Config.garageMarkerRadius,
            unpack(Config.garageMarkerColor)
        )

        marker:setData('garageMarkerData', {
            position = markerData.position,
            angle = markerData.angle,
        }, false)

        exports.tmtaBlip:createBlipAttachedTo(
            marker, 
            'blipPaint',
            {name='Покрасочная'},
            tocolor(0, 255, 0, 255)
        )

        PaintGarageMarkers[marker] = marker
      
        --createBlipAttachedTo(marker, Config.garageMarkerBlip)
    end

end)