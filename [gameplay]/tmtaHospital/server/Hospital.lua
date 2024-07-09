local PICKUP_TIME_RESPAWN = 3

local createdHealthPickup = {}
local function createHealthPickup(position)
    local pickup = createPickup(position.x, position.y, position.z, 0, 100, PICKUP_TIME_RESPAWN * 60 * 1000)
    
    exports.tmtaBlip:createBlipAttachedTo(
        pickup, 
        'blipHospital',
        {name = 'Больница'},
        tocolor(255, 0, 0, 255)
    )

    createdHealthPickup[pickup] = true
end


addEventHandler('onPlayerPickupHit', root, 
    function(pickup)
        if not createdHealthPickup[pickup] then
            return
        end

        local player = source
        playSoundFrontEnd(player, 20)
        exports.tmtaNotification:showInfobox(player, "info", '#FFA07AУведомление', 'Ваше здоровье восстановлено', _, {240, 146, 115})
    end
)

addEventHandler('onResourceStart', resourceRoot,
    function()
        local hospitalList = getHospitaList()
        for _, hospital in ipairs(hospitalList) do
            createHealthPickup(hospital.pickupPoint)
        end
    end
)