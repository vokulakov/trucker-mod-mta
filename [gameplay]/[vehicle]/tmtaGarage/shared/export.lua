--- Получить количество слотов в гараже игрока
function getPlayerGarageSlotCount(player)
    local player = player or localPlayer
    if not isElement(player) then
        return false
    end
    return tonumber(player:getData('garageSlot')) or 0
end

--- Получить количество свободных слотов в гараже игрока
function getPlayerFreeGarageSlotCount(player)
    local player = player or localPlayer
    if not isElement(player) then
        return false
    end

    local freeGarageSlotCount = tonumber(getPlayerGarageSlotCount(player)) -tonumber(exports.tmtaVehicle:getPlayerVehiclesCount(player))
    return (freeGarageSlotCount > 0) and freeGarageSlotCount or 0
end