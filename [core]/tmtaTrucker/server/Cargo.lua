local CARGO_LIST = {} -- общий список грузов
ORDER_LIST = {} -- обший список заказов

local _orderInProgress = {} -- заказы в процессе выполнения

local _orderCount = 0

local function formatVehicleTable(vehicleTable)
	if type(vehicleTable) ~= 'table' or #vehicleTable == 0 then
		return {}
	end
	local _vehicleList = {}
	for _, model in pairs(vehicleTable) do
        table.insert(_vehicleList, model, true)
    end
	return _vehicleList
end

-- Получить грузоподъёмность ТС
local _cacheVehicleLoadCapacity = {}
local function getVehicleLoadCapacityByModel(model)
    if (not model or (type(model) ~= 'number' and type(model) ~= 'string')) then
        return 0
    end

    if _cacheVehicleLoadCapacity[model] then
        return _cacheVehicleLoadCapacity[model]
    end

    local loadCapacity = exports.tmtaTruck:getTruckLoadCapacityByModel(model) or exports.tmtaTrailer:getTrailerLoadCapacityByModel(model)
    if not loadCapacity then
        return 0
    end

    table.insert(_cacheVehicleLoadCapacity, model, loadCapacity)

	return _cacheVehicleLoadCapacity[model]
end

-- Получить список точек (маркеров)
local _cacheObjectPointList = {}
function Cargo.getObjectTypePointList(objectTypeList)
    if (type(objectTypeList) ~= 'table') then
        return false
    end

    local objectPointList = {}
    for _, objectType in pairs(objectTypeList) do
        if not _cacheObjectPointList[objectType] then
            local infrastructureObjectList = Infrastructure.getObjectListByType(objectType)
            if infrastructureObjectList then
                for _, objectData in pairs(infrastructureObjectList) do
                    objectData.type = objectType
                    objectData.location = Utils.getLocationName(objectData.position.x, objectData.position.y, objectData.position.z)
                    table.insert(objectPointList, objectData)
                end
            end
            _cacheObjectPointList[objectType] = objectPointList
        else
            for _, objectData in pairs(_cacheObjectPointList[objectType]) do
				table.insert(objectPointList, objectData)
			end
        end
    end

    return objectPointList
end

-- Получить список складов
local _cacheWarehousePointList = {}
function Cargo.getWarehousePointList(warehouseList)
    if (type(warehouseList) ~= 'table') then
        return false
    end

    local warehousePointList = {}
    for _, warehouseId in pairs(warehouseList) do
        if not _cacheWarehousePointList[warehouseId] then
            local warehouseData = Infrastructure.getWarehouseDataById(tonumber(warehouseId))
            if warehouseData then

                local position = warehouseData.position
                if (type(warehouseData.position) == 'table' and table.getn(warehouseData.position) > 0) then
                    position = warehouseData.position[1]
                end

                warehouseData.location = Utils.getLocationName(position.x, position.y, position.z)

                table.insert(warehousePointList, warehouseData)
                _cacheWarehousePointList[warehouseId] = warehousePointList
            end
        else
		    for _, warehouseData in pairs(_cacheWarehousePointList[warehouseId]) do
				table.insert(warehousePointList, warehouseData)
			end
        end
    end

    return #warehousePointList > 0 and warehousePointList or false
end

-- Получить базовый опыт за выполнение заказа
function Cargo.getOrderBaseExperience(distance, weight)
    local expDistance = distance*Config.DRIVER_EXP_PER_M
    local expWeight = weight*Config.DRIVER_EXP_PER_WEIGHT
    return math.floor(expDistance + expWeight)
end

-- Получить базовое вознаграждение за выполнение заказа
function Cargo.getOrderBaseReward(distance, weight)
    local rewardDistance = distance*Config.DRIVER_REVENUE_PER_M
    local rewardWeight = weight*Config.DRIVER_REVENUE_PER_WEIGHT
    return math.floor(rewardDistance + rewardWeight)
end

-- Получить вес для груза
function Cargo.getWeights(orderWeight, vehicleList)
    local minWeight, maxWeight = orderWeight, orderWeight

    local _loadCapacity = {}
    for vehicleModel in pairs(vehicleList) do
        table.insert(_loadCapacity, tonumber(getVehicleLoadCapacityByModel(vehicleModel)))
    end
    table.sort(_loadCapacity)
    
    if (minWeight >= _loadCapacity[1]) then
        minWeight = _loadCapacity[1]
    end

    if (maxWeight >= _loadCapacity[#_loadCapacity]) then
        maxWeight = _loadCapacity[#_loadCapacity]
    end

    local weightList = {}
    if (minWeight ~= maxWeight) then
        for _, currentWeight in pairs(_loadCapacity) do
            if currentWeight >= maxWeight then
                break
            end
            table.insert(weightList, currentWeight*math.random(92, 99) /100)
        end
    end

    table.insert(weightList, maxWeight*math.random(92, 99) /100)

    return weightList
end

-- Получить список подходящих ТС для выполнения заказа
function Cargo.getOrderAvailableTruckList(weight, truckList)
    local _truckList = {}
    for truckModel in pairs(truckList) do
        if (weight <= getVehicleLoadCapacityByModel(truckModel)) then
            _truckList[truckModel] = true
        end
    end
    return _truckList
end

-- Добавить заказ в общий список
function Cargo.addOrderToList(name, category, weight, loadingPoint, deliveryPoint, truck, trailer, isDirect)
    local distance = Utils.getDistanceBetweenPoints(loadingPoint.position, deliveryPoint.position)
    local reward = Cargo.getOrderBaseReward(distance, weight)
    local truck = Cargo.getOrderAvailableTruckList(weight, truck)

    local orderId = md5(name..weight..getTickCount()+_orderCount) -- в качестве orderId выступает md5-хэш

    ORDER_LIST[orderId] = {
        orderId = orderId,
        name = name,
        category = category,
        weight = weight,
        distance = distance,
        reward = reward,
        loadingPoint = loadingPoint,
        deliveryPoint = deliveryPoint,
        route = string.format("%s — %s", loadingPoint.location.city, deliveryPoint.location.city),
        truck = truck,
        trailer = trailer,
        isDirect = isDirect or false,
        userId = false, -- id пользователя, который взял груз
        delivered = false, -- доставлен ли груз
    }
    
    _orderCount = _orderCount + 1

    return true
end

-- Получить (сгенерировать) список заказов
function Cargo.generateOrderList()
    if #CARGO_LIST == 0 then
        outputDebugString('Cargo.generateOrderList: ошибка генерации списка заказов', 1)
        return false
    end

    ORDER_LIST = {}
    _orderCount = 0
    
    local _cacheWarehouseCounter = {}
    for _, order in pairs(CARGO_LIST) do
        if not order.warehousePoint then
            -- Прямые заказы
            local _cacheWeightCounter = {}
            for _counter = 0, math.random(2, 5) do
                for _, weight in pairs(order.weightList) do
                    if not _cacheWeightCounter[weight] then
                        _cacheWeightCounter[weight] = 0
                    end

                    if (_cacheWeightCounter[weight] < 3) then
                        Cargo.addOrderToList(
                            order.name, 
                            order.category,
                            weight, 
                            order.loadingPoint[math.random(#order.loadingPoint)], 
                            order.deliveryPoint[math.random(#order.deliveryPoint)], 
                            order.truck, 
                            order.trailer,
                            true
                        )

                        _cacheWeightCounter[weight] = _cacheWeightCounter[weight] + 1
                    end
                end
            end
        else
            for _, warehouse in pairs(order.warehousePoint) do
                if not _cacheWarehouseCounter[warehouse.name] then
                    _cacheWarehouseCounter[warehouse.name] = 0
                end

                if (_cacheWarehouseCounter[warehouse.name] < 10) then

                    local positionCount = table.getn(warehouse.position)
                    if (positionCount > 0) then
                        warehouse.position = warehouse.position[math.random(positionCount)]
                    end

                    -- Заказы с производства на склад (максимальный вес)
                    Cargo.addOrderToList(
                        order.name, 
                        order.category, 
                        order.weightList[#order.weightList],
                        order.loadingPoint[math.random(#order.loadingPoint)], 
                        warehouse,
                        order.truck, 
                        order.trailer,
                        true
                    )

                    if order.deliveryPoint then
                        local _cacheWeightCounter = {}
                        for _, weight in pairs(order.weightList) do
                            if not _cacheWeightCounter[weight] then
                                _cacheWeightCounter[weight] = 0
                            end

                            if (_cacheWeightCounter[weight] < 3) then
                                Cargo.addOrderToList(
                                    order.name,
                                    order.category, 
                                    weight,
                                    warehouse, 
                                    order.deliveryPoint[math.random(#order.deliveryPoint)],
                                    order.truck, 
                                    order.trailer,
                                    false
                                )

                                _cacheWeightCounter[weight] = _cacheWeightCounter[weight] + 1
                            end
                        end
                    end

                    _cacheWarehouseCounter[warehouse.name] = _cacheWarehouseCounter[warehouse.name] + 1
                end
            end
        end
    end

    -- Добавляем в список заказы, которые на момент генерации были в прогрессе
    for orderId, order in pairs(_orderInProgress) do
        ORDER_LIST[orderId] = order
    end

    return ORDER_LIST
end

function Cargo.updatePlayerOrderList(player)
    if not isElement(player) then
        return false
    end

    triggerClientEvent(player, "tmtaTrucker.onOrderListUpdate", resourceRoot, ORDER_LIST)

    return true
end

function Cargo.updateOrderById(orderId, field)
    if (not orderId or type(field) ~= 'table') then
        return false
    end

    if (not ORDER_LIST[orderId]) then
        return false
    end

    for fieldKey, fieldData in pairs(field) do
        ORDER_LIST[orderId][fieldKey] = fieldData
    end

    triggerClientEvent("tmtaTrucker.onOrderUpdateData", resourceRoot, orderId, ORDER_LIST[orderId])

    return true
end

function Cargo.init()
    for cargoCategory, cargoData in pairs(getCargoList()) do
        local loadingPointList = Cargo.getObjectTypePointList(cargoData.loadingPoint)
        local deliveryPointList = Cargo.getObjectTypePointList(cargoData.deliveryPoint)
        local warehousePointList = Cargo.getWarehousePointList(cargoData.warehousePoint)
        local truckList = formatVehicleTable(cargoData.truck) 
        local trailerList = formatVehicleTable(cargoData.trailer)
        local vehicleList = exports.tmtaUtils:extendTable(truckList, trailerList)

        for orderId, orderData in pairs(cargoData.order) do
            orderData.category = cargoCategory
            orderData.loadingPoint = Utils.mixTable(loadingPointList)
            orderData.deliveryPoint = Utils.mixTable(deliveryPointList)
            orderData.warehousePoint = Utils.mixTable(warehousePointList)
            orderData.truck = truckList
            orderData.trailer = trailerList
            orderData.weightList = Cargo.getWeights(orderData.weight, vehicleList)
            table.insert(CARGO_LIST, orderData)
        end
    end
    outputDebugString(string.format("tmtaTrucker: сгенерировано %d груза", #CARGO_LIST))

    setTimer(
        function()
            local ms = resourceRoot:getData("cargoOrderTimerUpdate") or 0
            ms = ms - 1000

            if tonumber(ms) <= 0 then
                local systemUpTime = getTickCount()

                local orderList = Cargo.generateOrderList()
                triggerClientEvent("tmtaTrucker.onOrderListUpdate", resourceRoot, orderList)

                outputDebugString(string.format("tmtaTrucker: сгенерировано %d заказов. (%.2f сек)", _orderCount, (getTickCount()-systemUpTime)/1000))
                ms = 1000 * 60 * Config.ORDER_LIST_UPDATE_TIME
            end

            resourceRoot:setData("cargoOrderTimerUpdate", ms)
        end, 1000, 0)
end

function Cargo.isProgress(orderId)
    return not not _orderInProgress[orderId]
end

function Cargo.addInProgress(orderId)
    if (not orderId or Cargo.isProgress(orderId)) then
        return false
    end

    local order = Utils.getOrderById(orderId)
    if (not order) then
        return false
    end

    _orderInProgress[orderId] = order

    return true
end

function Cargo.removeFromProgress(orderId)
    if (not orderId or not Cargo.isProgress(orderId)) then
        return false
    end

    _orderInProgress[orderId] = nil

    return true
end

addEvent('tmtaTrucker.requestPlayerOrderAccept', true)
addEventHandler('tmtaTrucker.requestPlayerOrderAccept', resourceRoot,
    function(player, truck, orderId, orderDeliveryTime)
        if (not client or client ~= player or source ~= resourceRoot) then
            return exports.tmtaAntiCheat:detectedEventHack(player, 'tmtaTrucker.requestPlayerOrderAccept')
        end

        if (not isElement(player) or not isElement(truck)) then
            return
        end

        local order = Utils.getOrderById(orderId)
        if (not order or not Utils.isOrderAvailable(orderId) or Cargo.isProgress(orderId)) then
            return triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderAccept', resourceRoot, false)
        end

        if (not Utils.isOrderAvailableForTruck(orderId, truck)) then
            return triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderAccept', resourceRoot, false)
        end

        local playerId = player:getData('userId')
        if (not Cargo.updateOrderById(orderId, {userId = playerId, deliveryTime = orderDeliveryTime})) then
            return triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderAccept', resourceRoot, false)
        end

        Cargo.addInProgress(orderId)

        player:setData("player:orderId", orderId)

        truck:setData("truck:orderId", orderId)
        truck:setData("truck:orderName", order.name)
        truck:setData("truck:orderRoute", order.route)
        truck:setData("truck:orderReward", order.reward)
        truck:setData("truck:orderDistance", order.distance)

        Utils.showNotice("#FFFFFFЗаказ оформлен. Координаты в #FFA07Aнавигаторе #FFFFFF(нажмите #FFA07A'F11'#FFFFFF)", player)

        triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderAccept', resourceRoot, true, orderId)
        triggerClientEvent('tmtaTrucker.onOrderAccept', resourceRoot, orderId)
    end
)

addEvent('tmtaTrucker.requestAddCargoToTruck', true)
addEventHandler('tmtaTrucker.requestAddCargoToTruck', resourceRoot,
    function(player, truck, orderId)
        if (not client or client ~= player or source ~= resourceRoot) then
            return exports.tmtaAntiCheat:detectedEventHack(player, 'tmtaTrucker.requestAddCargoToTruck')
        end

        local order = Utils.getOrderById(orderId)
        if (not isElement(player) or not isElement(truck) or not order) then
            return triggerClientEvent(player, 'tmtaTrucker.onAddCargoToTruck', resourceRoot, false)
        end

        if (not Utils.isOrderAvailableForTruck(orderId, truck)) then
            return triggerClientEvent(player, 'tmtaTrucker.onAddCargoToTruck', resourceRoot, false)
        end

        if (Utils.isTruckNeedsTrailer(truck) and not getVehicleTowedByVehicle(truck)) then
            local _trailers = {}
            for trailerModel in pairs(order.trailer) do
                table.insert(_trailers, trailerModel)
            end
            
            local trailer = exports.tmtaTrailer:spawnTrailer(_trailers[math.random(#_trailers)], Vector3(truck.position), Vector3(truck.rotation))
            attachTrailerToVehicle(truck, trailer)
            truck:setData("truck:trailer", trailer)
            trailer:setData("trailer:truck", truck)
    
            local color1, color2, color3, color4 = getVehicleColor(truck)
            setVehicleColor(trailer, color1, color2, color3, color4)

            local region = exports.tmtaVehicleLicensePlate:getVehicleLicensePlateRegion(truck)
            exports.tmtaVehicleLicensePlate:setVehicleFakeRandomLicensePlate(trailer, 'ru_trailer', region)
        end

        truck:setData('truck:cargoWeight', tonumber(order.weight))
        truck:setData('truck:cargoIntegrity', 1000)
        truck:setData("truck:orderDeliveryTime", tonumber(order.deliveryTime))

        local orderTimer = setTimer(
            function()
                if not isElement(truck) then
                    return
                end

                local ms = truck:getData("truck:orderDeliveryTime") or 0
                ms = ms - 1000
                if tonumber(ms) <= 0 then
                    ms = 0
                end 
                truck:setData("truck:orderDeliveryTime", ms)
            end, 1000, 0)

        truck:setData("truck:orderTimer", orderTimer)

        triggerClientEvent(player, 'tmtaTrucker.onAddCargoToTruck', resourceRoot, true, order.deliveryPoint)
    end
)

addEvent('tmtaTrucker.onTruckUnloadMarkerHit', true)
addEventHandler('tmtaTrucker.onTruckUnloadMarkerHit', resourceRoot,
    function(truck)
        if not isElement(truck) then
            return
        end

        local orderTimer = truck:getData("truck:orderTimer")
        if not isTimer(orderTimer) then
            return
        end 

        setTimerPaused(orderTimer, true)
    end
)

function Cargo.removeOrderFromTruck(truck)
    if (not isElement(truck)) then
        return false
    end

    local orderTimer = truck:getData("truck:orderTimer")
    if isTimer(orderTimer) then 
        killTimer(orderTimer)
    end 

    local trailer = truck:getData("truck:trailer")
    if isElement(trailer) then 
        trailer:removeData("trailer:truck")
        truck:removeData("truck:trailer")
        destroyElement(trailer)
    end

    truck:removeData("truck:orderId")
    truck:removeData("truck:orderName")
    truck:removeData("truck:orderRoute")
    truck:removeData("truck:orderReward")
    truck:removeData("truck:orderDistance")
    truck:removeData("truck:cargoWeight")
    truck:removeData("truck:cargoIntegrity") 
    truck:removeData("truck:orderTimer")
    truck:removeData("truck:orderDeliveryTime")

    triggerEvent('tmtaTrucker.onRemoveOrderFromTruck', resourceRoot, truck)

    return true
end

addEvent('tmtaTrucker.onPlayerOrderComplete', true)
addEventHandler('tmtaTrucker.onPlayerOrderComplete', resourceRoot,
    function(player, truck, orderId)
        if (not client or client ~= player or source ~= resourceRoot) then
            return exports.tmtaAntiCheat:detectedEventHack(player, 'tmtaTrucker.onPlayerOrderComplete')
        end

        local order = Utils.getOrderById(orderId)
        if (not isElement(player) or not isElement(truck) or not order) then
            return triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderComplete', resourceRoot, false)
        end

        if (not Cargo.updateOrderById(orderId, {userId = false, delivered = true, deliveryTime = nil})) then
            return triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderComplete', resourceRoot, false)
        end
        triggerClientEvent('tmtaTrucker.onOrderComplete', resourceRoot, orderId)

        Cargo.removeFromProgress(orderId)

        local baseReward = order.reward
        local baseExperience = Cargo.getOrderBaseExperience(order.distance, order.weight)

        if (exports.tmtaX2:isPromoActive()) then
            baseReward = baseReward*2
            baseExperience = baseExperience*2
        end

        local bonusReward = 0
        local bonusExperience = 0

        local sanctionReward = 0
        local sanctionExperience = 0

        local orderDeliveryTime = truck:getData("truck:orderDeliveryTime")
        local cargoIntegrity = math.floor((truck:getData("truck:cargoIntegrity")*100)/1000)

        -- Если груз полностью поврежден, то заказ анулируется (неустойка)
        if (tonumber(cargoIntegrity) <= 0) then 
            return Cargo.onPlayerOrderCancel(player, orderId)
        end

        -- Бонусы за целостность и своевременность доставки
        if (tonumber(orderDeliveryTime) > 0 and tonumber(cargoIntegrity) >= 85) then
            bonusReward = bonusReward + math.floor(baseReward*(math.random(2, 4) /10))
            bonusExperience = bonusExperience + math.floor(baseExperience*0.15)
        end

        -- Неустойка за просроченность
        if (tonumber(orderDeliveryTime) < 0) then
            sanctionReward = sanctionReward + math.floor(baseReward*0.06)
            sanctionExperience = sanctionExperience + math.floor(baseExperience*0.08)
        end

        -- Неустойка за целостность
        if (tonumber(cargoIntegrity) < 55) then
            local damagePercent = (100-tonumber(cargoIntegrity))/100
            sanctionReward = sanctionReward + math.floor(baseReward*damagePercent)
            sanctionExperience = sanctionExperience + math.floor(baseExperience*damagePercent)
        end

        local reward = baseReward + bonusReward - sanctionReward
        local experience = baseExperience + bonusExperience - sanctionExperience

        local playerStatistic = player:getData('player:truckerStatistic')

        playerStatistic.currentMoney = playerStatistic.currentMoney + reward
        playerStatistic.currentOrders = playerStatistic.currentOrders + 1
        playerStatistic.currentWeight = playerStatistic.currentWeight + order.weight
        playerStatistic.currentDistance = playerStatistic.currentDistance + order.distance

        playerStatistic.totalOrders = playerStatistic.totalOrders + 1
        playerStatistic.totalWeight = playerStatistic.totalWeight + order.weight
        playerStatistic.totalDistance = playerStatistic.totalDistance + order.distance

        player:setData('player:truckerStatistic', playerStatistic)

        exports.tmtaMoney:givePlayerMoney(player, reward)
        exports.tmtaExperience:givePlayerExp(player, experience)

        triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderComplete', resourceRoot, true, {
            orderName = order.name,
            orderRoute = order.route,

            orderBaseReward = baseReward, 
            orderBaseExp = baseExperience, 

            orderBonusReward = bonusReward, 
            orderBonusExp = bonusExperience, 

            orderSanctionReward = sanctionReward, 
            orderSanctionExp = sanctionExperience,

            orderTotalReward = reward,
            orderTotalExp = experience,
        })

        player:removeData('player:orderId')
        Cargo.removeOrderFromTruck(truck)
    end
)

function Cargo.onPlayerOrderCancel(player, orderId)
    if (not client or client ~= player or source ~= resourceRoot) then
        return exports.tmtaAntiCheat:detectedEventHack(player, 'tmtaTrucker.requestPlayerOrderCanceled')
    end

    if (not isElement(player)) then
        return
    end

    local orderId = orderId or player:getData('player:orderId')
    local order = Utils.getOrderById(orderId)
    if (not orderId or not order) then
       return triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderCanceled', resourceRoot, false)
    end

    if (not Cargo.updateOrderById(orderId, {userId = false, delivered = false, deliveryTime = nil})) then
        return triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderCanceled', resourceRoot, false)
    end
    triggerClientEvent('tmtaTrucker.onOrderCanceled', resourceRoot, orderId)

    Cargo.removeFromProgress(orderId)

    local sanctionReward = math.floor(order.reward*Config.FORFEIT_PERCENT/100)
    exports.tmtaMoney:takePlayerMoney(player, sanctionReward)

    triggerClientEvent(player, 'tmtaTrucker.onPlayerOrderCanceled', resourceRoot, true, {
        orderName = order.name,
        orderRoute = order.route,
        orderSanctionReward = sanctionReward,
        orderTotalReward = sanctionReward,
    })

    player:removeData('player:orderId')

    local truck = Utils.getPlayerTruck(player)
    if (not isElement(truck)) then
        return
    end

    Cargo.removeOrderFromTruck(truck)
end
addEvent('tmtaTrucker.requestPlayerOrderCanceled', true)
addEventHandler('tmtaTrucker.requestPlayerOrderCanceled', resourceRoot, Cargo.onPlayerOrderCancel)

--TODO: вынести в античит (tmtaAntiCheat)
local protectedData = {
    ['cargoOrderTimerUpdate'] = true,

	['player:truckerStatistic'] = true,
    ['player:orderId'] = true,

    ['truck:orderId'] = true,
    ['truck:orderName'] = true,
    ['truck:orderRoute'] = true,
    ['truck:orderReward'] = true,
    ['truck:orderDistance'] = true,

    ['truck:trailer'] = true,
    
    ['truck:cargoWeight'] = true,
    ['truck:cargoIntegrity'] = true,
    ['truck:orderDeliveryTime'] = true,
    ['truck:orderTimer'] = true,
    
    ['trailer:truck'] = true,
}

addEventHandler('onElementDataChange', root, 
	function(dataName, oldValue, newValue)
		if not client then
			return
		end
        
        if (protectedData[dataName] and client ~= source) then
			if (source.type == 'vehicle' and client.vehicle == source) then
				return
			end
			
            source:setData(dataName, oldValue)
            return exports.tmtaAntiCheat:detectedChangeElementData(client, dataName, oldValue, newValue, sourceResource)
        end
	end
)