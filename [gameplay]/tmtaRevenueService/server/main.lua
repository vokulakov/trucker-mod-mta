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