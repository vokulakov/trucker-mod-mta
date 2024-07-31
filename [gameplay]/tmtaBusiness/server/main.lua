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