addEvent('onClientVehicleSetColor', true)

addEvent("tmtaVehPaints.paintGarageBuyVehicleColor", true)
addEventHandler("tmtaVehPaints.paintGarageBuyVehicleColor", root, 
    function(money, r, g, b, r1, g1, b1, r2, g2, b2)
        local vehicle = source.vehicle
        if not isElement(vehicle) then
            return
        end

        local BodyColor = {r, g, b}
        local BodyColorAdditional = {r1, g1, b1}
        vehicle:setData('BodyColor', BodyColor)
        vehicle:setData('BodyColorAdditional', BodyColorAdditional)
        
        exports.tmtaMoney:takePlayerMoney(source, money)
        exports.tmtaNotification:showInfobox(
            source,
            "info", 
            "#FFA07AПокрасочная", 
            "Вы покрасили транспорт за #FFA07A"..exports.tmtaUtils:formatMoney(money).." #FFFFFF₽", 
            _, 
            {240, 146, 115}
        )

        triggerClientEvent(root, 'onClientVehicleSetColor', vehicle, BodyColor, BodyColorAdditional)
        triggerEvent('onClientVehicleSetColor', vehicle, BodyColor, BodyColorAdditional)
    end
)