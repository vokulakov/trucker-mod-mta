addEvent('tmtaRevenueService.onUserPaidTax', true)
addEvent('tmtaRevenueService.onPlayerPaidTax', true)

local function createRevenueServicePickup(posX, posY, posZ)
    local marker = createMarker(posX, posY, posZ-0.6, 'cylinder', 1.5, 255, 255, 255, 0)
    local pickup = createPickup(posX+0.05, posY-0.05, posZ, 3, Config.PICKUP_ID, 500)
    
    marker:setData('isRevenueServiceMarker', true)
    marker:setData('3dText', 'Налоговая служба')

    exports.tmtaBlip:createBlipAttachedTo(
        marker, 
        'blipRevenueService',
        {name='Налоговая служба'},
        tocolor(255, 0, 0, 255)
    )

    return marker
end

addEventHandler("onResourceStart", resourceRoot,
    function()
        RevenueService.setup()
        for _, revenueService in ipairs(Config.REVENUE_SERVICE) do
            createRevenueServicePickup(revenueService.position.x, revenueService.position.y, revenueService.position.z)
        end

        for _, player in pairs(getElementsByType("player")) do 
            RevenueService.getPlayerData(player)
        end
    end
)

addEventHandler('tmtaCore.login', root, 
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end

        RevenueService.getPlayerData(player)
    end
)