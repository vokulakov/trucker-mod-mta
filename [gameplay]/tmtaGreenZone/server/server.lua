Greenzone = {}

local Zones = {}
local Timers = {}
local Players = {}

function Greenzone.create(x, y, z, width, depth, height, message, isColsphere)
    local colsphere = isColsphere or createColCuboid(x, y, z, width, depth, height)
    Zones[colsphere] = {}

    createRadarArea(x, y, width, depth, 0, 255, 0, 125)

    -- Сообщение
    if message then 
        Zones[colsphere].message = message
    end

    for _, player in ipairs(getElementsByType("player")) do
        if isElementWithinColShape(player, colsphere) then
            Greenzone.onPlayerZone(player)
        end
    end

    for _, vehecle in ipairs(getElementsByType("vehicle")) do
        setVehicleDamageProof(vehecle, true)
    end

    return colsphere
end 

function Greenzone.onPlayerZone(player)
    if not isElement(player) then 
        return 
    end 

    Players[player] = {}
    Players[player].weaponSlot = getPedWeaponSlot(player)

    setPedWeaponSlot(player, 0)

    if Config.controlsProtected then
        for _, control in pairs(Config.controls) do
            toggleControl(player, control, false)
        end
    end
    playSoundFrontEnd(player, 12)
    player:setData("inGreenZone", true)
end

function Greenzone.checkPlayer(player)
    if (not isElement(player) or not player:getData("inGreenZone")) then
        return
    end
    return Greenzone.onPlayerZone(player)
end
addEventHandler("onPlayerDamage", root, function() Greenzone.checkPlayer(source) end)
addEventHandler("onPlayerWeaponSwitch", root, function() Greenzone.checkPlayer(source) end)
addEventHandler("onPlayerWeaponFire", root, function() Greenzone.checkPlayer(source) end)

function Greenzone.onElementHit(element)
    if not Zones[source] then 
        return 
    end 

    if isTimer(Timers[element]) then 
        killTimer(Timers[element])
        Timers[element] = nil
    end 

    if element.type == "player" then 
        Greenzone.onPlayerZone(element)
    
        if Zones[source].message then 
            --triggerClientEvent(element, "tmtaGreenZones.showWelcomeMessage", element, Zones[source].message, "ДОБРО ПОЖАЛОВАТЬ", 3)
        end 

    elseif element.type == "vehicle" then 
        setVehicleDamageProof(element, true)
    end 
end
addEventHandler("onColShapeHit", root, Greenzone.onElementHit)

function Greenzone.onElementLeave(element)
    if not Zones[source] then
        return 
    end

    if element.type == "player" then 

        setPedWeaponSlot(element, Players[element].weaponSlot)

        for _, control in pairs(Config.controls) do
            toggleControl(element, control, true)
        end

        element:removeData("inGreenZone")
        playSoundFrontEnd(element, 20)
        Players[element] = nil

    elseif element.type == "vehicle" then 
        Timers[element] = setTimer(
            function(vehicle)
                if isElement(vehicle) then
                    return
                end
                setVehicleDamageProof(vehicle, false)
            end, 1000, 1, element)
    end 
end
addEventHandler("onColShapeLeave", root, Greenzone.onElementLeave)

function Greenzone.onResourceStart()
    for _, zone in ipairs(Config.zones) do
        Greenzone.create(zone.x, zone.y, zone.z, zone.width, zone.depth, zone.height)
    end
end
addEventHandler("onResourceStart", resourceRoot, Greenzone.onResourceStart)

function Greenzone.onResourceStop()
end
addEventHandler("onResourceStop", resourceRoot, Greenzone.onResourceStop)

-- Exports
create = Greenzone.create