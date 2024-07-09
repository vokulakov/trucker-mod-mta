Mileage = {}

local metersMul = 0.84178

local currentMileage = 0
local currentPlayerMileage = 0

function Mileage.calculate()
    local vehicle = localPlayer.vehicle
	if (not vehicle or vehicle.controller ~= localPlayer) then
		return
	end

    local neux, neuy, neuz = getElementPosition(vehicle)

	if not altx or not alty or not altz then
		altx, alty, altz = getElementPosition(vehicle)
	end
	
	local driveTotal = getDistanceBetweenPoints3D(neux, neuy, neuz, altx, alty, altz) * metersMul
	altx, alty, altz = neux, neuy, neuz

    -- Проверка на резкую смену координат (телепорт)
    if (driveTotal > 200) then
		return
	end

	currentMileage = currentMileage + driveTotal
	vehicle:setData("mileage", currentMileage)

    -- Общий пробег игрока
	if (localPlayer:getData('player:isTrucker') and (localPlayer:getData('player:truck') == vehicle)) then
		currentPlayerMileage = currentPlayerMileage + driveTotal
		localPlayer:setData("mileage", currentPlayerMileage)
	end
end

function Mileage.startCalculate()
	currentMileage = localPlayer.vehicle:getData("mileage") or 0
	currentPlayerMileage = localPlayer:getData("mileage") or 0
	addEventHandler('onClientRender', root, Mileage.calculate)
end

function Mileage.stopCalculate()
	removeEventHandler('onClientRender', root, Mileage.calculate)
end