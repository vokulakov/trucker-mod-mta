Garage = {}

local GaragesList = {}
local PlayersInTuning = {}

function Garage.create(id, position, size)
    if not position or not size then 
        return false
    end 

    local cuboid = createColCuboid(position, size)
    GaragesList[cuboid] = {}
    GaragesList[cuboid].id = id

    return true
end

addEventHandler("onColShapeHit", root, function(player)
    if player.type ~= "player" or not player.vehicle or player.vehicle.controller ~= player or not GaragesList[source] then
        return
    end 

    local garageID = GaragesList[source].id
    if not garageID then 
        return
    end

    if isTimer(GaragesList[source].timer) then 
        killTimer(GaragesList[source].timer)
        GaragesList[source].timer = nil
    end

    if (not isGarageOpen(garageID)) then
        setGarageOpen(garageID, true)
    end
end)

addEventHandler("onColShapeLeave", root, function(player)
    if player.type ~= "player" or not player.vehicle or player.vehicle.controller ~= player or not GaragesList[source] then
        return
    end 

    local garageID = GaragesList[source].id
    if not garageID then 
        return
    end

    if isGarageOpen(garageID) then
        if #getElementsWithinColShape(source, "vehicle") > 1 then
            return
        end
        GaragesList[source].timer = setTimer(setGarageOpen, 2000, 1, garageID, false)
    end
end)

-- Вход игрока в гараж
function Garage.playerEnter(player)
    if not isElement(player) or not player.vehicle then
        return
    end

    -- Позиция
    player.vehicle.position = Config.garageVehiclePosition
    player.vehicle.rotation = Config.garageVehicleRotation
    
    -- Интерьер
    player.interior = Config.garageInterior
    player.vehicle.interior = Config.garageInterior

    local dimension = Garage.getDimensionForPlayer(player)
    player.dimension = dimension
    player.vehicle.dimension = dimension

    player.vehicle.velocity = Vector3()
    player.vehicle.turnVelocity = Vector3()
    player.vehicle.engineState = false

	triggerClientEvent(player, "tmtaVehTuning.onPlayerEnterGarage", player)
end

addEvent("tmtaVehTuning.onPlayerEnterGarage", true)
addEventHandler("tmtaVehTuning.onPlayerEnterGarage", root, function()
    local player = client
    if not isElement(player) then 
        return
    end 

	if player.dimension ~= 0 then
        return
    end

    if not player.vehicle or player.vehicle.controller ~= player then
        return
    end

    -- Высадить пассажиров
    for _, occupant in pairs(player.vehicle.occupants) do
        if occupant ~= player then
            occupant.vehicle = nil
        end
    end

    PlayersInTuning[player] = true
   	fadeCamera(player, false, 1)
    setTimer(Garage.playerEnter, 1100, 1, player)
end)

function Garage.playerExit(player)
    if not isElement(player) then
        return
    end

    if not PlayersInTuning[player] then
        return
    end

    if player.vehicle then
        player.vehicle.interior = 0
        player.vehicle.dimension = 0
        player.vehicle.engineState = true
    else
        player.dimension = 0
    end

    player.interior = 0
    PlayersInTuning[player] = nil
    Garage.clearPlayerDimension(player)
	
    triggerClientEvent(player, "tmtaVehTuning.onPlayerExitGarage", player)

    fadeCamera(player, true, 1)
end

addEvent("tmtaVehTuning.onPlayerExitGarage", true)
addEventHandler("tmtaVehTuning.onPlayerExitGarage", root, function()
    fadeCamera(client, false, 1)
    setTimer(Garage.playerExit, 1100, 1, client)
end)

-- Выбор свободного dimension для игрока
local dimensionsOffset = 2000
local usedDimensions = {}

function Garage.getDimensionForPlayer(player)
    if not isElement(player) then
        return 0
    end
    local maxPlayers = getMaxPlayers()
    for i = 1, maxPlayers do
        if not isElement(usedDimensions[i]) or usedDimensions[i] == player then
            usedDimensions[i] = player
            return dimensionsOffset + i
        end
    end
end

function Garage.clearPlayerDimension(player)
    if not isElement(player) then
        return
    end
    if isElement(usedDimensions[player.dimension - dimensionsOffset]) then
        usedDimensions[player.dimension - dimensionsOffset] = nil
    end
end

addEventHandler('onPlayerQuit', root, 
    function()
        Garage.playerExit(source)
    end
)

addEventHandler('onPlayerWasted', root, 
	function()
        Garage.playerExit(source)
	end
)

addEventHandler('onElementDestroy', root, 
    function()
        if getElementType(source) ~= 'vehicle' then
            return
        end
        Garage.playerExit(source.controller)
    end
)