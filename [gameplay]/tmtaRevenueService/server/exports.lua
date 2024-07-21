--- Является ли игрок субъектом предпринимательской деятельности
-- @param player
function isPlayerBusinessEntity(player, callbackFunctionName, ...)
    if not isElement(player) then
        return false
    end
    local userId = player:getData("userId")
    return RevenueService.getUserDataById(userId, {'isBusinessEntity'}, callbackFunctionName, ...)
end