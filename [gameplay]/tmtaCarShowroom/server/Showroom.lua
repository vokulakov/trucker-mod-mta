Showroom = {}

local PlayersInShowroom = {}

function Showroom.playerEnter(player)
    if (not isElement(player) or PlayersInShowroom[player]) then
        return
    end

    player.interior = Config.showroomObjectInterior
    player.dimension = getDimensionForPlayer(player)

    PlayersInShowroom[player] = true
end

function Showroom.playerExit(player)
    player.interior = 0
    PlayersInShowroom[player] = nil
   clearPlayerDimension(player)
end