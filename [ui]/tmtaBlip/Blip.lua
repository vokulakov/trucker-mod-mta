local createdBlip = {}

-- @link https://wiki.multitheftauto.com/wiki/CreateBlipAttachedTo
-- blip createBlipAttachedTo(element elementToAttachTo [, int icon = 0, int size = 2, int r = 255, int g = 0, int b = 0, int a = 255, int ordering = 0, float visibleDistance = 16383.0, element visibleTo = getRootElement()])

local _createBlipAttachedTo = createBlipAttachedTo
function createBlipAttachedTo(elementToAttachTo, iconTextureName, blipData, color, visibleDistance, elementVisibleTo)
	if (not isElement(elementToAttachTo) or type(iconTextureName) ~= 'string' or string.len(iconTextureName) <= 0) then
		outputDebugString("createBlipAttachedTo: bad arguments", 1)
        return false
	end
	
	local blip = _createBlipAttachedTo(elementToAttachTo, 0, 2, 255, 0, 0, 255, 0, 0, elementVisibleTo)
	setBlipVisibleDistance(blip, visibleDistance or 16383.0)
	blip:setData('icon', iconTextureName)
    blip:setData('data', type(blipData) ~= 'table' and {} or blipData)
    blip:setData('color', color or tocolor(255, 255, 255, 255))

	elementToAttachTo:setData('blip', blip)
	blip:setData('attachedElement', elementToAttachTo)

	if sourceResource then
		if not createdBlip[sourceResource] then
			createdBlip[sourceResource] = {}
		end
		table.insert(createdBlip[sourceResource], blip)
	end

	return blip
end

local function destroyBlip(blip)
	if isElement(blip) then
		return destroyElement(blip)
	end
	return false
end

local function onResourceStop(stoppedRes)
	local blips = createdBlip[stoppedRes]
	if not blips then
		return
	end
	for _, blip in ipairs(blips) do
		destroyBlip(blip)
	end
	createdBlip[stoppedRes] = nil
end
addEventHandler('onClientResourceStop', root, onResourceStop)
addEventHandler('onResourceStop', root, onResourceStop)

addEventHandler('onClientElementDestroy', root, 
	function()
		destroyBlip(getElementData(source, 'blip'))
	end
)

addEventHandler('onElementDestroy', root, 
	function()
		destroyBlip(getElementData(source, 'blip'))
	end
)