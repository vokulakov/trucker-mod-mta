for _, pick in ipairs(RestaurantsConfig.position) do
	--local blip = createBlip(pick.eX, pick.eY, pick.eZ, 50, 0, 255, 168, 0, 255, 0, 450)
	--setElementData(blip, "blip:color", {255, 175, 0, 255})
	local marker = createMarker(pick.eX, pick.eY, pick.eZ, "cylinder", 0, 255, 100, 50, 50) -- костыль
	marker.alpha = 0
	-- exports.tmtaBlip:createBlipAttachedTo(
	-- 	marker, 
	-- 	'blipRestaurant',
	-- 	{name=pick.name},
	-- 	tocolor(245, 236, 66, 255)
	-- )
end

-- Фоновая музыка
local soundBackGround 

addEvent("queenRestaurants.music", true)
addEventHandler("queenRestaurants.music", root, function(state)
	if state then
		soundBackGround = exports.tmtaSounds:playSound('int_restaurant', true)
		setSoundVolume(soundBackGround, 0.1)
	else
		if soundBackGround then
			stopSound(soundBackGround)
		end
	end
end)

addEvent("queenRestaurants.onPlayerEat", true)
addEventHandler("queenRestaurants.onPlayerEat", root, function()
	local soundFX = exports.tmtaSounds:playSound('sound_eat2')
	setSoundVolume(soundFX, 0.2)
end)

-- GUI
local sx, sy = guiGetScreenSize()
local UI = {}
local foodID = 1
local foodMax
local isPickup 

local function showWindowFood()
	if not type(isPickup) == 'table' then
		return 
	end

	foodID = 1
	foodMax = table.maxn(isPickup.foods)

	UI.wnd = guiCreateWindow(sx/2-300/2, sy/2-250/2, 300, 250, isPickup.name, false)
	guiWindowSetSizable(UI.wnd, false)
	guiWindowSetMovable(UI.wnd, false)

	UI.food_img = guiCreateStaticImage(300/2-200/2, 30, 200, 100, isPickup.foods[foodID].img, false, UI.wnd)

	--
	UI.food_name = guiCreateLabel(0, 135, 300, 20, isPickup.foods[foodID].name, false, UI.wnd)
	--UI.login.info = guiCreateLabel(0, 65, 300, 20, "Пожалуйста, авторизируйтесь.", false, UI.login.bg)
	--guiSetFont(UI.login.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.food_name, 255, 168, 0)
	guiLabelSetHorizontalAlign(UI.food_name, "center", false)

	--UI.food_info = guiCreateLabel(0, 155, 300, 20, pickup.foods[1].price..'$', false, UI.wnd)
	--guiLabelSetColor(UI.food_info, 255, 168, 0)
	--guiLabelSetHorizontalAlign(UI.food_info, "center", false)
	--

	UI.btn_prev = guiCreateButton(10, 180, 40, 60, "<", false, UI.wnd)
	guiSetProperty(UI.btn_prev, "NormalTextColour", "ffff9000")
	guiSetFont(UI.btn_prev, "sa-header")
	--UI.btn_prev:setData('tmtaSounds.UI', 'ui_change') -- звук клика

	UI.btn_next = guiCreateButton(250, 180, 40, 60, ">", false, UI.wnd)
	guiSetProperty(UI.btn_next, "NormalTextColour", "ffff9000")
	guiSetFont(UI.btn_next,"sa-header")
	--UI.btn_next:setData('tmtaSounds.UI', 'ui_change') -- звук клика

	UI.btn_buy = guiCreateButton(55, 180, 190, 35, "Купить", false, UI.wnd)
	guiSetProperty(UI.btn_buy, "NormalTextColour", "ffffffff" )
	--UI.btn_buy:setData('tmtaSounds.UI', 'ui_select') -- звук клика

	UI.btn_close = guiCreateButton(55, 220, 190, 20, "Закрыть", false, UI.wnd)
	guiSetProperty(UI.btn_close, "NormalTextColour", "ffffffff")
	--UI.btn_close:setData('tmtaSounds.UI', 'ui_select') -- звук клика
	--

	guiSetText(UI.btn_buy, "Купить за "..isPickup.foods[foodID].price.."₽")


	showCursor(true)
end

addEvent('queenRestaurants.onPlayerPickupHit', true)
addEventHandler('queenRestaurants.onPlayerPickupHit', root, function(pickup)
	isPickup = pickup:getData('queenRestaurants.isPickupInfo')
	showWindowFood()
end)

addEventHandler("onClientGUIClick", root, 
	function()
		if not isElement(UI.wnd) then
			return
		end

		if source == UI.wnd then
			return
		end

		if (type(isPickup.foods) ~= 'table') then
			return
		end

		if source == UI.btn_close then
			destroyElement(UI.wnd)
			showCursor(false)
			return
		elseif source == UI.btn_buy then
			local foodPrice = tonumber(isPickup.foods[foodID].price)
			local foodName = isPickup.foods[foodID].name
			local hungerCount = tonumber(isPickup.foods[foodID].add) or 0
			
			if (tonumber(exports.tmtaMoney:getPlayerMoney()) < foodPrice) then
				exports.tmtaNotification:showInfobox( 
					"info", 
					"#FFA07AРесторан", 
					"У вас недостаточно средств", 
					_, 
					{240, 146, 115}
				)
				return
			end

			if (exports.tmtaPlayerNeeds:getPlayerHungerLevel() >= 100) then
				exports.tmtaNotification:showInfobox( 
					"info", 
					"#FFA07AРесторан", 
					"Вы не голодны!", 
					_, 
					{240, 146, 115}
				)
				return
			end

			triggerServerEvent("queenRestaurants.onPlayerBuyFood", localPlayer, foodName, foodPrice, hungerCount)
			return
		elseif source == UI.btn_next then
			foodID = foodID + 1
			if foodID > foodMax then
				foodID = 1
			end
		elseif source == UI.btn_prev then
			foodID = foodID - 1
			if foodID == 0 then
				foodID = foodMax
			end	
		end

		guiSetText(UI.food_name, isPickup.foods[foodID].name)
		guiSetText(UI.btn_buy, "Купить за "..exports.tmtaUtils:formatMoney(tonumber(isPickup.foods[foodID].price)).." ₽")
		guiStaticImageLoadImage(UI.food_img, isPickup.foods[foodID].img)
	end
)