addEventHandler("onResourceStart", resourceRoot,
    function()
        Business.setup()
    end
)

addCommandHandler("createbusiness", function(player)
    if not hasObjectPermissionTo(player, "command.createbusiness", false) then
        return false
    end
    triggerClientEvent(player, "tmtaBusiness.openCreateBusinessWindow", root)
end, true, false)

addCommandHandler("delcurbusiness", function(player, cmd, businessId)
    if not hasObjectPermissionTo(player, "command.delcurbusiness", false) then
        return false
    end

    local success = Business.remove(tonumber(businessId))
    if not success then
        return
    end

    local success = Business.destroyMarker(tonumber(businessId))
    if not success then
        return
    end
    
    local message = string.format("Бизнес #%d удален!", businessId)
    triggerClientEvent(player, 'tmtaHouse.showNotice', resourceRoot, 'success', message)

end, true, false)

addEventHandler("tmtaServerTimecycle.onServerMinutePassed", root, 
    function()
        local currentTimestamp = getRealTime().timestamp
        for businessId, business in ipairs(House.getCreatedHouses()) do
            if Business.getOwnerUserId(businessId) then
                local businessData = business.businessData
                if (businessData.confiscateAt and (currentTimestamp >= businessData.confiscateAt)) then
                    Business.sell(businessId)
                elseif (businessData.accrueRevenueAt and (currentTimestamp >= businessData.accrueRevenueAt)) then
                    Business.accrueRevenue(businessId)
                end
            end
        end
    end
)

addEventHandler('tmtaRevenueService.onUserPaidTax', root,
    function(userId)
        if (type(userId) ~= 'number' or exports.tmtaRevenueService:isUserHasIncomeTaxDebt(userId)) then
            return
        end
        for _, business in pairs(Business.getUserBusiness(userId)) do
            if (type(business) == 'table') then
                if (business.confiscateAt and type(business.confiscateAt) == 'number') then
                    Business.update(business.businessId, {confiscateAt = 'NULL'}, 'dbUpdateBusiness', {businessId = business.businessId})
                end
            end
        end
    end
)