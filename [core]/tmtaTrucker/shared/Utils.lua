Utils = {}

function Utils.showNotice(message, player)
    local title = "#FFA07AДальнобойщик"
    if (not player and localPlayer) then
        return exports.tmtaNotification:showInfobox("info", title, message, _, {240, 146, 115})
    else
        return exports.tmtaNotification:showInfobox(player, "info", title, message, _, {240, 146, 115})
    end
end

function Utils.formatWeightToString(value)
	if type(value) ~= 'number' then
		return false
	end
	local ton = value/1000
	if ton < 1 then
		return string.format("%d кг", value)
	end
	return string.format("%.2f т", ton)
end

function Utils.subStr(string, len)
	if type(string) ~= 'string' or type(len) ~= 'number' then
		return false
	end
	return (utf8.len(string) > len) and utf8.sub(string, 0, len) .. '...' or string
end

function Utils.mixTable(table)
	if (not table or type(table) ~= 'table') then
		return false
	end
	
    local counter = #table
	
    while counter > 1 do
        local index = math.random(counter)
        table[index], table[counter] = table[counter], table[index]
        counter = counter - 1
    end

    return table
end

local _cacheVehicleNames = {}
function Utils.getVehicleNameFromModel(model)
    if _cacheVehicleNames[model] then
        return _cacheVehicleNames[model]
    end

    local readableName = exports.tmtaVehicle:getVehicleReadableNameFromName(model)
    if not readableName then
        return false
    end

    _cacheVehicleNames[model] = readableName
    return readableName
end

function Utils.getLocationName(posX, posY, posZ)
	if type(posX) ~= 'number' or type(posY) ~= 'number' or type(posZ) ~= 'number' then
		return ""
	end

 	local locationName = getZoneName(posX, posY, posZ)
    local cityName = getZoneName(posX, posY, posZ, true)
	
	local result = {
		city = cityName,
		location = (locationName ~= cityName) and tostring(locationName) or ""
	}
	return result
end

function Utils.getDistanceBetweenPoints(pointA, pointB)
	if type(pointA) ~= 'table' or type(pointB) ~= 'table' then
		return false
	end
    return math.floor(getDistanceBetweenPoints3D(pointA.x, pointA.y, pointA.z, pointB.x, pointB.y, pointB.z))
end

function Utils.getPlayerTruck(player, isController)
	local player = player or localPlayer
	if not isElement(player) then
        return false
    end

	local truck = player:getData("player:truck")

	local isController = (type(isController) == 'boolean') and isController or false
	if (
        not isElement(truck) 
		or (isController and truck.controller ~= player)
		or (not exports.tmtaTruck:isTruck(truck))
        or (truck:getData("truck:player") ~= player)
    ) then
        return false
    end

	return truck
end

function Utils.isTruckNeedsTrailer(truck)
	if not isElement(truck) then
        return false
    end
	return exports.tmtaTruck:isTruckNeedsTrailer(truck)
end

--- Получить данные заказа по id
function Utils.getOrderById(orderId)
	if (not orderId or type(orderId) ~= 'string') then
		return false
	end

	if (not ORDER_LIST[orderId]) then
		return false
	end
	
	return ORDER_LIST[orderId]
end

--- Получить текущий заказ игрока
function Utils.getPlayerCurrentOrderId(player)
	local player = player or localPlayer
	if not isElement(player) then
        return false
    end

	local orderId = player:getData('player:orderId')
	local truck = Utils.getPlayerTruck(player)
	if (isElement(truck)) then
        orderId = truck:getData('truck:orderId')
    end

	local orderData = Utils.getOrderById(orderId)
	if not orderData then
		return false
	end

	return orderId
end

--- Проверить доступен ли заказ
function Utils.isOrderAvailable(orderId)
	if (not orderId or type(orderId) ~= 'string') then
		return false
	end

	local order = Utils.getOrderById(orderId)
	if not order then
		return false
	end

	return (not order.delivered and not order.userId)
end

--- Проверить доступен ли заказ для грузовика
function Utils.isOrderAvailableForTruck(orderId, truck)
	if (not orderId or type(orderId) ~= 'string' or not isElement(truck)) then
		return false
	end

	local order = Utils.getOrderById(orderId)
	if not order then
		return false
	end

	return (order.truck[truck.model] or (Utils.isTruckNeedsTrailer(truck) and order.isDirect))
end

-- Проверка. Находится ли ТС на земле
--TODO: перенести в tmtaUtils
function Utils.isVehicleWheelOnGround(vehicle)
    if not isElement(vehicle) then
        return
    end

    for wheel_id = 0, 3 do
        local wheel_ground = isVehicleWheelOnGround(vehicle, wheel_id)
        if not wheel_ground then 
            return false
        end
    end 

    return true
end