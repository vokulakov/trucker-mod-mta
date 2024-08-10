addEventHandler("onResourceStart", resourceRoot,
    function()
        House.setup()

        local houses = House.getList()
        for _, houseData in pairs(houses) do
            House.create(houseData)
        end

    end
)

-- Функция на обновление парковочных мест игрока
--TODO: при продаже снимать количество парковочных мест
--TODO: при продаже дома предупреждать игрока о том, что у него есть тачки и их необходимо продать
function updatePlayerLots(player, houseData)
    if not isElement(player) then
        return
    end

    local currentGarageSlots = player:getData("garageSlot") or 0
    player:setData("garageSlot", currentGarageSlots + houseData.parkingSpaces)
end

addEventHandler("tmtaServerTimecycle.onServerMinutePassed", root, 
    function()
        local currentTimestamp = getRealTime().timestamp
    end
)

-- Окно создания дома
addCommandHandler("createhouse", function(player)
    if not hasObjectPermissionTo(player, "command.createhouse", false) then
        return false
    end
    triggerClientEvent(player, "tmtaHouse.openCreateHouseWindow", root)
end, true, false)

addCommandHandler("delcurhouse", function(player, cmd, houseId)
    if not hasObjectPermissionTo(player, "command.delcurhouse", false) then
        return false
    end
    local success = House.remove(player, tonumber(houseId))
    if not success then
        return
    end

    local success = House.destroy(tonumber(houseId))
    if not success then
        return
    end
    
    local message = string.format("Дом #%d удален!", houseId)
    triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'success', message)
end, true, false)