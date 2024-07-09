function doBeepNextToPlayers (theVehicle)
    if theVehicle then 
        local vehicleX, vehicleY, vehicleZ = getElementPosition (theVehicle)
        local position = toJSON({vehicleX, vehicleY, vehicleZ})
        triggerClientEvent ( root, "doReverseBeep", root, position)
    end 
end
addEvent( "onReverseBeep", true )
addEventHandler( "onReverseBeep", resourceRoot, doBeepNextToPlayers )


------------------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy

------------------------------------------------------------