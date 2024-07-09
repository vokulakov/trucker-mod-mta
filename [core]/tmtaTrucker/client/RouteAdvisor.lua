RouteAdvisor = {}
RouteAdvisor.visible = false

RouteAdvisor.settings = {
    bgColor = tocolor(33, 33, 33, 200),
    headColor = tocolor(33, 33, 33, 255),
    textColor =  tocolor(255, 255, 255, 255),
    itemBgColor = tocolor(242, 171, 18, 100),
    itemTextColor = tocolor(255, 255, 255, 150),
    itemLineColor = tocolor(255, 255, 255, 100),
}

local function getTruckerData(dataname)
	local truck = localPlayer.vehicle
	if not isElement(truck) or truck.controller ~= localPlayer then 
		return false 
	end
	return truck:getData(dataname)
end

local items = {
	{ 
        title = "Ранг", 
        get = function()
            local lvl = exports.tmtaExperience:getPlayerLvl()
            return exports.tmtaExperience:getRankFromLvl(lvl) or "" 
        end,
    },
	{ 
        title = "Рейсов", 
        get = function()
            local PlayerStatistics = localPlayer:getData("player:truckerStatistic")
            if (not PlayerStatistics) then 
                return 0 
            end 
            return PlayerStatistics.totalOrders or 0
        end,
    },
    {},
    { 
        title = "Груз", 
        get = function() 
            return Utils.subStr(getTruckerData("truck:orderName"), 25) or '-' 
        end, 
    },
	{ 
        title = "Маршрут", 
        get = function() 
            return Utils.subStr(getTruckerData("truck:orderRoute"), 30) or '-' 
        end,
    },
    { 
        title = "Вес", 
        get = function() 
            local cargoWeight = getTruckerData("truck:cargoWeight")
            if (type(cargoWeight) ~= 'number') then
                return '-'
            end
            return Utils.formatWeightToString(cargoWeight)
        end,
    },
	{ 
        title = "Целостность",        
        get = function()
            local cargoIntegrity = getTruckerData("truck:cargoIntegrity")
            if (type(cargoIntegrity) ~= 'number') then
                return '-'
            end
            return (tonumber(cargoIntegrity) <= 0) and "0 %" or math.floor((cargoIntegrity*100)/1000).." %"
        end,
    },
	{ 
        title = "Актуальность",       
        get = function()
            local orderTime = getTruckerData("truck:orderDeliveryTime")
            if (type(orderTime) ~= 'number') then
                return '-'
            end
            return string.format('%02d:%02d мин', exports.tmtaUtils:convertMsToTimeStr(orderTime))
        end,
    },
	{ 
        title = "Доход",  
        get = function()
            local reward = getTruckerData("truck:orderReward")
            if (type(reward) ~= 'number') then
                return '-'
            end
            return string.format('%s ₽', exports.tmtaUtils:formatMoney(reward))
        end,
    },
    {},
    {
        title = "Аренда",  
        get = function()
            local rentTime = getTruckerData("truck:rentTime")
            if (type(rentTime) ~= 'number') then
                return '-'
            end
            return string.format('%02d:%02d мин', exports.tmtaUtils:convertMsToTimeStr(rentTime))
        end,
    },
}

local offset = 25
local width, height = 300, #items*offset-offset+5
local posX, posY

addEventHandler("onClientHUDRender", root, 
    function ()
        if not RouteAdvisor.visible or not exports.tmtaUI:isPlayerComponentVisible("hud") then
            return
        end
    
        local truck = localPlayer.vehicle
        if (not isElement(truck) or truck.controller ~= localPlayer) then
            return
        end
    
        posX, posY = sDW-width-10, 150

        dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((20) /sDH), RouteAdvisor.settings.headColor)
        dxDrawText('Route Advisor', sW*((posX+5) /sDW), sH*((posY+3) /sDH), sW*((width) /sDW), sH*((20) /sDH), RouteAdvisor.settings.textColor, sW/sDW*1.0, dxFont['RB_8'], 'left', 'top')
        dxDrawRectangle(sW*((posX) /sDW), sH*((posY+20) /sDH), sW*((width) /sDW), sH*((height) /sDH), RouteAdvisor.settings.bgColor)
    
        local prev = 0
        for _, item in ipairs(items) do
            if (item.title) then
                dxDrawRectangle(sW*((posX+5) /sDW), sH*((posY+(prev)+offset) /sDH), sW*((100) /sDW), sH*((18) /sDH), RouteAdvisor.settings.itemBgColor)
                dxDrawText(item.title, sW*((posX+5) /sDW), sH*((posY+(10+prev)+offset) /sDH), sW*((posX+5+100) /sDW), sH*((posY+(10+prev)+offset) /sDH), RouteAdvisor.settings.textColor, sW/sDW*1.0, dxFont['RB_8'], 'center', 'center')
                dxDrawRectangle(sW*((posX+10+100) /sDW), sH*((posY+(prev)+offset) /sDH), sW*((width-100-15) /sDW), sH*((18) /sDH), RouteAdvisor.settings.bgColor)
                dxDrawText(tostring(item.get()), sW*((posX+10+100) /sDW), sH*((posY+(10+prev)+offset) /sDH), sW*((posX+width-5) /sDW), sH*((posY+(10+prev)+offset) /sDH), RouteAdvisor.settings.itemTextColor, sW/sDW*1.0, dxFont['RR_8'], 'center', 'center')
                prev = prev + offset
            else
                dxDrawRectangle(sW*((posX+5) /sDW), sH*((posY+(prev)+offset) /sDH), sW*((width-10) /sDW), 1, RouteAdvisor.settings.itemLineColor)
                prev = prev + 5
            end
        end
    
        dxDrawText("Скрыть/показать Route Advisor 'M'", sW*((posX+5) /sDW), sH*((posY+20) /sDH), sW*((width) /sDW), sH*((posY+20+height-2) /sDH), RouteAdvisor.settings.itemLineColor, sW/sDW*1.0, dxFont['RR_7'], 'left', 'bottom')
    end
)

addEventHandler('onClientVehicleEnter', root, 
    function(player, seat)
        if (player ~= localPlayer or seat ~= 0) then
            return
        end
    
        local truck = Utils.getPlayerTruck()
        if (not isElement(truck) or truck ~= source) then
            return
        end

        RouteAdvisor.visible = true
    end
)

addEventHandler('onClientVehicleStartExit', root, 
    function(player, seat)
        if (player ~= localPlayer or seat ~= 0) then
            return
        end
        RouteAdvisor.visible = false
    end
)

addEventHandler('onClientElementDestroy', root, 
    function()
	    if (getElementType(source) ~= "vehicle" or getPedOccupiedVehicle(localPlayer) ~= source) then
            return
        end
		RouteAdvisor.visible = false
    end
)

addEventHandler("onClientPlayerWasted", localPlayer, 
    function()
	    if (not getPedOccupiedVehicle(source)) then 
            return 
        end
	    RouteAdvisor.visible = false
    end
)

bindKey('m', 'up', 
    function()
        local truck = Utils.getPlayerTruck()
        if (not isElement(truck)) then
            return
        end
        RouteAdvisor.visible = not RouteAdvisor.visible
    end
) 