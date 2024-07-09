------------------------------

local beepTimer = {}

local vehiclesBeep = {
    [515] = true,
    [403] = true, 
    [514] = true,
    [578] = true,
    --[[
    [422] = true, 
    [440] = true,
    [482] = true, 
    [414] = true,
    [605] = true,
    [543] = true,
    [499] = true,
    ]]
}

function TruckReverseSound(position)
    local truck = localPlayer.vehicle 
    if not isElement(truck) or not vehiclesBeep[truck.model] then
        return
    end 
    
    local x,y,z = unpack(fromJSON(position))
    local sfx = playSound3D("sfx/SFX_REVERSE_BEEP_2.mp3", x, y, z, false) 
    setSoundMaxDistance( sfx, 30 )
end
addEvent ( "doReverseBeep", true )
addEventHandler ( "doReverseBeep", root, TruckReverseSound )

function detectDirection ()
    local theVehicle = getPedOccupiedVehicle (localPlayer)
    if theVehicle then
        local matrix = getElementMatrix ( theVehicle )
        local velocity = Vector3(getElementVelocity(theVehicle))
        local DirectionVector = (velocity.x * matrix[2][1]) + (velocity.y * matrix[2][2]) + (velocity.z * matrix[2][3]) 
        if (DirectionVector < 0) then
            triggerServerEvent ( "onReverseBeep", resourceRoot,theVehicle)
        end
    end 
end


function truckSound(thePlayer, seat)
    if thePlayer == localPlayer then
        if(seat == 0) then
            if eventName =="onClientVehicleEnter" then 
                local model = getElementModel(source)
                if vehiclesBeep[model] then
                    beepTimer[source] = setTimer ( detectDirection, 1000, 0 )
                end
            elseif eventName =="onClientVehicleExit" then 
                if isTimer(beepTimer[source]) then 
                    killTimer (beepTimer[source])
                    beepTimer[source] = nil
                end
            end 
        end
    end
end
addEventHandler("onClientVehicleEnter", root,truckSound)
addEventHandler("onClientVehicleExit",root,truckSound)

------------------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy

------------------------------------------------------------