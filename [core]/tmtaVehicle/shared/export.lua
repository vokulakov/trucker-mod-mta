function getPlayerVehiclesCount(player)
    local player = player or localPlayer
    if not isElement(player) then
        return false
    end
	return tonumber(player:getData('garage_cars_count')) or 0
end

function getVehicleById(vehicleId)
    if (not vehicleId or type(vehicleId) ~= "number") then
        return false
    end
    return getElementByID('vehicle_'..tostring(vehicleId))
end