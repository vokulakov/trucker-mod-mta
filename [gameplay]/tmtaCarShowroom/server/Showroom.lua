Showroom = {}

local PlayersInShowroom = {}

local dimensionsOffset = 2000
local usedDimensions = {}

function Showroom.getDimensionForPlayer(player)
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

function Showroom.clearPlayerDimension(player)
    if not isElement(player) then
        return
    end
    if isElement(usedDimensions[player.dimension - dimensionsOffset]) then
        usedDimensions[player.dimension - dimensionsOffset] = nil
    end
end

function Showroom.playerEnter(player)
    if (not isElement(player)) then
        return
    end

    player.interior = Config.showroomObjectInterior
    player.dimension = Showroom.getDimensionForPlayer(player)

    PlayersInShowroom[player] = true
end

function Showroom.playerExit(player)
    player.interior = 0
    PlayersInShowroom[player] = nil
    Showroom.clearPlayerDimension(player)
end