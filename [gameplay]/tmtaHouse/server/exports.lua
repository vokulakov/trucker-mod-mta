function getPlayerHouses(player, callbackFunctionName, ...)
    local userId = player:getData('userId')
    return House.getHousesPlayer(userId, callbackFunctionName, ...)
end