RoadsideAssistance = {}

addEvent("tmtaTrucker.onPlayerTruckMaintenance", true)
addEventHandler("tmtaTrucker.onPlayerTruckMaintenance", root, 
    function(truck, fuelCount, healthCount, price)
        if not isEventHandlerSafe(client, source, eventName) then
            return
        end

        local player = client
        if (not isElement(truck) or not isElement(player)) then
            return
        end

        local rX, rY, rZ = getElementRotation(truck)
        setElementRotation(truck, 0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)

        if (exports.tmtaMoney:getPlayerMoney(player) < tonumber(price)) then
            Utils.showNotice("У вас нехватает денежных средств для оплаты услуг технической помощи!", player)
            return false
        end

        exports.tmtaMoney:takePlayerMoney(player, tonumber(price))

        playSoundFrontEnd(player, 46)

        truck:setData('fuel', truck:getData('fuel') + tonumber(fuelCount))
        setElementHealth(truck, 1000)
        fixVehicle(truck)
        
        Utils.showNotice("Вы воспользовались услугами технической помощи на дороге #FFFFFFза #FFA07A"..price.." #FFFFFF₽", player)
    end
)