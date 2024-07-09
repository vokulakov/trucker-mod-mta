Hospital = {}

local function pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function()   -- iterator function
		i = i + 1
	  	if a[i] == nil then 
			return nil
	  	else 
			return a[i], t[a[i]]
	  	end
	end
	return iter
end

-- Найти ближайшую больницу к игроку
-- @return Vector3 position 
function Hospital.getNearestToPlayer(player)
	if not isElement(player) then
		return false
	end
	
	local hospitalList = getHospitaList()
	local hospitalDistanceList = {}
	for hospitalIndex, hospital in ipairs(hospitalList) do
		local distance = getDistanceBetweenPoints3D(hospital.position, player.position)
		table.insert(hospitalDistanceList, math.ceil(distance), hospitalIndex)
	end
	table.sort(hospitalDistanceList)
	
	local hospital = 0
	for _, hospitalId in pairsByKeys(hospitalDistanceList) do
		hospital = hospitalId
		break
	end

	return hospitalList[hospital].position
end

-- Exports
getNearestToPlayer = Hospital.getNearestToPlayer
