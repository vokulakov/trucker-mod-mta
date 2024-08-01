KeyPane = {}

local drawnRectangles = {}
local drawKeyPanes = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()
local iconOffsetPosX = 5 -- отступы от иконки

local Textures = {}
local Fonts = {}

--TODO: переписать на RenderTarget
--TODO: добавить в отрисовку KeyPane.create allign, чтобы можно было нормально делать отступы по краям экрана

-- Нарисовать прямоугольник
function KeyPane.drawRectangle(posX, posY, width, height, alpha, round)
    if round then
        dxDrawImage(posX, posY, 6, 6, Textures['partRound1'], 0, 0, 0, tocolor(0, 0, 0, alpha))
        dxDrawImage(posX, posY+6, 6, height-12, Textures['partDot'], 0, 0, 0, tocolor(0, 0, 0, alpha))
        dxDrawImage(posX, posY+height-6, 6, 6, Textures['partRound4'], 0, 0, 0, tocolor(0, 0, 0, alpha))
        dxDrawImage(posX+6, posY, width-12, height, Textures['partDot'], 0, 0, 0, tocolor(0, 0, 0, alpha))
        dxDrawImage(posX+width-6, posY, 6, 6, Textures['partRound2'], 0, 0, 0, tocolor(0, 0, 0, alpha))
        dxDrawImage(posX+width-6, posY+6, 6, height-12, Textures['partDot'], 0, 0, 0, tocolor(0, 0, 0, alpha))
        dxDrawImage(posX+width-6, posY+height-6, 6, 6, Textures['partRound3'], 0, 0, 0, tocolor(0, 0, 0, alpha))
    end
end

-- Нарисовать подсказки клавиш
-- @tparam table icon
function KeyPane.draw(posX, posY, width, height, icon, text)
    dxDrawImage(posX+iconOffsetPosX, posY+(height-icon.height) /2, icon.width, icon.height, icon.texture)
    dxDrawText(text, posX+iconOffsetPosX+icon.width, posY, posX+width, posY+height, tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts['RR_10'], "center", "center")
end

addEventHandler('onClientRender', root, 
    function()
        dxSetBlendMode("modulate_add")
      
            for _, rectangle in pairs(drawnRectangles) do
                --dxDrawRectangle(rectangle.x, rectangle.y, 1, rectangle.height, tocolor(0, 255, 255, 255))
                KeyPane.drawRectangle(rectangle.x, rectangle.y, rectangle.width, rectangle.height, rectangle.alpha, rectangle.round)
                --dxDrawRectangle(rectangle.x+rectangle.width, rectangle.y, 1, rectangle.height, tocolor(0, 255, 255, 255))
            end
            
            for keyPane in pairs(drawKeyPanes) do
                for _, keyData in pairs(drawKeyPanes[keyPane]) do
                    KeyPane.draw(keyData.x, keyData.y, keyData.width, keyData.height, keyData.icon, keyData.text)
                    --dxDrawRectangle(keyData.x, keyData.y+keyData.height/2, keyData.width, 1, tocolor(0, 255, 255, 255))
                end
            end

        dxSetBlendMode("blend")
    end, true, 'low-4'
)

-- Создать прямоугольник
-- @tparam number posX
-- @tparam number posY
-- @tparam number width
-- @tparam number height
-- @tparam number alpha
function KeyPane.createRectangle(posX, posY, width, height, alpha, round)
    if type(posX) ~= 'number' or type(posY) ~= 'number' or type(width) ~= 'number' or type(height) ~= 'number' then
        outputDebugString("KeyPane.createRectangle: bad arguments", 1)
        return false
    end

    local fakeRectangle = guiCreateLabel(0, 0, 0, 0, "", true)
    fakeRectangle.alpha = 0
    fakeRectangle.enabled = false

    drawnRectangles[fakeRectangle] = {
        x = posX,
        y = posY,
        width = width,
        height = height,
        alpha = alpha or 175,
        round = round or true,
    }

    return fakeRectangle
end

-- Изменить размер прямоугольника
-- @tparam element rectangle
function KeyPane.setRectangleSize(rectangle, width, height)
    if (not drawnRectangles[rectangle] or type(width) ~= 'number' or type(height) ~= 'number') then
        outputDebugString('KeyPane.setRectangleSize: bad arguments', 1)
        return false
    end
    drawnRectangles[rectangle].width = width
    drawnRectangles[rectangle].height = height
    return true
end

-- Получить размер прямоугольника
-- @tparam element rectangle
function KeyPane.getRectangleSize(rectangle)
    if not drawnRectangles[rectangle] then
        outputDebugString('KeyPane.getRectangleSize: bad arguments', 1)
        return false
    end
    return drawnRectangles[rectangle].width, drawnRectangles[rectangle].height
end

-- Получить позицию прямоугольника
-- @tparam element rectangle
function KeyPane.getRectanglePosition(rectangle)
    if not drawnRectangles[rectangle] then
        outputDebugString('KeyPane.getRectanglePosition: bad arguments', 1)
        return false
    end
    return drawnRectangles[rectangle].x, drawnRectangles[rectangle].y
end

-- Установить позицию прямоугольника
-- @tparam element rectangle
function KeyPane.setRectanglePosition(rectangle, posX, posY)
    if (not drawnRectangles[rectangle] or type(posX) ~= 'number' or type(posY) ~= 'number') then
        outputDebugString('KeyPane.setRectanglePosition: bad arguments', 1)
        return false
    end
    drawnRectangles[rectangle].x = posX
    drawnRectangles[rectangle].y = posY
    return true
end

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

function KeyPane.setPosition(pane, posX, posY)
    if type(posX) ~= 'number' or type(posY) ~= 'number' or not drawKeyPanes[pane] then
        outputDebugString("KeyPane.create: bad arguments", 1)
        return false
    end

    return true
end


addEventHandler("onClientElementDestroy", root, 
    function()
        if source.type ~= 'gui-label' then
            return
        end
	
		if drawnRectangles[source] then
			drawnRectangles[source] = nil
        end
        
        if drawKeyPanes[source] then
            drawKeyPanes[source] = nil
		end
    end
)

--KeyPane.createRectangle(sW*(((sW-200)/2) /sDW), sH*((800) /sDH), sW*((200) /sDW), sH*((30) /sDH))
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

-- Exports
createKeyPane = KeyPane.create
createRectangle = KeyPane.createRectangle