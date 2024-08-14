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

--- Есть ли у игрока задолженность по налогу на имущество
-- @param player
function isPlayerHasPropertyTaxDebt(player)
    if not isElement(player) then
        return false
    end
    return not (tonumber(player:getData('propertyTaxPayable')) == 0)
end

function isUserHasPropertyTaxDebt(userId)
    if type(userId) ~= 'number' then
        return false
    end

    local result = RevenueService.getUserDataById(userId, {'propertyTaxPayable'})
    if (type(result) ~= "table" or #result == 0) then
        return false
    end

    return not (tonumber(result[1].propertyTaxPayable) == 0)
end

function userPayPropertyTax(userId)
    if (type(userId) ~= "number") then
        return false
    end

    local propertyTaxAmount = player:getData('propertyTaxPayable')
    if (tonumber(propertyTaxAmount) <= 0) then
        return false
    end

    return true
end