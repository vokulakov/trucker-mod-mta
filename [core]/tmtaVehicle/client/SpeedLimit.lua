addEventHandler('onClientRender', root,
    function ()
        local vehicle = localPlayer.vehicle
        if not isElement(vehicle) then
            return
        end

        local currentSpeed = math.floor(getDistanceBetweenPoints3D(0, 0, 0, getElementVelocity(vehicle)) * 180)
        local handling = getVehicleHandling(vehicle)
        if (currentSpeed < handling.maxVelocity) then
            return
        end

       32
    end
)