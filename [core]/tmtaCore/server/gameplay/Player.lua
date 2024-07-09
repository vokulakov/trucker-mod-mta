Player = {}

function Player.kill(player)
    if not isElement(player) then
        return false
    end
    return killPed(player)
end

addEvent('tmtaCore.killPlayer', true)
addEventHandler('tmtaCore.killPlayer', root, 
    function()
        Player.kill(source)
    end
)

local _playerAnimationStopTimer = {}
function Player.setAnimation(player, group, anim)
    if (not isElement(player)) then
        return false
    end

    if isTimer(_playerAnimationStopTimer[player]) then
        return false
    end

    if (type(group) ~= 'string' or type(anim) ~= 'string') then
        setPedAnimation(player)
    else
        setPedAnimation(player, group, anim, -1, true, false, false, true)
    end

    _playerAnimationStopTimer[player] = setTimer(function() end, 500, 1)

    return true
end

addEvent('tmtaCore.setPlayerAnimation', true)
addEventHandler('tmtaCore.setPlayerAnimation', root, 
    function(group, anim)
        Player.setAnimation(source, group, anim)
    end
)

function Player.setWalkingStyle(player, walkStyleId)
    if (not isElement(player) or walkStyleId == nil or type(walkStyleId) ~= 'number') then
        return false
    end
    return setPedWalkingStyle(player, walkStyleId)
end

addEvent('tmtaCore.setPlayerWalkingStyle', true)
addEventHandler('tmtaCore.setPlayerWalkingStyle', root, 
    function(walkStyleId)
        Player.setWalkingStyle(source, tonumber(walkStyleId))
    end
)

function Player.setFightingStyle(player, fightStyleId)
    if (not isElement(player) or fightStyleId == nil or type(fightStyleId) ~= 'number') then
        return false
    end
    return setPedFightingStyle(player, fightStyleId)
end

addEvent('tmtaCore.setPlayerFightingStyle', true)
addEventHandler('tmtaCore.setPlayerFightingStyle', root, 
    function(fightStyleId)
        Player.setFightingStyle(source, tonumber(fightStyleId))
    end
)

function Player.givePlayerItem(player, itemId)
    if (not isElement(player) or itemId == nil or type(itemId) ~= 'number') then
        return false
    end
    return giveWeapon(source, itemId, 30, true)
end

addEvent('tmtaCore.givePlayerItem', true)
addEventHandler('tmtaCore.givePlayerItem', root, 
    function(itemId)
        Player.givePlayerItem(source, tonumber(itemId))
    end
)