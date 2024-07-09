local ENGINE_FAILEDE = true

local function onEngineFailede()
    local vehicle = localPlayer.vehicle
    if not isElement(vehicle) or vehicle.controller ~= localPlayer then
        return
    end

    if getElementHealth(vehicle) >= 550 then 
        return
    end

    triggerServerEvent("tmtaVehSTO.doToggleEngine", localPlayer, vehicle)
end 
addEventHandler("onClientVehicleDamage", root, onEngineFailede)
addEventHandler("onClientVehicleEnter", root, onEngineFailede)

addEventHandler("onClientPreRender", root, function()
    local vehicle = localPlayer.vehicle
    if not isElement(vehicle) or vehicle.controller ~= localPlayer then
        return
    end

    if getElementHealth(vehicle) >= 550 then 
        return
    end

    if not ENGINE_FAILEDE then
        return
    end

    setTimer(
        function()
            if not ENGINE_FAILEDE or not getVehicleEngineState(vehicle) then
                return
            end

            triggerServerEvent("tmtaVehSTO.doToggleEngine", localPlayer, vehicle)
            local sound = playSound("assets/failure.wav")

            ENGINE_FAILEDE = false

            setTimer( 
                function()
                    ENGINE_FAILEDE = true
                end, math.random(5000, 25000), 1)

        end, 10, 1)

end)