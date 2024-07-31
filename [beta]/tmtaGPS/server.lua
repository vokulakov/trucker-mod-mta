addPoint = function(element, player)
    if not isElement(element) then
        return
    end

    triggerClientEvent(player, "tmtaGPS.addPoint", player, element)
end