local TrailerSyncer = {}

addEventHandler('onTrailerAttach', root, 
    function(truck)
        local driver = getVehicleOccupant(truck)
        if (not isElement(truck) or not isElement(driver) or getElementType(driver) ~= 'player') then
            return
        end
        if (TrailerSyncer[source] ~= driver) then
            TrailerSyncer[source] = driver
            setElementSyncer(source, driver)
        end
    end
)

addEventHandler('onTrailerDetach', root, 
    function(truck)
        local x, y, z = getElementVelocity(truck)
        setElementVelocity(source, x, y, z)
    end
)

addEventHandler('onElementStopSync', root,
    function()
        if (getElementType(source) ~= 'vehicle') then
            return
        end
        TrailerSyncer[source] = getElementSyncer(source)
    end
)