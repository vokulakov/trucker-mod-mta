addEventHandler("onResourceStart", resourceRoot,
    function()
        House.setup()
    end
)

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
    
    local message = string.format("Дом №%d удален!", houseId)
    triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'success', message)
end, true, false)

setTimer(function()
    for houseId in ipairs(House.getCreatedHouses()) do
        House.save(houseId)
    end

    outputDebugString("[tmtaHouse] Autosave completed!")
    exports.tmtaLogger:log("houses", "Autosave completed!")
end, Config.AUTOSAVE_INTERVAL * 60 * 1000, 0)

addEventHandler("tmtaServerTimecycle.onServerMinutePassed", root, 
    function()
        local currentTimestamp = getRealTime().timestamp
        for houseId, house in ipairs(House.getCreatedHouses()) do
            local houseData = house.data
            if House.getOwnerUserId(houseId) then
                if (houseData.confiscateAt and (currentTimestamp >= houseData.confiscateAt)) then
                    House.sell(houseId)
                elseif (houseData.taxAt and (currentTimestamp >= houseData.taxAt)) then
                    House.chargeTax(houseId)
                end
            end
        end
    end
)

addEventHandler('tmtaRevenueService.onUserPaidTax', root,
    function(userId)
        if (type(userId) ~= 'number' or exports.tmtaRevenueService:isUserHasPropertyTaxDebt(userId)) then
            return
        end
        for _, house in pairs(House.getUserHouses(userId)) do
            if (type(house) == 'table') then
                if (house.confiscateAt and type(house.confiscateAt) == 'number') then
                    House.update(house.houseId, {confiscateAt = 'NULL'}, 'dbUpdateHouse', {houseId = house.houseId})
                end
            end
        end
    end
)