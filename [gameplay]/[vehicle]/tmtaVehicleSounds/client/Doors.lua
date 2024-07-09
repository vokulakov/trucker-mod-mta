Doors = {}

function Doors.onVehicleDoorUpdate(vehicle, door)
    if not isElement(vehicle) then 
        return 
    end 

    if not isElement(door.sound) then
        local sound_src = (door.state == 'open') and 'assets/sounds/general/doorclose.mp3' or 'assets/sounds/general/dooropen.mp3'
    
        local sound = playSound3D(sound_src, 0, 0, 0)
        setSoundEffectEnabled(sound, 'gargle', true)
        attachElements(sound, vehicle)

        door.sound = sound
    end

    return door.sound
end

function Doors.getVehicleDoorsState(vehicle)
    if not Vehicles[vehicle].doors then 
        return 
    end 

    for _, door in pairs(Vehicles[vehicle].doors) do 
        local currentState = Doors.getVehicleDoorState(vehicle, door.id)
      
        if door.state ~= currentState then
            door.sound = Doors.onVehicleDoorUpdate(vehicle, door)
            door.state = currentState
        end
       
    end
end

function Doors.getVehicleDoorState(vehicle, door)
    if not isElement(vehicle) then 
        return 
    end 

    if getVehicleDoorState(vehicle, door) == 4 then
        return 'missing'
    end

    local ratio = getVehicleDoorOpenRatio(vehicle, door)

    return (ratio == 0) and 'close' or 'open'    
end

function Doors.onVehicleStreamIn(vehicle)
    if Vehicles[vehicle].doors then 
        return 
    end     

    Vehicles[vehicle].doors = {}

    -- 0 (капот), 1 (багажник), 2 (передняя левая), 3 (передняя правая), 4 (задняя левая), 5 (задняя правая)
    for i = 0, 5 do
        local state = Doors.getVehicleDoorState(vehicle, i)
        table.insert(Vehicles[vehicle].doors, i + 1, {id = i, state = state})
    end
end 

function Doors.onVehicleStreamOut(vehicle)
    if not Vehicles[vehicle].doors then 
        return 
    end 

    for _, door in pairs(Vehicles[vehicle].doors) do
        if isElement(door.sound) then 
            destroyElement(door.sound)
        end
    end

    Vehicles[vehicle].doors = nil
end 