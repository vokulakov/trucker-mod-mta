Case = {}

local playerCases = {}

local MIN_MONEY_LIMIT = 100000 -- сколько минимум должно быть денег, чтобы появился кейс

function Case.createToPlayer(player)
	if playerCases[player] then
		return false
	end

	local x, y, z = getElementPosition(player)
	local case = createObject(1210, x, y, z)
	case.dimension = player.dimension
	case.interior = player.interior
	exports.bone_attach:attachElementToBone(case, player, 11, 0, -0.02, 0.3, 180, 0, 0)

	playerCases[player] = case

	return true
end

function Case.deleteFromPlayer(player)
	if not playerCases[player] then
		return false
	end

	destroyElement(playerCases[player])
	playerCases[player] = nil

	return true
end

function Case.checkPlayerMoney(player, currentMoney)
	if not isElement(player) then
		return
	end
	local money = currentMoney or exports.tmtaMoney:getPlayerMoney(player)
	if money >= MIN_MONEY_LIMIT then
		Case.createToPlayer(player)
	else
		Case.deleteFromPlayer(player)
	end
end

addEventHandler("tmtaMoney.onPlayerGiveMoney", root, 
	function(amountMoney, currentMoney)
		if source.vehicle then 
			return
		end
		Case.checkPlayerMoney(source, currentMoney)
	end
)

addEventHandler("tmtaMoney.onPlayerTakeMoney", root,
	function(amountMoney, currentMoney)
		if source.vehicle then 
			return
		end
		Case.checkPlayerMoney(source, currentMoney)
	end
)

addEventHandler('onPlayerVehicleEnter', root, 
	function()
		Case.deleteFromPlayer(source)
	end
)

addEventHandler('onVehicleStartExit', root, 
	function(player, seat)
		if getElementData(source, "seat:"..seat + 1) then 
			return 
		end
		Case.checkPlayerMoney(player)
	end
)

addEventHandler('onElementDestroy', root, 
	function()
		if getElementType(source) ~= "vehicle" then
			return
		end

	  	local maxPassengers = getVehicleMaxPassengers(source)
	  	if not maxPassengers then -- для трейлеров
			return
	  	end

		for i = 0, maxPassengers - 1 do
			local occupant = getVehicleOccupant(source, i)
			if occupant then
				Case.checkPlayerMoney(occupant)
			end
		end
	end
)

addEventHandler('onPlayerWeaponSwitch', root, 
	function(previousWeaponID, currentWeaponID)
		local slot = getSlotFromWeapon(currentWeaponID)
		if slot == 0 or slot == 2 then
			if not source.vehicle then
				Case.checkPlayerMoney(source)
			end
		else
			Case.deleteFromPlayer(source)
		end
	end
)

addEventHandler('onPlayerSpawn', root, 
	function()
		Case.checkPlayerMoney(source)
	end
)

addEventHandler('onPlayerQuit', root, 
	function()
		Case.deleteFromPlayer(source)
	end
)

addEventHandler("onResourceStart", resourceRoot, 
	function()
		for _, player in ipairs(getElementsByType('player')) do
			Case.checkPlayerMoney(player)
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for _, player in ipairs(getElementsByType('player')) do
			Case.deleteFromPlayer(player)
		end
	end
)

--TODO:: необходимо протестировать
setTimer(
	function()
		for player, case in pairs(playerCases) do
			if not isElement(player) then
				Case.deleteFromPlayer(player)
			end
		end
	end, 5000, 0)
