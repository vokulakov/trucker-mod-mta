KeyPanel = {}

local isClientRestore = false
local iconOffsetPosX = 5 -- отступы от иконки

local createdKeyPanel = {}

local function dxCreateKeyPanel(keys, rectangleWidth, rectangleHeight, rectangleAlpha)
    local renderTarget = dxCreateRenderTarget(sW*(rectangleWidth /sDW), sH*(rectangleHeight /sDH), true)
    
    dxSetRenderTarget(renderTarget, true)
        dxSetBlendMode('modulate_add')
        Rectangle.draw(0, 0, rectangleWidth, rectangleHeight, tocolor(0, 0, 0, rectangleAlpha), true)
        dxSetBlendMode('blend')
    dxSetRenderTarget()

    return renderTarget
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

    local keyPanel = dxCreateKeyPanel(_keys, rectangleWidth + iconOffsetPosX, rectangleHeight, (not isRectangle) and 0 or 175)

    createdKeyPanel[keyPanel] = {
        posX = posX,
        posY = posY,
        keys = _keys,
    }

    return keyPanel
end

function KeyPanel.render()
    for keyPanel in pairs(createdKeyPanel) do
    --         for _, keyData in pairs(createdKeyPanel[keyPanel]) do
    --             drawKey(keyData.x, keyData.y, keyData.width, keyData.height, keyData.icon, keyData.text)
    --         end
    end
end

addEventHandler("onClientRestore", root, 
    function()
        isClientRestore = true
        setTimer(function() isClientRestore = false end, 500, 1)
    end
)

-- local function drawKey(posX, posY, width, height, icon, text)
--     dxDrawImage(posX+iconOffsetPosX, posY+(height-icon.height) /2, icon.width, icon.height, icon.img)
--     dxDrawText(text, posX+iconOffsetPosX+icon.width, posY, posX+width, posY+height, tocolor(255, 255, 255, 255), sW/sDW*1.0, Font['RR_10'], 'center', 'center')
-- end

-- function KeyPanel.render()
--     for keyPanel in pairs(createdKeyPanel) do
--         for _, keyData in pairs(createdKeyPanel[keyPanel]) do
--             drawKey(keyData.x, keyData.y, keyData.width, keyData.height, keyData.icon, keyData.text)
--         end
--     end
-- end

-- function KeyPanel.destroy(panel)
--     if (not createdKeyPanel[panel]) then
--         return false
--     end
--     if isElement(panel) then
--         destroyElement(panel)
--     end
--     createdKeyPanel[panel] = nil
--     return true
-- end

-- function KeyPanel.getSize(panel)
--     if (not createdKeyPanel[panel]) then
--         outputDebugString('KeyPanel.getSize: bad arguments', 1)
--         return false
--     end
-- end