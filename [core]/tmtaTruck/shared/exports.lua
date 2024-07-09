local function preparedModel(model)
    if (type(model) ~= 'number' and type(model) ~= 'string') then
		return false
	end

    if (type(model) == 'number') then
        model = exports.tmtaVehicle:getVehicleNameFromModel(model)
    end

    if not Config.TRUCK[model] then
        return false
    end

    return model
end

function getTruckConfigByModel(model)
    local model = preparedModel(model)
    if not model then
        --outputDebugString('getTruckConfigByModel: bad arguments', 1)
        return false
    end
    return Config.TRUCK[model]
end

function getTruckTypeNameByModel(model)
    local truckConfig = getTruckConfigByModel(model)
    if not truckConfig then
        --outputDebugString('getTruckTypeNameByModel: bad arguments', 1)
        return false
    end
    return Config.TRUCK_TYPE[truckConfig.type]
end

function getTruckLoadCapacityByModel(model)
    local truckConfig = getTruckConfigByModel(model)
    if not truckConfig then
        --outputDebugString('getTruckLoadCapacityByModel: bad arguments', 1)
        return false
    end
    return truckConfig.loadCapacity or 0
end

function isTruck(truck)
    if not isElement(truck) then
        --outputDebugString('isTruck: bad arguments', 1)
        return false
    end
    return truck:getData('isTruck')
end

function isTruckNeedsTrailer(truck)
    if not isElement(truck) then
        --outputDebugString('isTruckNeedsTrailer: bad arguments', 1)
        return false
    end
    return (truck:getData('truck:type') == 1)
end

function getTruckLoadCapacity(truck)
    if not isElement(truck) then
        --outputDebugString('getTruckLoadCapacity: bad arguments', 1)
        return false
    end
    return tonumber(truck:getData('truck:loadCapacity')) or 0
end