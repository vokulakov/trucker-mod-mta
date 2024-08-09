VehicleSpawn = {}

-- Время, через которое удаляется взорвавшийся автомобиль
local EXPLODED_VEHICLE_DESTROY_TIMEOUT = 5000

local dataFields = {
	'vehicleId',
}

function VehicleSpawn.spawn(vehicleId, position, rotation)
	if type(vehicleId) ~= "number" or type(position) ~= "userdata" then
		outputDebugString("VehicleSpawn.spawn: Bad aruments")
		return false
	end
    rotation = (not rotation) and Vector3() or rotation

    local vehicleInfo = Vehicle.get(vehicleId)
	if (type(vehicleInfo) ~= "table" or #vehicleInfo == 0) then
		outputDebugString("VehicleSpawn.spawn: Vehicle does not exist")
		return false
	end
	vehicleInfo = vehicleInfo[1]

    -- Создание автомобиля
	local vehicle = Vehicle(vehicleInfo.model, position, rotation)
	vehicle:setColor(255, 0, 0)

    for i, name in ipairs(dataFields) do
		vehicle:setData(name, vehicleInfo[name])
	end
end