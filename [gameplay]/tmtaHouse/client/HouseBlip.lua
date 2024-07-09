HouseBlip = {}
local createdBlips = {}

function HouseBlip.add(houseMarker, houseNumber, houseOwnerUserId)
    if isElement(createdBlips[houseMarker]) then
        return false
    end
    
    local blipData = {}
    blipData.name = 'Дом #'..tostring(houseNumber)
    blipData.isHouseBlip = true
    blipData.userId = tonumber(houseOwnerUserId) or false

    local blipColor = tocolor(0, 255, 0, 255)
    local blipOrdering = 0

    if (houseOwnerUserId) then
        if (houseOwnerUserId == localPlayer:getData('userId')) then
            blipColor = tocolor(0, 153, 255, 255)
            blipData.isOwnerLocalPlayer = true
            blipOrdering = 200
        else
            blipColor = tocolor(170, 0, 0, 255)
        end
    end

    local blip = exports.tmtaBlip:createBlipAttachedTo(houseMarker, 'blipProperty', blipData, blipColor, 80)
    setBlipOrdering(blip, blipOrdering)

    if not blip then
        return false
    end

    createdBlips[houseMarker] = blip

    return true
end

function HouseBlip.remove(houseMarker)
    if not isElement(createdBlips[houseMarker]) then
        return false
    end

    destroyElement(createdBlips[houseMarker])
    createdBlips[houseMarker] = nil

    return true
end

function HouseBlip.update(houseMarker)
    if not isElement(createdBlips[houseMarker]) then
        return false
    end
    
    if HouseBlip.remove(houseMarker) then
        local houseData = houseMarker:getData('houseData')
        return HouseBlip.add(houseMarker, houseData.houseId, houseData.userId)
    end

    return false
end

function HouseBlip.init()
    for houseMarker, blip in pairs(createdBlips) do
        destroyElement(blip)
        createdBlips[houseMarker] = nil
    end
    
    for _, houseMarker in pairs(getElementsByType('marker', resourceRoot)) do
        local houseData = houseMarker:getData('houseData')
        if houseData then
            HouseBlip.add(houseMarker, houseData.houseId, houseData.userId)
        end
    end
end