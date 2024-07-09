BusinessBlip = {}

local createdBlips = {}

function BusinessBlip.add(businessMarker, businessId, businessOwnerUserId)
    if isElement(createdBlips[businessMarker]) then
        return false
    end
    
    local blipData = {}
    blipData.name = 'Бизнес #'..tostring(businessId)
    blipData.isBusinessBlip = true
    blipData.userId = tonumber(businessOwnerUserId) or false

    local blipColor = tocolor(0, 255, 0, 255)
    local blipOrdering = 0
    
    if (businessOwnerUserId) then
        if (businessOwnerUserId == localPlayer:getData('userId')) then
            blipColor = tocolor(0, 153, 255, 255)
            blipData.isOwnerLocalPlayer = true
            blipOrdering = -100
        else
            blipColor = tocolor(170, 0, 0, 255)
        end
    end

    local blip = exports.tmtaBlip:createBlipAttachedTo(businessMarker, 'blipBusiness', blipData, blipColor, 80)
    setBlipOrdering(blip, blipOrdering)

    if not blip then
        return false
    end

    createdBlips[businessMarker] = blip

    return true
end

function BusinessBlip.remove(businessMarker)
    if not isElement(createdBlips[businessMarker]) then
        return false
    end

    destroyElement(createdBlips[businessMarker])
    createdBlips[businessMarker] = nil

    return true
end

function BusinessBlip.update(businessMarker)
    if not isElement(createdBlips[businessMarker]) then
        return false
    end
    
    if BusinessBlip.remove(businessMarker) then
        local businessData = businessMarker:getData('businessData')
        return BusinessBlip.add(businessMarker, businessData.bussinesId, businessData.userId)
    end

    return false
end

function BusinessBlip.init()
    for businessMarker, blip in pairs(createdBlips) do
        destroyElement(blip)
        createdBlips[businessMarker] = nil
    end
    
    for _, businessMarker in pairs(getElementsByType('marker', resourceRoot)) do
        local businessData = businessMarker:getData('businessData')
        if businessData then
            BusinessBlip.add(businessMarker, businessData.bussinesId, businessData.userId)
        end
    end
end