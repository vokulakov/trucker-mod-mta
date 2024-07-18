HouseBlip = {}
local createdBlips = {}

function HouseBlip.add(houseMarker, houseNumber, color)
    if isElement(createdBlips[houseMarker]) then
        return false
    end
    
    local blip = exports.tmtaBlip:createAttachedTo(
        houseMarker, 
        'blipProperty',
        'Дом #'..tostring(houseNumber),
        color or tocolor(255, 255, 255, 255),
        80
    )

    if not blip then
        return false
    end

    createdBlips[houseMarker] = blip
end

function HouseBlip.remove(houseMarker)
    if not isElement(createdBlips[houseMarker]) then
        return false
    end
    destroyElement(createdBlips[houseMarker])
    createdBlips[houseMarker] = nil
end

function HouseBlip.update()
    for _, houseMarker in pairs(getElementsByType('marker', resourceRoot)) do
        local houseData = houseMarker:getData('houseData')
    end
end