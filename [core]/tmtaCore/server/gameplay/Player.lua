Player = {}

function Player.kill()
    if not isElement(source) then
        return false
    end
    return killPed(source)
end

addEvent('tmtaCore.killPlayer', true)
addEventHandler('tmtaCore.killPlayer', root, Player.kill)