Needs = {}

--https://minecraft.fandom.com/wiki/Hunger

-- foodLevel (max 20) - текущий уровень голода игрока
-- foodSaturationLevel (default: 5, max = foodLevel) - текущий уровень истощения игрока

-- foodLevel >= 18 - регенерация здоровья и возможность бега
-- foodLevel <= 6 - теряется возможность бегать

-- https://wiki.multitheftauto.com/wiki/GetPedMoveState

-- Игрок полностью истощается за 4 часа (если ничего не делать)
local hungerTime = 4 -- время постоянного истощения (в сек.)
local hungerPerTime = 0.028 -- постоянный уровень истощения

local exhaustionHungerLevelIncrease = {
	--['fire'] = 0.1, -- за каждую нанесенную атаку
	--['damage'] = 0.1, -- за каждый полученнный урон
	
	['jog'] = 0.005, -- за обычный бег
	
	['jump'] = 0.05, -- за прыжок
	['sprint'] = 0.1, -- за спринт

	--['swimming'] = 0.01, -- за метр
	--['jumping_while_sprinting'] = 0.2, -- за прыжок
}
--[[
function Hunger.onPlayerSwim(player)
	local player = player or localPlayer
	if not isElement(player) then
		return false
	end
	if not isElementInWater(localPlayer) then
		return false
	end
end
]]
function Needs.onPlayerAction(player)
	local player = player or localPlayer
	if not isElement(player) then
		return false
	end
	local moveState = getPedMoveState(player)
	return exhaustionHungerLevelIncrease[moveState] or 0
end

function Needs.getPlayer(player)
    if not isElement(player) then
        return
    end

	local hunger = Hunger.getPlayer(player)
	player:setData('hunger', hunger)

    return { hunger = hunger }
end

addEventHandler("tmtaCore.onPlayerSpawn", root, 
    function(isWasted)
        local player = source
        if not isElement(player) then
            return
        end

        Needs.getPlayer(player)

        if isWasted then
            Hunger.setPlayer(player, 100)
        end
    end
)

setTimer(
	function()
        if not isElement(localPlayer) then
            return
        end
		local amount = hungerPerTime + Needs.onPlayerAction()
		Hunger.takePlayer(localPlayer, hungerPerTime)
	end, hungerTime * 1000, 0)

addEventHandler("onClientKey", root, 
	function(key, press)
        if not isElement(localPlayer) then
            return
        end
		Hunger.takePlayer(localPlayer, Needs.onPlayerAction())
	end
)