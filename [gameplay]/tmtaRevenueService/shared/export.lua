--- Является ли игрок субъектом предпринимательской деятельности
function isPlayerBusinessEntity(player)
    local player = localPlayer or player
    if not isElement(player) then
        return false
    end
    return exports.tmtaUtils:tobool(player:getData('isBusinessEntity'))
end

--- Есть ли у игрока задолженность по налогу на недвижимость
function isPlayerHasPropertyTaxDebt(player)
    local player = localPlayer or player
    if not isElement(player) then
        return false
    end
    return not (getPlayerPropertyTaxDebt(player) == 0)
end

--- Есть ли у игрока задолженность по подоходному налогу
function isPlayerHasIncomeTaxDebt(player)
    local player = localPlayer or player
    if not isElement(player) then
        return false
    end
    return not (getPlayerIncomeTaxDebt(player) == 0)
end

--- Есть ли у игрока задолженности по налогам
function isPlayerHasTaxDebt(player)
    local player = localPlayer or player
    if not isElement(player) then
        return false
    end

    return (isPlayerHasPropertyTaxDebt(player) or isPlayerHasIncomeTaxDebt(player))
end

--- Получить задолженность по подоходому налогу игрока
function getPlayerIncomeTaxDebt(player)
    local player = localPlayer or player
    if not isElement(player) then
        return false
    end
    return tonumber(player:getData('incomeTaxPayable')) or 0
end

--- Получить задолженность по налогу на недвижимость игрока
function getPlayerPropertyTaxDebt(player)
    local player = localPlayer or player
    if not isElement(player) then
        return false
    end
    return tonumber(player:getData('propertyTaxPayable')) or 0
end