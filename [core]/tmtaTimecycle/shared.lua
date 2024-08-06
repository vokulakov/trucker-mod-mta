function syncPlayerGameTime(player)
    local player = player or localPlayer
    if (not isElement(player)) then
        return false
    end

    triggerEvent('tmtaTimecycle.onServerSyncPlayerGameTime', player)
    triggerServerEvent('tmtaTimecycle.onServerSyncPlayerGameTime', player)

    return true
end

addEvent('tmtaTimecycle.onClientSyncPlayerGameTime', true)
addEventHandler('tmtaTimecycle.onClientSyncPlayerGameTime', root, 
    function(time)
        setTime(unpack(time))
        iprint(time)
    end
)