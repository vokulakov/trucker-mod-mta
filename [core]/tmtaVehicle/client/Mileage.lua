Mileage = {}

local metersMul = 0.84178

local currentMileageInM = 0
local currentMileageInKm = 0
local currentMileage = 0

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

	if (currentMileageInM >= 1000) then
		currentMileageInM = 0
	end

	currentMileageInM = currentMileageInM + driveTotal -- в метрах
	currentMileageInKm = currentMileageInKm + (driveTotal/1000)

	vehicle:setData("mileage", {km = currentMileageInKm, m = currentMileageInM})

    -- Общий пробег игрока
	if (localPlayer:getData('player:isTrucker') and (localPlayer:getData('player:truck') == vehicle)) then
		currentMileage = currentMileage + (driveTotal/1000)
		localPlayer:setData("mileage", currentMileage)
	end
end

function Mileage.startCalculate()
	local mileage = localPlayer.vehicle:getData("mileage")
	currentMileageInM = mileage and mileage.m or 0
	currentMileageInKm = mileage and mileage.km or 0
	currentMileage = localPlayer:getData("mileage") or 0
	addEventHandler("onClientRender", root, Mileage.calculate)
end

function Mileage.stopCalculate()
	removeEventHandler("onClientRender", root, Mileage.calculate)
end