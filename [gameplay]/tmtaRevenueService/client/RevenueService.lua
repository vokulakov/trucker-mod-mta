RevenueService = {}

addEventHandler("onClientMarkerHit", resourceRoot, 
    function(player, matchingDimension)
        local marker = source
        if not marker:getData('isRevenueServiceMarker') then
            return
        end

        if getElementType(player) ~= "player" or player ~= localPlayer or isPedInVehicle(player) then 
            return 
        end

        local verticalDistance = player.position.z - source.position.z
        if verticalDistance > 5 or verticalDistance < -1 then
            return
        end

        if not matchingDimension then
            return
        end

        GUI.openWindow()
    end
)

function RevenueService.registerBusinessEntity()
    return triggerServerEvent('tmtaRevenueService.onPlayerRegisterBusinessEntity', resourceRoot)
end

function RevenueService.payTax(taxType, taxAmount)
    return triggerServerEvent('tmtaRevenueService.onPlayerPayTax', resourceRoot, taxType, taxAmount)
end