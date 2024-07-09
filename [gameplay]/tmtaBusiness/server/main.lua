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

addEventHandler('tmtaServerTimecycle.onServerMinutePassed', root, 
    function()
        local currentTimestamp = getRealTime().timestamp
        for businessId, business in ipairs(Business.getCreatedBusiness()) do
            local ownerUserId = Business.getOwnerUserId(businessId)
            local businessData = business.businessData
            if (ownerUserId and businessData) then
                if (businessData.confiscateAt and currentTimestamp >= businessData.confiscateAt) then
                    if (exports.tmtaRevenueService:isUserHasIncomeTaxDebt(ownerUserId)) then
                        Business.sell(businessId)
                    else
                        Business.update(businessId, {confiscateAt = 'NULL'}, 'dbUpdateBusiness', {businessId = businessId})
                    end
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
            if (type(business) == 'table' and business.confiscateAt) then
                Business.update(business.businessId, {confiscateAt = 'NULL'}, 'dbUpdateBusiness', {businessId = business.businessId})
            end
        end
    end
)

setTimer(
    function()
        for businessId, business in ipairs(Business.getCreatedBusiness()) do
            local ownerUserId = Business.getOwnerUserId(businessId)
            local businessData = business.businessData
            if (ownerUserId and businessData) then
                if (businessData.confiscateAt and not exports.tmtaRevenueService:isUserHasIncomeTaxDebt(ownerUserId)) then
                    Business.update(businessId, {confiscateAt = 'NULL'}, 'dbUpdateBusiness', {businessId = businessId})
                end
            end
        end
    end, 5 * 60 * 1000, 0)