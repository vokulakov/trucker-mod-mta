Mileage = {}

local metersMul = 0.84178

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

    -- Общий пробег игрока
    currentMileage = currentMileage + (driveTotal/1000)
	localPlayer:setData("mileage", currentMileage)
end