KeyPanel = {}
KeyPanel.created = {}

local isClientRestore = false
local iconOffsetPosX = 5 -- отступы от иконки

local createdKeyPanel = {}

local function dxDrawKeyPanel(keyPanel)
    local keyPanelData = createdKeyPanel[keyPanel]
    local iconOffsetPosX = sW*((iconOffsetPosX) /sDW)
    dxSetRenderTarget(keyPanel, true)
        dxSetBlendMode('modulate_add')
        Rectangle.draw(0, 0, keyPanelData.width, keyPanelData.height, tocolor(0, 0, 0, keyPanelData.alpha), true)
        for _, key in pairs(keyPanelData.keys) do
            dxDrawImage(key.offsetPosX+iconOffsetPosX, (key.height-key.icon.height) /2, key.icon.width, key.icon.height, key.icon.img)
            dxDrawText(key.text, key.offsetPosX+iconOffsetPosX+key.icon.width, 0, key.offsetPosX+key.width, key.height, tocolor(255, 255, 255, 255), sW/sDW*1.0, Font['RR_10'], 'center', 'center')
        end
        dxSetBlendMode('blend')
    dxSetRenderTarget()
end

function KeyPanel.create(posX, posY, keys, isRectangle)
    if (type(posX) ~= 'number' or type(posY) ~= 'number' or type(keys) ~= 'table') then
        outputDebugString("KeyPanel.create: bad arguments", 1)
        return false
    end

    local isRectangle = (type(isRectangle) == 'boolean') and isRectangle or true
    local rectangleWidth = 0
    local rectangleHeight = 0

    local iconOffsetPosX = sW*((iconOffsetPosX) /sDW)

    local _keys = {}
    for keyIndex, keyData in pairs(keys) do
        local icon = Texture[keyData[1]]
        local text = keyData[2]
        if (isElement(icon) and type(text) == 'string') then
            local iconWidth, iconHeight = dxGetMaterialSize(icon)
            local textWidth = dxGetTextWidth(text, sW/sDW*1.0, Font['RR_10'])
            local textWidth, textHeight = dxGetTextSize(text, textWidth, sW/sDW*1.0, Font['RR_10'], false)

            local width = iconOffsetPosX + iconWidth + iconOffsetPosX + textWidth + iconOffsetPosX
            local height = (textHeight < iconHeight) and iconHeight or textHeight
            height = (isRectangle) and height + 10 or height
            height = sH*((height) /sDH)

            table.insert(_keys, {
                offsetPosX = rectangleWidth,
                width = width,
                height = height,
                text = text,
                icon = { 
                    img = icon, 
                    width = sW*((iconWidth) /sDW), 
                    height = sH*((iconHeight) /sDH) 
                },
            })

            rectangleWidth = rectangleWidth + width
            rectangleHeight = height
        end
    end

    local keyPanelWidth = sW*((rectangleWidth + iconOffsetPosX) /sDW)
    local keyPanelHeight = sH*(rectangleHeight /sDH)
    local keyPanel = dxCreateRenderTarget(keyPanelWidth, keyPanelHeight, true)
    if not (keyPanel) then
		outputDebugString("KeyPanel: Failed to create renderTarget")
		return
	end

    createdKeyPanel[keyPanel] = {
        posX    = posX,
        posY    = posY,
        width   = keyPanelWidth,
        height  = keyPanelHeight,
        alpha   = (not isRectangle) and 0 or 175,
        keys    = _keys,
    }

    dxDrawKeyPanel(keyPanel)

    if sourceResource then
		if not KeyPanel.created[sourceResource] then
			KeyPanel.created[sourceResource] = {}
		end
		table.insert(KeyPanel.created[sourceResource], keyPanel)
	end

    return keyPanel
end

function KeyPanel.createActionKey(key, action)
    local element = KeyPanel.create(0, 0, {{key, action}}, true)
    local width, height = KeyPanel.getSize(element)
    KeyPanel.setPosition(element, sW*((sW-width)/2 /sDW), sH*((sH-height-40) /sDH))
    return element
end

function KeyPanel.destroy(keyPanel)
    if (not createdKeyPanel[keyPanel]) then
        return false
    end
    createdKeyPanel[keyPanel] = nil
    return true
end

function KeyPanel.render()
    for keyPanel, keyPanelData in pairs(createdKeyPanel) do
        if isClientRestore then
            dxDrawKeyPanel(keyPanel)
        end
        dxDrawImage(keyPanelData.posX, keyPanelData.posY, keyPanelData.width, keyPanelData.height, keyPanel, 0, 0, 0, tocolor(255, 255, 255, 255))
    end
end

function KeyPanel.getSize(keyPanel)
    if (not createdKeyPanel[keyPanel]) then
        outputDebugString('KeyPanel.getSize: bad arguments', 1)
        return false
    end
    return createdKeyPanel[keyPanel].width, createdKeyPanel[keyPanel].height
end

function KeyPanel.getPosition(keyPanel)
    if (not createdKeyPanel[keyPanel]) then
        outputDebugString('KeyPanel.getPosition: bad arguments', 1)
        return false
    end
    return createdKeyPanel[keyPanel].posX, createdKeyPanel[keyPanel].posY
end


function KeyPanel.setPosition(keyPanel, posX, posY)
    if (not createdKeyPanel[keyPanel] or type(posX) ~= 'number' or type(posY) ~= 'number') then
        outputDebugString('KeyPanel.setPosition: bad arguments', 1)
        return false
    end
    createdKeyPanel[keyPanel].posX = posX
    createdKeyPanel[keyPanel].posY = posY
    return true
end

addEventHandler('onClientRestore', root, 
    function()
        isClientRestore = true
        setTimer(function() isClientRestore = false end, 500, 1)
    end
)

addEventHandler('onClientElementDestroy', root, 
    function()
        if (source.type ~= 'texture') then
            return
        end
        KeyPanel.destroy(source)
    end
)

addEventHandler("onClientResourceStop", root,
	function(stoppedRes)
		local keyPanels = KeyPanel.created[stoppedRes]
		if not keyPanels then
			return
		end

		for _, keyPanel in ipairs(keyPanels) do
			if isElement(keyPanel) then
				destroyElement(keyPanel)
			end
		end

		KeyPanel.created[stoppedRes] = nil
	end
)

-- Exports
guiKeyPanelCreate = KeyPanel.create
guiKeyPanelGetSize = KeyPanel.getSize
guiKeyPanelGetPosition = KeyPanel.getPosition
guiKeyPanelSetPosition = KeyPanel.setPosition

guiCreateActionKey = KeyPanel.createActionKey