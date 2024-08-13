--- Является ли игрок субъектом предпринимательской деятельности
-- @param player
function isPlayerBusinessEntity(player)
    if not isElement(player) then
        return false
    end
    
    local userId = player:getData("userId")
    local result = RevenueService.getUserDataById(userId, {'isBusinessEntity'})
    if (type(result) ~= "table" or #result == 0) then
        return false
    end

    return exports.tmtaUtils:tobool(result[1].isBusinessEntity)
end

function addUserPropertyTax(userId, taxAmount)
    if (type(userId) ~= "number" or type(taxAmount) ~= "number") then
        return false
    end
    return RevenueService.addUserPropertyTax(userId, taxAmount)
end