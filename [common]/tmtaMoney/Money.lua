Money = {}

--TODO:: сделать события на выдачу денег
addEvent("tmtaMoney.onPlayerGiveMoney", true)
addEvent("tmtaMoney.onPlayerTakeMoney", true)

function Money.getPlayer(player)
    local player = player or localPlayer
    if not isElement(player) then
        return 0
    end
    return tonumber(player:getData('money')) or 0
end

function Money.setPlayer(player, amount)
    if not isElement(player) or localPlayer then
        return false
    end
    amount = math.abs(amount)
    player:setData('money', math.ceil(amount))
    return true
end 

function Money.givePlayer(player, amount)
    if not isElement(player) or localPlayer then
        return false
    end 
    local money = Money.getPlayer(player)
    amount = math.ceil(math.abs(amount))
    local currentMoney = money+amount

    triggerClientEvent(player, "tmtaMoney.onPlayerGiveMoney", resourceRoot, amount, currentMoney)
    triggerEvent("tmtaMoney.onPlayerGiveMoney", player, amount, currentMoney)

    exports.tmtaLogger:log(
        "money",
        string.format(
            "Игроку %s (userId %d) выданы деньги в количестве %d", 
            player.name,
            player:getData("_id"),
            amount
        )
    )

    return Money.setPlayer(player, currentMoney)
end

function Money.takePlayer(player, amount)
    if not isElement(player) or localPlayer then
        return false
    end
    local money = Money.getPlayer(player)
    amount = math.ceil(math.abs(amount))
    local currentMoney = money-amount

    if (currentMoney < 0) then
        outputDebugString("Money.takePlayer: a negative number!", 1)
        return false
    end

    triggerClientEvent(player, "tmtaMoney.onPlayerTakeMoney", resourceRoot, amount, currentMoney)
    triggerEvent("tmtaMoney.onPlayerTakeMoney", player, amount, currentMoney)

    exports.tmtaLogger:log(
        "money",
        string.format(
            "У игрока %s (userId %d) списаны деньги в количестве %d", 
            player.name,
            player:getData("_id"),
            amount
        )
    )

    return Money.setPlayer(player, currentMoney)
end

-- Exports
getPlayerMoney = Money.getPlayer
givePlayerMoney = Money.givePlayer
setPlayerMoney = Money.setPlayer
takePlayerMoney = Money.takePlayer