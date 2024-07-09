Experience = {}

addEvent("tmtaExperience.onPlayerGiveExperience", true)
addEvent("tmtaExperience.onPlayerLevelUp", true)

function Experience.getPlayer(player)
    local player = player or localPlayer
    if not isElement(player) then
        return 0
    end
    return tonumber(player:getData('exp')) or 0
end

function Experience.setPlayer(player, amount)
    if not isElement(player) or localPlayer then
        return false
    end
    amount = math.ceil(math.abs(amount))
    local maxExp = Utils.getMaxExperience()     
    amount = (amount >= maxExp) and maxExp or amount
    return player:setData('exp', amount)
end

function Experience.givePlayer(player, amount)
    if not isElement(player) or localPlayer then
        return false
    end
    amount = math.ceil(math.abs(amount)) -- количество выдаваемого опыта

    local currentExp = Experience.getPlayer(player)
    local currentLvl = Utils.getPlayerLevel(player)
    local expToLvl = Utils.getExpToLevelUp(currentLvl)

    local expAmount = currentExp+amount
    if ((expAmount) >= expToLvl) then
        -- Увеличиваем уровень
        --TODO: предусмотреть вариант того, что опыта может выдаться на несколько уровней вперёд, что на самом деле вряд ли
        Experience.setPlayer(player, 0)
        player:setData('lvl', currentLvl+1)
        expAmount = expAmount - expToLvl

        triggerClientEvent(player, "tmtaExperience.onPlayerLevelUp", root)
        triggerEvent("tmtaExperience.onPlayerLevelUp", player)
    end
    
    --TODO:: проверять максимальный левел
    --TODO:: получать текущий уровень и получать уровень после выдачи опыта

    --triggerClientEvent(player, "tmtaExperience.onPlayerGiveExperience", resourceRoot, amount)
    --triggerEvent("tmtaExperience.onPlayerGiveExperience", player, amount)

    return Experience.setPlayer(player, expAmount)
end