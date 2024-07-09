addEventHandler('onClientRender', root,
    function ()
        local vehicle = localPlayer.vehicle
        if not isElement(vehicle) then
            return
        end

        local currentSpeed = math.floor(getDistanceBetweenPoints3D(0, 0, 0, getElementVelocity(vehicle)) * 180)
        local handling = getVehicleHandling(vehicle)
        local maxVelocity = handling.maxVelocity
        if (currentSpeed < maxVelocity) then
            return
        end

        if (currentSpeed) then
            local diff = tonumber(maxVelocity)/currentSpeed
            if diff ~= diff then 
                return
            end
            local x, y, z = getElementVelocity(vehicle)
            return setElementVelocity(vehicle, x*diff, y*diff, z*diff)
        end
    end
)