local TuningGarageMarkers = {}
PlayerCurrentGarageMarker = nil

addEventHandler("onClientMarkerHit", root, 
    function(player)
        if (player.type ~= "player" or player ~= localPlayer) then
            return
        end 

        if (not player.vehicle or player.vehicle.controller ~= player or not TuningGarageMarkers[source]) then
            return
        end

        local verticalDistance = localPlayer.position.z - source.position.z
        if verticalDistance > 5 or verticalDistance < -1 then
            return
        end

        if PlayerCurrentGarageMarker then 
            return
        end 

        local owner = player.vehicle:getData("owner")
        if (not owner or owner ~= player and not exports.tmtaCore:isTestServer()) then
            exports.tmtaNotification:showInfobox( 
                "info", 
                "Внимание!", 
                "Посещать тюнинг можно только на #FFA07Aличном транспорте", 
                _, 
                {240, 146, 115}
            )
            return 
        end

        exports.tmtaUI:setPlayerComponentVisible("all", false)
        exports.tmtaUI:setPlayerComponentVisible("notifications", true)
        showChat(false)
        fadeCamera(false, 1)

        setElementVelocity(player.vehicle, 0, 0, 0)
        toggleAllControls(false, true, true)
        
        PlayerCurrentGarageMarker = source
        triggerServerEvent("tmtaVehTuning.onPlayerEnterGarage", localPlayer)
    end
)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for _, markerData in ipairs(Config.tuningGarageMarkers) do
        
    	local marker = createMarker(
            markerData.position - Vector3(0, 0, 1),
            "cylinder",
            Config.garageMarkerRadius,
            unpack(Config.garageMarkerColor)
        )

        TuningGarageMarkers[marker] = marker
      
        exports.tmtaBlip:createBlipAttachedTo(
            marker, 
            'blipTuning',
            {name='Тюнинг центр'},
            tocolor(0, 153, 255, 255)
        )
    end

    GarageInterior.create()
end)