local dimensionsOffset = 2000
local usedDimensions = {}

function getDimensionForPlayer(player)
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

function clearPlayerDimension(player)
    if not isElement(player) then
        return
    end
    if isElement(usedDimensions[player.dimension - dimensionsOffset]) then
        usedDimensions[player.dimension - dimensionsOffset] = nil
    end
end