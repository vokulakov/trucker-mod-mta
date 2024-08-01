Rectangle = {}

local createdRectangle = {}

function Rectangle.draw(posX, posY, width, height, color, round)
    if not round then
        dxDrawImage(posX, posY, width, height, Texture['partDot'], 0, 0, 0, color)
    else
        dxDrawImage(posX, posY, 6, 6, Texture['partRound1'], 0, 0, 0, color)
        dxDrawImage(posX, posY+6, 6, height-12, Texture['partDot'], 0, 0, 0, color)
        dxDrawImage(posX, posY+height-6, 6, 6, Texture['partRound4'], 0, 0, 0, color)
        dxDrawImage(posX+6, posY, width-12, height, Texture['partDot'], 0, 0, 0, color)
        dxDrawImage(posX+width-6, posY, 6, 6, Texture['partRound2'], 0, 0, 0, color)
        dxDrawImage(posX+width-6, posY+6, 6, height-12, Texture['partDot'], 0, 0, 0, color)
        dxDrawImage(posX+width-6, posY+height-6, 6, 6, Texture['partRound3'], 0, 0, 0, color)
    end
end

function Rectangle.render()
    for _, rectangle in pairs(createdRectangle) do
        if (rectangle.colorAlpha > 0) then
            local color = tocolor(rectangle.colorR, rectangle.colorG, rectangle.colorB, rectangle.colorAlpha)
            Rectangle.draw(rectangle.x, rectangle.y, rectangle.width, rectangle.height, color, rectangle.round)
        end
    end
end

function Rectangle.create(posX, posY, width, height, colorR, colorG, colorB, colorAlpha, round)
    if (type(posX) ~= 'number' or type(posY) ~= 'number' or type(width) ~= 'number' or type(height) ~= 'number') then
        outputDebugString("Rectangle.create: bad arguments", 1)
        return false
    end

    local rectangle = guiCreateLabel(0, 0, 0, 0, "", true)
    rectangle.alpha = 0
    rectangle.enabled = false

    createdRectangle[rectangle] = {
        x = posX,
        y = posY,
        width = width,
        height = height,
        colorR = (type(colorR) == 'number') and colorR or 0,
        colorG = (type(colorG) == 'number') and colorG or 0,
        colorB = (type(colorB) == 'number') and colorB or 0,
        colorAlpha = (type(colorAlpha) == 'number') and colorAlpha or 175,
        round = round or true,
    }

    return rectangle
end

function Rectangle.destroy(rectangle)
    if (not createdRectangle[rectangle]) then
        return false
    end
    if isElement(rectangle) then
        destroyElement(rectangle)
    end
    createdRectangle[rectangle] = nil
    return true
end

-- Изменить размер прямоугольника
function Rectangle.setSize(rectangle, width, height)
    if (not createdRectangle[rectangle] or type(width) ~= 'number' or type(height) ~= 'number') then
        outputDebugString('Rectangle.setSize: bad arguments', 1)
        return false
    end
    createdRectangle[rectangle].width = width
    createdRectangle[rectangle].height = height
    return true
end

-- Получить размер прямоугольника
function Rectangle.getSize(rectangle)
    if not createdRectangle[rectangle] then
        outputDebugString('Rectangle.getSize: bad arguments', 1)
        return false
    end
    return createdRectangle[rectangle].width, drawnRectangles[rectangle].height
end

-- Получить позицию прямоугольника
function Rectangle.getPosition(rectangle)
    if not createdRectangle[rectangle] then
        outputDebugString('Rectangle.getPosition: bad arguments', 1)
        return false
    end
    return createdRectangle[rectangle].x, createdRectangle[rectangle].y
end

-- Установить позицию прямоугольника
function Rectangle.setPosition(rectangle, posX, posY)
    if (not createdRectangle[rectangle] or type(posX) ~= 'number' or type(posY) ~= 'number') then
        outputDebugString('Rectangle.setPosition: bad arguments', 1)
        return false
    end
    createdRectangle[rectangle].x = posX
    createdRectangle[rectangle].y = posY
    return true
end

addEventHandler('onClientElementDestroy', root, 
    function()
        if (source.type ~= 'gui-label') then
            return
        end
        Rectangle.destroy(source)
    end
)

-- exports
guiRectangleCreate = Rectangle.create
guiRectangleGetSize = Rectangle.getSize
guiRectangleSetSize = Rectangle.setSize
guiRectangleGetPosition = Rectangle.getPosition
guiRectangleSetPositon = Rectangle.setPosition