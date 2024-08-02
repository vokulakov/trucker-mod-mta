KeyPanel = {}

local isClientRestore = false
local iconOffsetPosX = 5 -- отступы от иконки

local createdKeyPanel = {}

local function dxDrawKeyPanel(keyPanel)
    local keyPanel = createdKeyPanel[keyPanel]
    local iconOffsetPosX = sW*((iconOffsetPosX) /sDW)
    dxSetRenderTarget(renderTarget, true)
        dxSetBlendMode('modulate_add')
        Rectangle.draw(0, 0, keyPanel.width, keyPanel.height, tocolor(0, 0, 0, keyPanel.alpha), true)
        for _, key in pairs(keyPanel.keys) do
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
        local icon = Textures[keyData[1]]
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

    local keyPanelWidth = sW*(rectangleWidth + iconOffsetPosX /sDW)
    local keyPanelHeight = sH*(rectangleHeight /sDH)
    local keyPanel = dxCreateRenderTarget(keyPanelWidth, keyPanelHeight, true)

    createdKeyPanel[keyPanel] = {
        posX    = posX,
        posY    = posY,
        width   = keyPanelWidth,
        height  = keyPanelHeight,
        alpha   = (not isRectangle) and 0 or 175,
        keys    = _keys,
    }

    dxDrawKeyPanel(keyPanel)

    return keyPanel
end

function KeyPanel.destroy(keyPanel)
    if (not createdKeyPanel[keyPanel]) then
        return false
    end
    if isElement(keyPanel) then
        destroyElement(keyPanel)
    end
    createdKeyPanel[keyPanel] = nil
    return true
end

function KeyPanel.render()
    for keyPanel, keyPanelData in pairs(createdKeyPanel) do
        if isClientRestore then
            dxDrawKeyPanel(keyPanel)
        end
        dxDrawImage(keyPanelData.posX, keyPanelData.posY, keyPanelData.width, keyPanelData.height, keyPanel, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
end

addEventHandler("onClientRestore", root, 
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
        Rectangle.destroy(source)
    end
)

-- Exports
createKeyPane = KeyPanel.create


-- function KeyPanel.getSize(panel)
--     if (not createdKeyPanel[panel]) then
--         outputDebugString('KeyPanel.getSize: bad arguments', 1)
--         return false
--     end
-- end