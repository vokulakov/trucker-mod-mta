Utils = {}

-- Проверка. Находится ли ТС на земле
function Utils.isVehicleWheelOnGround(vehicle)
    if not isElement(vehicle) then
        return
    end

    local wheels = {}
    -- Если все 4 колеса "не касаются земли", значит авто в воде/воздухе
    for wheel_id = 0, 3 do
        local wheel_ground = isVehicleWheelOnGround(vehicle, wheel_id)
   
        if not wheel_ground then 
            return false
           -- table.insert(wheels, wheel_ground)
        end
    end 

    --if #wheels == 4 then 
       -- return false 
   -- end

    return true
end

-- Обороты двигателя (GTA)
function Utils.getDefaultRPM(vehicle)
    if not isElement(vehicle) then
        return
    end

    if not vehicle.engineState then 
        return 0
    end

    local vehicleVelocity = vehicle.velocity.length * 180
    local vehicleRPM = 0

    if Utils.isVehicleWheelOnGround(vehicle) then
        if (getVehicleCurrentGear(vehicle) > 0) then
            vehicleRPM = math.floor(((vehicleVelocity/getVehicleCurrentGear(vehicle))*150) + 0.5)
            if (vehicleRPM < 650) then
                vehicleRPM = math.random(650, 750)
            elseif (vehicleRPM >= 8000) then
                vehicleRPM = 8000
            end
        else
            vehicleRPM = math.floor(((vehicleVelocity/1)*220) + 0.5)
            if (vehicleRPM < 650) then
                vehicleRPM = math.random(650, 750)
            elseif (vehicleRPM >= 8000) then
                vehicleRPM = 8000
            end
        end
    else   
        vehicleRPM = vehicleRPM - 150
        if (vehicleRPM < 650) then
            vehicleRPM = math.random(650, 750)
        elseif (vehicleRPM >= 8000) then
            vehicleRPM = 8000
        end
    end
    
    return tonumber(vehicleRPM)
end



function Utils.getSurfaceVehicleIsOn(vehicle)
    if isElement(vehicle) and Utils.isVehicleWheelOnGround(vehicle) then

        local pos = Vector3(vehicle.position)
        local hit, _, _, _, _, _, _, _, material = processLineOfSight(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z - 5, true, false, false, true)
         
        if hit then
            return MATERIALS_LIST[material].group_id
        end

    end

    return false
end

