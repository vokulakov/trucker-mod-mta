Rectangle = {}

local createdRectangle = {}

function Rectangle.draw()
end

-- Создать прямоугольник
-- @tparam number posX
-- @tparam number posY
-- @tparam number width
-- @tparam number height
-- @tparam number alpha
function Rectangle.create(posX, posY, width, height, alpha, round)
    if (type(posX) ~= 'number' or type(posY) ~= 'number' or type(width) ~= 'number' or type(height) ~= 'number') then
        outputDebugString("Rectangle.create(: bad arguments", 1)
        return false
    end

    local fakeRectangle = guiCreateLabel(0, 0, 0, 0, "", true)
    fakeRectangle.alpha = 0
    fakeRectangle.enabled = false

    createdRectangle[fakeRectangle] = {
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
-- @tparam element rectangle
function Rectangle.getSize(rectangle)
    if not createdRectangle[rectangle] then
        outputDebugString('Rectangle.getSize: bad arguments', 1)
        return false
    end
    return createdRectangle[rectangle].width, drawnRectangles[rectangle].height
end

-- Получить позицию прямоугольника
-- @tparam element rectangle
function Rectangle.getPosition(rectangle)
    if not createdRectangle[rectangle] then
        outputDebugString('Rectangle.getPosition: bad arguments', 1)
        return false
    end
    return createdRectangle[rectangle].x, createdRectangle[rectangle].y
end

-- Установить позицию прямоугольника
-- @tparam element rectangle
function Rectangle.setPosition(rectangle, posX, posY)
    if (not createdRectangle[rectangle] or type(posX) ~= 'number' or type(posY) ~= 'number') then
        outputDebugString('Rectangle.setPosition: bad arguments', 1)
        return false
    end
    createdRectangle[rectangle].x = posX
    createdRectangle[rectangle].y = posY
    return true
end