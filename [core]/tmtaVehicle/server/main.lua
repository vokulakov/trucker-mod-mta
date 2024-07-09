addEvent('onVehicleCreated', true)

addEventHandler('onResourceStart', resourceRoot,
    function()
        UserVehicle.setup()
    end
)

addEventHandler('onResourceStop', resourceRoot,
    function()
    end
)

addEventHandler('onPlayerQuit', root, 
	function()
		Vehicle.destroyPlayerVehicles(source)
	end
)

addEventHandler('onVehicleStartEnter', root, 
    function(player, seat, jacked, door)
        source:setData("engineState", source.engineState)

        -- Avoid to kill drivers instant while spamming space (?)
        -- @see https://github.com/eXo-OpenSource/mta-gamemode/blob/7bb325dfdeced76d5b0c5aa8ae7c3135db41d4be/vrp/server/classes/MTAFixes.lua#L39
        if jacked and seat == 0 and door == 1 then
            toggleControl(player, "sprint", false)
            setTimer(toggleControl, 10000, 1, player, "sprint", true)
        end
    end
)

addEventHandler('onVehicleEnter', root,
    function()
        setVehicleEngineState(source, source:getData('engineState'))
    end
)