--TODO: переписать на RenderTarget
--TODO: добавить в отрисовку KeyPane.create allign, чтобы можно было нормально делать отступы по краям экрана

-- Создать подсказки клавиш
-- @tparam table keys
function KeyPane.create(posX, posY, keys, isRectangle, centralize)
    if type(posX) ~= 'number' or type(posY) ~= 'number' or type(keys) ~= 'table' then
        outputDebugString("KeyPane.create: bad arguments", 1)
        return false
    end
   
    local isRectangle = (type(isRectangle) ~= 'boolean') and true or isRectangle
    local rectangleWidth = 0
    local rectangleHeight = 0

    local iconOffsetPosX = sW*((iconOffsetPosX) /sDW)

    local keyPaneData = {}
    for keyIndex, keyData in pairs(keys) do
        local keyIcon = Textures[keyData[1]]
        local keyText = keyData[2]
        if isElement(keyIcon) and type(keyText) == 'string' then 
            local iconW, iconH = dxGetMaterialSize(keyIcon)
            local keyTextWidth = dxGetTextWidth(keyText, sW/sDW*1.0, Fonts['RR_10'])
            local keyTextWidth, keyTextHeight = dxGetTextSize(keyText, keyTextWidth, sW/sDW*1.0, Fonts['RR_10'], false)
            
            local width = iconOffsetPosX + iconW + iconOffsetPosX + keyTextWidth + iconOffsetPosX
            local height = (keyTextHeight < iconH) and iconH or keyTextHeight
            height = (isRectangle) and height + 10 or height
            height = sH*((height) /sDH)

            table.insert(keyPaneData, {
                x = posX+rectangleWidth,
                y = posY,
                width = width,
                height = height,
                icon = { texture = keyIcon, width = sW*((iconW) /sDW), height = sH*((iconH) /sDH) },
                text = keyText,
            })

            rectangleWidth = rectangleWidth + width
            rectangleHeight = height
        end
    end

    local rectangleAlpha = (not isRectangle) and 0 or nil
    local rectangle = KeyPane.createRectangle(posX, posY, rectangleWidth + iconOffsetPosX, rectangleHeight, rectangleAlpha)

    drawKeyPanes[rectangle] = keyPaneData

    return rectangle
end

--[[
local keys = {
    {"keyMouseRight", "Режим просмотра"},
    {"keyMouse", "Вращать камеру"},
    {"keyMouseWheel", "Отдалить/приблизить камеру"},
}

local pane = KeyPane.create(sW*((sW/2) /sDW), sH*((sH/2) /sDH), keys, true, true)
KeyPane.create(sW*((sW/2) /sDW), sH*((500) /sDH), {{"keyMouse", "Вращать камеру"}}, true, true)
--KeyPane.create(sW*((sW/2) /sDW), sH*((600) /sDH), {{"keyMouseRight", "Режим просмотра"}}, false, true)
--setTimer(destroyElement, 5000, 1, pane)

UI.setPlayerComponentVisible("all", true)
]]