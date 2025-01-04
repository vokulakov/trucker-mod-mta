addEventHandler('onResourceStart', resourceRoot, 
    function()
        Trucker.setup()
        TruckRental.init()
        setTimer(Cargo.init, 1000, 1)
        for _, player in pairs(getElementsByType("player")) do
            Trucker.getPlayerStatistic(player)
        end
    end
)

addEventHandler('onResourceStop', resourceRoot, 
    function()
        for _, player in pairs(getElementsByType("player")) do
            Trucker.stopPlayerWork(player)
        end
    end
)

addEventHandler('tmtaCore.login', root, 
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end

        Trucker.getPlayerStatistic(player)
    end
)

addEventHandler('onPlayerQuit', root, 
    function()
        Trucker.stopPlayerWork(source)
    end
)

addEventHandler('onPlayerWasted', root, 
    function()
        Trucker.stopPlayerWork(source)
    end
)

addEventHandler('onVehicleExplode', root, 
    function()
        if (not source:getData('isTruck')) then
            return
        end

        local player = source:getData('truck:player')
        if not isElement(player) then
            return
        end

        Trucker.stopPlayerWork(player)
    end
)

addEventHandler('onElementDestroy', root, 
    function()
        if (not isElement(source) or source.type ~= "vehicle" or not source:getData('isTruck')) then
            return 
        end

        local player = source:getData('truck:player')
        if not isElement(player) then
            return
        end

        Trucker.stopPlayerWork(player)
    end
)

addEventHandler('tmtaServerTimecycle.onWeekdayChange', root, 
    function()
        Trucker.resetDailyStatistics()
        for _, player in pairs(getElementsByType("player")) do
            Trucker.getPlayerStatistic(player)
        end
    end
)