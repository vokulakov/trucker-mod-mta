addEvent("queenRestaurants.onPlayerBuyFood", true)
addEventHandler("queenRestaurants.onPlayerBuyFood", root, function(foodName, foodPrice, foodAdd)
	
	if exports.tmtaMoney:getPlayerMoney(source) < foodPrice then
		exports.tmtaNotification:showInfobox(
			source, 
			"info", 
			"#FFA07AРесторан", 
			"#FFFFFFУ вас недостаточно денежных средств", 
			_, 
			{240, 146, 115}
		)
		return
	end

	exports.tmtaMoney:takePlayerMoney(source, tonumber(foodPrice))
	triggerClientEvent(source, 'queenRestaurants.onPlayerEat', source)

	exports.tmtaNotification:showInfobox(
        source, 
        "info", 
        "#FFA07AРесторан", 
        "#FFFFFFВы купили #FFA07A"..foodName.."#FFFFFF за #FFA07A"..foodPrice.." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )

	local playerHunger = exports.tmtaPlayerNeeds:getPlayerHungerLevel(source)
	local giveHunger = math.ceil(foodAdd*100)
	if (playerHunger + giveHunger) >= 100 then
		giveHunger = 100 - playerHunger
	end
	exports.tmtaPlayerNeeds:givePlayerHungerLevel(source, giveHunger)
end)

local function onPickupHitEnter(player)
	if getPedOccupiedVehicle(player) then return end
	
	local pickup_data = getElementData(source, 'queenRestaurants.PickupInfo')

	fadeCamera(player, false, 1)

	setTimer(function()
		setElementPosition(player, pickup_data.x, pickup_data.y, pickup_data.z)
		setPedRotation(player, 0) 
		setElementDimension(player, pickup_data.dim)
		setElementInterior(player, pickup_data.int) 

		triggerClientEvent(player, 'queenRestaurants.music', player, not pickup_data.exit)
		
		setCameraTarget(player, player)
		fadeCamera(player, true, 1)
	end, 1500, 1)
end

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
	for _, pick in ipairs(RestaurantsConfig.position) do

		local pickup_entrance = createPickup(pick.eX, pick.eY, pick.eZ, 3, 1318, 1, 1)
		--createBlipAttachedTo(pickup_entrance, pick.blip)
		
		setElementData(pickup_entrance, 'queenRestaurants.PickupInfo', 
			{ 
				x = pick.oX,
				y = pick.oY,
				z = pick.oZ, 
				dim = pick.dim,
				int = pick.int,
				text = "Ресторан '"..pick.name.."'",
				textZ = 1
			}
		)
		
		addEventHandler("onPickupHit", pickup_entrance, onPickupHitEnter)
		--
		local pickup_exit = createPickup(pick.oX, pick.oY, pick.oZ, 3, 1318, 1)
		setElementDimension(pickup_exit, pick.dim)
		setElementInterior(pickup_exit, pick.int)
		
		setElementData(pickup_exit, 'queenRestaurants.PickupInfo', 
			{ 
				x = pick.eX, 
				y = pick.eY,
				z = pick.eZ, 
				dim = 0,
				int = 0,
				text = 'Выход',
				textZ = 1,
				exit = true
			}
		)
	
		addEventHandler("onPickupHit", pickup_exit, onPickupHitEnter)
		--
		
		local isPickup = createPickup(pick.bX, pick.bY, pick.bZ, 3, pick.pickup, 1, 1)
		setElementDimension(isPickup, pick.dim)
		setElementInterior(isPickup, pick.int)
		setElementData(isPickup, 'queenRestaurants.isPickupInfo', {name = pick.name, foods = pick.foods})
		setElementData(isPickup, 'queenRestaurants.isPickup', true)

		addEventHandler("onPickupHit", isPickup, function(hitPlayer, matchingDimension)
			triggerClientEvent(hitPlayer, "queenRestaurants.onPlayerPickupHit", hitPlayer, source)
		end)

	end
end)

