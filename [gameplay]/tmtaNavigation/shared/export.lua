function setPoint(element, title, player)
    local player = player or localPlayer
    if (not isElement(element) or not isElement(player)) then
        return false
    end

    if localPlayer then
        Navigation.createPoint(element, title)
    else
        triggerClientEvent(player, 'tmtaNavigation.createPoint', player, element, title)
    end

    return true
end

function setPointWithMarker(element, title, player)
    local player = player or localPlayer
    if (not isElement(element) or not isElement(player)) then
        return false
    end

    if localPlayer then
        Navigation.createPointWithMarker(element, title)
    else
        triggerClientEvent(player, 'tmtaNavigation.createPointWithMarker', player, element, title)
    end

    return true
end