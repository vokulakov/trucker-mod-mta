Truck = {}

function Truck.spawn(model, position, rotation)
    if (not (type(model) == 'number' or type(model) == 'string') or type(position) ~= 'userdata') then
		outputDebugString('Truck.spawn: bad arguments', 1)
		return false
	end
	if not rotation then rotation = Vector3() end

    if (type(model) == 'number') then
        model = exports.tmtaVehicle:getVehicleNameFromModel(model)
    end

    if not Config.TRUCK[model] then
        outputDebugString('Truck.spawn: bad arguments', 1)
        return false
    end

    local truck = exports.tmtaVehicle:spawnVehicle(model, position, rotation)
	truck:setData('isTruck', true)

    truck:setData('truck:type', Config.TRUCK[model].type)
    truck:setData('truck:loadCapacity', tonumber(Config.TRUCK[model].loadCapacity))
   
    truck:setData('nitroBlocked', true)
    
	return truck
end

-- exports
spawnTruck = Truck.spawn