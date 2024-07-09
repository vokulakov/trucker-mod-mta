local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()
local index, numberSkin, numberSkinMax, typeSkin, skinPedLook, isAnimTimer, rotationTimer

local Font = {
	RR_10 = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    RR_14 = exports.tmtaFonts:createFontGUI('RobotoRegular', 14),
}

local width, height = 400, 90

local function showWindowSkin(pickup)
	index = tonumber(getElementID(pickup))
	numberSkin = 1
	typeSkin = 'male'
	numberSkinMax = table.maxn(skinShopTable[index]["ID"][typeSkin])
	skinPreview(numberSkin)

	setCameraMatrix(skinShopTable[index].cam["CamX"], skinShopTable[index].cam["CamY"], skinShopTable[index].cam["CamZ"], skinShopTable[index].cam["lookAtX"], skinShopTable[index].cam["lookAtY"], skinShopTable[index].cam["lookAtZ"])

	windowSkin = guiCreateWindow(sW*((sDW-width)/2 /sDW), sH*((sDH-height-20) /sDH), sW*(width /sDW), sH*(height /sDH), "", false)
	guiWindowSetSizable(windowSkin, false)
	guiWindowSetMovable(windowSkin, false)

	button_male = guiCreateRadioButton(sW*((width-90)/2 /sDW), sH*(30 /sDH), sW*(90 /sDW), sH*(20 /sDH), "Мужчины", false, windowSkin)
	guiSetFont(button_male, Font.RR_10)
	guiRadioButtonSetSelected(button_male, true)

	button_female = guiCreateRadioButton(sW*((width-90)/2 /sDW), sH*(55 /sDH), sW*(90 /sDW), sH*(20 /sDH), "Женщины", false, windowSkin)
	guiSetFont(button_female, Font.RR_10)

	button_prev = guiCreateButton(sW*(10 /sDW), sH*(25 /sDH), sW*(50 /sDW), sH*(height /sDH), "<", false, windowSkin)
	guiSetProperty(button_prev, "NormalTextColour", "ffff9000")
	guiSetFont(button_prev, Font.RR_14)

	button_next = guiCreateButton(sW*((width-50-10) /sDW), sH*(25 /sDH), sW*(50 /sDW), sH*(height /sDH), ">", false, windowSkin)
	guiSetProperty(button_next, "NormalTextColour", "ffff9000")
	guiSetFont(button_next, Font.RR_14)

	button_buy = guiCreateButton(sW*((sDW-200-20) /sDW), sH*((sDH-height) /sDH), sW*(200/sDW), sH*(45/sDH), "Купить", false)
	guiSetProperty(button_buy, "NormalTextColour", "ffffffff" )
	setElementParent(button_buy, windowSkin)

	button_out = guiCreateButton(sW*((sDW-45-20)/sDW), sH*(20/sDH), sW*(45/sDW), sH*(45/sDH), 'Х', false)
    guiSetFont(button_out, Font.RR_14)
    setElementParent(button_out, windowSkin)

	showCursor (true)
	---------

	local price = skinShopTable[index]["ID"][typeSkin][numberSkin][2]
	guiSetText(windowSkin, "["..numberSkin.."/"..numberSkinMax.."]")
	guiSetText(button_buy, "Купить за "..exports.tmtaUtils:formatMoney(price).." ₽")

	--
	exports.tmtaHUD:moneyShow(sDW-100, 30)
end

function skinPreview(num)
	if not isElement(skinPedLook) then
		skinPedLook = createPed(skinShopTable[index]["ID"][typeSkin][numberSkin][1], skinShopTable[index].cam["vPosX"], skinShopTable[index].cam["vPosY"], skinShopTable[index].cam["vPosZ"], skinShopTable[index].cam["vRot"])
		setElementInterior(skinPedLook, skinShopTable[index]["int"])

		local dimension = math.random(2000, 10000)
		setElementDimension(skinPedLook, dimension)
		setElementDimension(localPlayer, dimension)

		setPedAnimation(skinPedLook, "CLOTHES", "CLO_Pose_Loop", -1, true, false)
	else
		setElementModel(skinPedLook, skinShopTable[index]["ID"][typeSkin][numberSkin][1])
	end

	setPedAnimation(skinPedLook, "CLOTHES", "CLO_Pose_Torso", -1, true, false, false, true)
	setElementRotation(skinPedLook, 0, 0, skinShopTable[index].cam["vRot"] - 90)

	isAnimTimer = setTimer(
		function()
			setPedAnimation(skinPedLook, "CLOTHES", "CLO_Pose_Loop", -1, true, false)

			rotationTimer = setTimer(function()
				if not isElement(skinPedLook) then return end
				local rotX, rotY, rotZ = getElementRotation(skinPedLook)
				setElementRotation(skinPedLook, rotX, rotY, rotZ + 5)
			end, 50, 0)

		end, 3000, 1)
end

addEventHandler("onClientGUIClick", root, function()
	if not isElement(windowSkin) then
		return
	end

	if source == windowSkin then
		return
	end

	if source == button_out or source == button_buy then
		button_buy.visible = false
		button_out.visible = false
		destroyElement(windowSkin)
		showCursor(false)

		fadeCamera(false, 1)

		setTimer(function()
			if isTimer(rotationTimer) then
				killTimer(rotationTimer)
			end

			if isTimer(isAnimTimer) then
				killTimer(isAnimTimer)
			end

			if isElement(skinPedLook) then
				destroyElement(skinPedLook)
			end

			setElementDimension(localPlayer, skinShopTable[index]["dim"])
			
			fadeCamera(true, 1)
			setCameraTarget(localPlayer, localPlayer)
			setElementFrozen(localPlayer, false)

			exports.tmtaTimecycle:syncPlayerGameTime()
			exports.tmtaUI:setPlayerComponentVisible("all", true)
    		showChat(true)
			toggleAllControls(true)
			guiSetInputMode("allow_binds")

			exports.tmtaHUD:moneyHide()
		end, 1500, 1)

		if source == button_buy then
			local id = skinShopTable[index]["ID"][typeSkin][numberSkin][1]
			local price = skinShopTable[index]["ID"][typeSkin][numberSkin][2]
			triggerServerEvent("queenSkinShop.onPlayerSkinChange", localPlayer, id, price)
		end

		return
	elseif source == button_male or source == button_female then
		if source == button_female then
			if typeSkin == 'female' then return end
			typeSkin = 'female'
		elseif source == button_male then
			if typeSkin == 'male' then return end
			typeSkin = 'male'
		end
		numberSkin = 1
		numberSkinMax = table.maxn(skinShopTable[index]["ID"][typeSkin])
	elseif source == button_next then
		numberSkin = numberSkin + 1
		if numberSkin > numberSkinMax then
			numberSkin = 1
		end	
	elseif source == button_prev then
		numberSkin = numberSkin - 1
		if numberSkin == 0 then
			numberSkin = numberSkinMax
		end	
	end

	if isTimer(rotationTimer) then
		killTimer(rotationTimer)
	end

	if isTimer(isAnimTimer) then
		killTimer(isAnimTimer)
	end

	skinPreview(numberSkin)
	local price = skinShopTable[index]["ID"][typeSkin][numberSkin][2]
	guiSetText(windowSkin, "["..numberSkin.."/"..numberSkinMax.."]")
	guiSetText(button_buy, "Купить за "..exports.tmtaUtils:formatMoney(price).." ₽")
end)

-- --
local soundBackGround 

addEvent("queenSkinShop.music", true)
addEventHandler("queenSkinShop.music", root, function(state)
	if state then
		soundBackGround = exports.tmtaSounds:playSound('int_skinshop', true)
		setSoundVolume(soundBackGround, 0.1)
	else
		if soundBackGround then
			stopSound(soundBackGround)
		end
	end
end)

-- --
local cretedPickup = {}
local isPlayerInPickup = false

addEventHandler('onClientPickupHit', resourceRoot, 
	function(player)
		if player ~= localPlayer or not cretedPickup[source] or isPlayerInPickup then 
			return 
		end

		exports.tmtaUI:setPlayerComponentVisible("all", false)
		exports.tmtaUI:setPlayerComponentVisible("notifications", true)
		showChat(false)
		toggleAllControls(false)
		guiSetInputMode("no_binds")

		setElementFrozen(localPlayer, true)
		
		fadeCamera(false, 1)
		setTimer(
			function(pickup)
				setTime(12, 0)
				setMinuteDuration(2147483647)
				fadeCamera(true, 1)
				showWindowSkin(pickup)
			end, 1500, 1, source)

		isPlayerInPickup = true
	end
)

addEventHandler('onClientPickupLeave', resourceRoot, 
	function(player)
		if player ~= localPlayer or not cretedPickup[source] then 
			return 
		end

		setTimer(
			function()
				isPlayerInPickup = false
			end, 2000, 1)
	end
)

addEventHandler('onClientResourceStart', resourceRoot, function()
	for i, M in ipairs(skinShopTable) do
		local pickupSkin = createPickup(M.skin_pickup.x, M.skin_pickup.y, M.skin_pickup.z, 3, 1275, 1000)
		setElementDimension(pickupSkin, M.dim)
		setElementInterior(pickupSkin, M.int)
		setElementID(pickupSkin, tostring(i))
		cretedPickup[pickupSkin] = true
	end
end)