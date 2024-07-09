addEvent("queenSkinShop.onPlayerSkinChange",true)
addEventHandler("queenSkinShop.onPlayerSkinChange", root, function(skinid, skinprice)

	if exports.tmtaMoney:getPlayerMoney(source) < skinprice then
		exports.tmtaNotification:showInfobox(
			source, 
			"info", 
			"#FFA07AМагазин скинов", 
			"#FFFFFFУ вас недостаточно денежных средств", 
			_, 
			{240, 146, 115}
		)
		return
	end

	exports.tmtaMoney:takePlayerMoney(source, tonumber(skinprice))

	setElementModel(source, skinid)

	exports.tmtaNotification:showInfobox(
        source, 
        "info", 
        "#FFA07AМагазин скинов", 
        "#FFFFFFВы купили скин за #FFA07A"..exports.tmtaUtils:formatMoney(skinprice).." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )

end)

local function onPickupHitEnter(player)
	local pickup_data = getElementData(source, 'queenSkinShop.PickupInfo')

	fadeCamera(player, false, 1)

	setTimer(function()
		setElementPosition(player, pickup_data.x, pickup_data.y, pickup_data.z)
		setPedRotation(player, 0) 
		setElementDimension(player, pickup_data.dim)
		setElementInterior(player, pickup_data.int) 

		triggerClientEvent(player, 'queenSkinShop.music', player, not pickup_data.exit)
		
		setCameraTarget(player, player)
		fadeCamera(player, true, 1)
	end, 1500, 1)

end

addEventHandler('onResourceStart', getResourceRootElement(), function()
	for _, shop in ipairs(skinShopTable) do

		local pickup_entrance = createPickup(
			shop.entrance.x, 
			shop.entrance.y,
			shop.entrance.z, 
		3, 1318, 1)

		setElementData(pickup_entrance, 'queenSkinShop.PickupInfo', 
			{ 
				x = shop.exit.x, 
				y = shop.exit.y,
				z = shop.exit.z, 
				dim = shop.dim,
				int = shop.int,
			}
		)

		setElementData(pickup_entrance, '3dText', 'Магазин скинов')

		exports.tmtaBlip:createBlipAttachedTo(
			pickup_entrance, 
			'blipClothes',
			{name = 'Магазин скинов'},
			tocolor(0, 255, 255, 255)
		)
		
		addEventHandler("onPickupHit", pickup_entrance, onPickupHitEnter)
		
		local pickup_exit = createPickup(
			shop.exit.x, 
			shop.exit.y,
			shop.exit.z, 
		3, 1318, 1)
		setElementDimension(pickup_exit, shop.dim)
		setElementInterior(pickup_exit, shop.int)

		setElementData(pickup_exit, 'queenSkinShop.PickupInfo', 
			{ 
				x = shop.entrance.x, 
				y = shop.entrance.y,
				z = shop.entrance.z, 
				dim = 0,
				int = 0,
				exit = true,
				text = 'Выход',
				textZ = 1
			}
		)
		addEventHandler("onPickupHit", pickup_exit, onPickupHitEnter)
	end
end)