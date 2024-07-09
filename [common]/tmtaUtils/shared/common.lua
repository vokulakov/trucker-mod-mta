--- Поиск ближайшего элемента по типу
--@tparam player - игрок
--@tparam elementType - тип элемента
--@tparam distance - радиус поиска
--@tparam data - дата элемента
--@tparam value - значение даты элемента
function getNearestElementByType(player, elementType, distance, data, value, _resourceRoot)
	if (not isElement(player) or not elementType or type(elementType) ~= 'string') then
		return false
	end

	distance = distance or 999999999
	_resourceRoot = _resourceRoot or root

	local px, py, pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)

	local lastMinDis = distance-0.0001
	local nearestElement = false

	local _foundElements = {}
	for index, element in ipairs(getElementsByType(elementType, _resourceRoot)) do
		if (not data or (data and value and element:getData(data) == value) or (data and not value and element:getData(data))) then
			if (getElementInterior(element) == pint and getElementDimension(element) == pdim) then
				local ex, ey, ez = getElementPosition(element)
				local dis = getDistanceBetweenPoints3D(px, py, pz, ex, ey, ez)
				if (dis < distance) then
					if dis < lastMinDis then 
						lastMinDis = dis
						nearestElement = element
					end
				end
			end
		end
	end

	return nearestElement
end