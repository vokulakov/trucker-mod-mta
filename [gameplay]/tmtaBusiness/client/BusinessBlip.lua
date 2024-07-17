BusinessBlip = {}

local createdBlips = {}

function BusinessBlip.add(businessMarker, businessId, color)
    if isElement(createdBlips[businessMarker]) then
        return false
    end
    
    local blip = exports.tmtaBlip:createAttachedTo(
        businessMarker, 
        'blipBusiness',
        'Бизнес #'..tostring(businessId),
        color or tocolor(255, 255, 255, 255),
        40
    )

    if not blip then
        return false
    end

    createdBlips[businessMarker] = blip
end

function BusinessBlip.remove(businessMarker)
    if not isElement(createdBlips[businessMarker]) then
        return false
    end
    destroyElement(createdBlips[businessMarker])
    createdBlips[businessMarker] = nil
end