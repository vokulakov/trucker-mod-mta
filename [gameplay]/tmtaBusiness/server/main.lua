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
end, true, false)