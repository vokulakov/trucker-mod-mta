local function createRevenueServicePickup(posX, posY, posZ)
    local marker = createMarker(posX, posY, posZ-0.6, 'cylinder', 1.5, 255, 255, 255, 0)
    local pickup = createPickup(posX+0.05, posY-0.05, posZ, 3, Config.PICKUP_ID, 500)
    marker:setData('isRevenueServiceMarker', true)

    return marker
end

addEventHandler("onResourceStart", resourceRoot,
    function()
        RevenueService.setup()
        for _, revenueService in ipairs(Config.REVENUE_SERVICE) do
            createRevenueServicePickup(revenueService.position.x, revenueService.position.y, revenueService.position.z)
        end
    end
)

addEventHandler('tmtaCore.register', root,
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end

        local userId = player:getData('userId')
        RevenueService.add(userId, "callbackGetUserData", {player = player})
    end
)

addEventHandler('tmtaCore.login', root, 
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end

        local userId = player:getData('userId')
        RevenueService.getUserDataById(userId, {}, 'callbackGetUserData', {player = player})
    end
)

function callbackGetUserData(result, params)
	if not params then
        return
    end

    local player = params.player
    if not isElement(player) then
        return
    end

	local success = not not result
    if (not success) then
        if (result == nil) then
            local userId = player:getData('userId')
            return RevenueService.add(userId, "callbackGetUserData", {player = player})
        end

        return
    end

    player:setData('individualNumber', result.individualNumber)
end