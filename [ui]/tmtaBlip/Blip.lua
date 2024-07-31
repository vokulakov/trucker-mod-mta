Blip = {}
Blip.created = {}

-- Создание блипа
-- @param integer x, y, z
-- @param sring iconName
function Blip.createAttachedTo(elementToAttachTo, iconName, blipInfo, color, visibleDistance, elementVisibleTo)
    if not isElement(elementToAttachTo) or type(iconName) ~= 'string' or type(blipInfo) ~= 'string' then
        outputDebugString("Blip.create: bad arguments", 1)
        return false
    end

    local blip = createBlipAttachedTo(elementToAttachTo, 0, 2, 255, 0, 0, 255, 0, 0, elementVisibleTo)
    setBlipVisibleDistance(blip, visibleDistance or 16383.0)
    blip:setData('icon', iconName)
    blip:setData('info', blipInfo)
    blip:setData('color', color or tocolor(255, 255, 255, 255))

    if sourceResource then
		if not Blip.created[sourceResource] then
			Blip.created[sourceResource] = {}
		end
		table.insert(Blip.created[sourceResource], blip)
	end

    return blip
end

local function onResourceStop(stoppedRes)
	local blips = Blip.created[stoppedRes]
	if not blips then
		return
	end
	
	for _, blip in ipairs(blips) do
		if isElement(blip) then
			destroyElement(blip)
		end
	end

	Blip.created[stoppedRes] = nil
end

addEventHandler('onClientResourceStop', root, onResourceStop)
addEventHandler('onResourceStop', root, onResourceStop)

-- Exports
createAttachedTo = Blip.createAttachedTo