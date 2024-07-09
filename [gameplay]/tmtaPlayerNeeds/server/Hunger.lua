addEvent("tmtaPlayerNeeds.onPlayerTakeHunger", true)
addEventHandler("tmtaPlayerNeeds.onPlayerTakeHunger", root,
    function(hungerAmount)
        local player = source
        if not isElement(player) then
            return
        end

        if hungerAmount > 0 then
            return
        end

        local health = getElementHealth(player)
        local takeHealth = (health > 20) and 5 or 3
        setElementHealth(player, getElementHealth(player) - takeHealth)
		setPedAnimation(player, "ped", "gas_cwr", -1, false, false, false, false)
    end
)