TruckRental = {}

local TRUCK_SPAWN_POSITION = {}
local createdTruck = {}

local TRUCK_COLORS = {
	{110, 110, 110},
	{0, 0, 0},
	{255, 255, 255},
	{255, 0, 0},
	{254, 197, 0},
	{125, 253, 0},
	{7, 108, 233},
	{152, 5, 246},
	{254, 119, 0},
}

local function addTruckSpawnPosition(baseId, x, y, z, rotation)
    if not TRUCK_SPAWN_POSITION[baseId] then
        TRUCK_SPAWN_POSITION[baseId] = {}
    end
    
    table.insert(TRUCK_SPAWN_POSITION[baseId], { 
        col = createColSphere(x, y, z-0.3, 2.5), 
        position = Vector3(x, y, z), 
        rotation = Vector3(0, 0, rotation),
        within = false,
    })
end

local function getTruckSpawn(baseId)
    if not TRUCK_SPAWN_POSITION[baseId] then
        return 
    end

    local freeSpawn = {}
    for _, spawn in ipairs(TRUCK_SPAWN_POSITION[baseId]) do
        if not spawn.within then
            table.insert(freeSpawn, spawn)
        end
    end

    if (#freeSpawn == 0) then 
        return false
    end 
    
    return freeSpawn[math.random(1, #freeSpawn)]
end

function TruckRental.init()
    for baseId, base in ipairs(Base.LIST) do
        for _, pos in ipairs(base.truckSpawnPosition) do
            addTruckSpawnPosition(baseId, pos.x, pos.y, pos.z, pos.rotation)
        end 
    end
end

addEvent("tmtaTrucker.onPlayerStartTruckRent", true)
addEventHandler("tmtaTrucker.onPlayerStartTruckRent", resourceRoot, 
    function(player, baseId, truckData)
        if (not client or client ~= player or source ~= resourceRoot) then
            return exports.tmtaAntiCheat:detectedEventHack(player, 'tmtaTrucker.onPlayerStartTruckRent')
        end

        if (not isElement(player) or type(baseId) ~= 'number' or type(truckData) ~= 'table') then 
            return 
        end
        
        if (truckData.level > exports.tmtaExperience:getPlayerLvl(player) and not exports.tmtaCore:isTestServer()) then
            return Utils.showNotice("Вашего опыта не хватает для аренды #FFA07A"..truckData.name, player)
        elseif (exports.tmtaMoney:getPlayerMoney(player) < tonumber(truckData.price)) then
            return Utils.showNotice("У вас нехватает денежных средств для аренды #FFA07A"..truckData.name, player)
        end

        local spawn = getTruckSpawn(baseId)
        -- if not spawn then
            -- return Utils.showNotice("К сожалению нет свободных парковочных мест. #FFA07AПопробуйте позже.", player)
        -- end

        local truck = exports.tmtaTruck:spawnTruck(truckData.model, spawn.position, spawn.rotation)
        if not isElement(truck) then 
            return
        end
    
        local color = TRUCK_COLORS[math.random(1, #TRUCK_COLORS)]
        setVehicleColor(truck, color[1], color[2], color[3])

        setVehicleDamageProof(truck, true)
        spawn.within = true

        setTimer(
            function(truck)
                setVehicleDamageProof(truck, false)
                fixVehicle(truck)
            end, 1000, 1, truck)

        player:setData("player:truck", truck)
        truck:setData("truck:player", player)
        truck:setData("truck:data", truckData)

        truck:setData("truck:rentTime", 1000 * 60 * Config.RENT_TIME) -- время аренды

        exports.tmtaVehicleLicensePlate:setVehicleFakeRandomLicensePlate(truck, 'ru')

        createdTruck[truck] = {}

        addEventHandler("onColShapeLeave", spawn.col,
            function(truck)
                if (truck.type ~= "vehicle" or not createdTruck[truck]) then 
                    return
                end
                spawn.within = false 
            end, false)

        -- Указатель на арендованный транспорт 
        local arrow = createMarker(0, 0, 0, "arrow", 2, 255, 255, 255, 170, player)
        attachElements(arrow, truck, 0, 0, 5)
        local blip = exports.tmtaBlip:createBlipAttachedTo(arrow, 'blipCheckpoint', { name = 'Арендованный транспорт' }, tocolor(255, 0, 0, 255), 100, player)

        exports.tmtaNavigation:setPoint(arrow, 'Садитесь в транспорт', player)

        createdTruck[truck].isArrow = arrow
        createdTruck[truck].isBlip = blip
        createdTruck[truck].isTimer = setTimer(Trucker.stopPlayerWork, 1 * 60 * 1000, 1, player)

        addEventHandler("onVehicleEnter", truck, 
            function(player, seat)
                local truck = source
                if (not createdTruck[truck] or truck:getData('truck:player') ~= player or seat ~= 0) then 
                    return
                end

                if (truck:getData('truck:isRent')) then
                    return
                end

                destroyElement(createdTruck[truck].isArrow)

                createdTruck[truck].isArrow = nil
                createdTruck[truck].isBlip = nil

                exports.tmtaMoney:takePlayerMoney(player, truckData.price)
                Utils.showNotice(string.format("Вы арендовали #FFA07A%s #FFFFFFза #FFA07A%s #FFFFFF₽/час", truckData.name, truckData.priceStr), player)

                setTimer(
                    function()
                        Utils.showNotice("Для поиска груза используйте #FFA07Aпланшет #FFFFFF(нажмите #FFA07A'F10'#FFFFFF)", player)
                    end, 2000, 1)

                truck:setData("truck:isRent", true)

                if isTimer(createdTruck[truck].isTimer) then
                    killTimer(createdTruck[truck].isTimer)
                end

                createdTruck[truck].isTimer = setTimer(
                    function()
                        local ms = truck:getData("truck:rentTime")
                        if ms then
                            ms = ms - 1000

                            if (tonumber(ms) < 10 * 1000 * 60) then 
                                -- если остается меньше 10 минут, то предлегать игроку продлить аренду
                                setTimerPaused(createdTruck[truck].isTimer, true)
                                triggerClientEvent(player, "tmtaTrucker.onClientTruckRentalExpired", resourceRoot, truckData, 1000 * 60 * 10)
                            elseif (tonumber(ms) <= 0) then
                                -- если остается 0 минут, то снова предложить игроку продлить аренду
                                setTimerPaused(createdTruck[truck].isTimer, true)
                                triggerClientEvent(player, "tmtaTrucker.onClientTruckRentalExpired", resourceRoot, truckData, 0)
                                ms = 0
                            end
                            
                            truck:setData("truck:rentTime", ms)
                        end
                    end, 1000, 0)

            end, false)

        Trucker.startPlayerWork(player)
    end
)

function TruckRental.playerStopTruckRent(player)
    if not isElement(player) then
        return
    end

    local truck = Utils.getPlayerTruck(player)
    if (not isElement(truck) or not createdTruck[truck]) then
        return
    end

    if isTimer(createdTruck[truck].isTimer) then
        killTimer(createdTruck[truck].isTimer)
    end

    if isElement(createdTruck[truck].isArrow) then
        destroyElement(createdTruck[truck].isArrow)
    end 

    createdTruck[truck] = nil

    truck:removeData('truck:player')
    truck:removeData('truck:isRent')
    truck:removeData('truck:rentTime')
    truck:removeData('truck:data')

    player:removeData('player:truck')

    destroyElement(truck)
end

addEvent("tmtaTrucker.onPlayerStopTruckRent", true)
addEventHandler("tmtaTrucker.onPlayerStopTruckRent", resourceRoot, 
    function(player)
        if (not client or client ~= player or source ~= resourceRoot) then
            return exports.tmtaAntiCheat:detectedEventHack(player, 'tmtaTrucker.onPlayerStopTruckRent')
        end

        TruckRental.playerStopTruckRent(player)
    end
)

function TruckRental.onPlayerExtendRent(player)
    if not isElement(player) then
        return false
    end

    local truck = Utils.getPlayerTruck(player)
    if (not isElement(truck) or not truck:getData('truck:isRent')) then
        return false
    end

    setTimerPaused(createdTruck[truck].isTimer, false)

    local truckData = truck:getData('truck:data')
    if (not truckData or type(truckData) ~= 'table') then
        return false
    end

    if (exports.tmtaMoney:getPlayerMoney(player) < tonumber(truckData.price)) then
        Utils.showNotice("У вас нехватает денежных средств для продления аренды #FFA07A"..truckData.name, player)
		return false
	end

    exports.tmtaMoney:takePlayerMoney(player, truckData.price)

    local currentRentTime = truck:getData('truck:rentTime') or 0
    truck:setData('truck:rentTime', currentRentTime + (1000 * 60 * Config.RENT_TIME))
  
    Utils.showNotice(string.format("Вы продлили аренду #FFA07A%s #FFFFFFза #FFA07A%s #FFFFFF₽", truckData.name, truckData.priceStr), player)

    return true
end

addEvent("tmtaTrucker.onPlayerExtendRent", true)
addEventHandler("tmtaTrucker.onPlayerExtendRent", resourceRoot, 
    function(player)
        if (not client or client ~= player or source ~= resourceRoot) then
            return exports.tmtaAntiCheat:detectedEventHack(player, 'tmtaTrucker.onPlayerExtendRent')
        end
        TruckRental.onPlayerExtendRent(player)
    end
)

function TruckRental.onPlayerRefuseRent(player)
    if not isElement(player) then
        return
    end

    local truck = Utils.getPlayerTruck(player)
    if (not isElement(truck) or not truck:getData('truck:isRent')) then
        return false
    end

    local truckData = truck:getData('truck:data')
    if (not truckData or type(truckData) ~= 'table') then
        return false
    end

    if isTimer(createdTruck[truck].isTimer) then
        killTimer(createdTruck[truck].isTimer)
    end
    
    truck:removeData('truck:rentTime')
    Utils.showNotice(string.format("Вы отказались продлевать аренду #FFA07A%s", truckData.name), player)

    if not truck:getData('truck:orderId') then
        Trucker.stopPlayerWork(player)
    end
end

addEvent("tmtaTrucker.onPlayerRefuseRent", true)
addEventHandler("tmtaTrucker.onPlayerRefuseRent", resourceRoot, 
    function(player)
        if (not client or client ~= player or source ~= resourceRoot) then
            return exports.tmtaAntiCheat:detectedEventHack(player, 'tmtaTrucker.onPlayerRefuseRent')
        end

        TruckRental.onPlayerRefuseRent()
    end
)

addEvent('tmtaTrucker.onRemoveOrderFromTruck', false)
addEventHandler('tmtaTrucker.onRemoveOrderFromTruck', resourceRoot,
    function(truck)
        if (not isElement(truck) or not truck:getData('truck:isRent')) then
            return
        end

        if (truck:getData('truck:rentTime')) then
            return
        end

        local player = truck:getData('truck:player')
        Trucker.stopPlayerWork(player)
    end
)