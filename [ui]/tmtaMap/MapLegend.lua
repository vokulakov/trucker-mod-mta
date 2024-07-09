MapLegend = {}
MapLegend.isVisible = false

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local RECTANGLE_HEIGHT = 26
local posOffsetX, posOffsetY = 10, 10
local offsetY = 30

local FONT = exports.tmtaFonts:createFontGUI('RobotoRegular', 11)

local LEGEND_PROPERTY = {
    { name = 'Вы', icon = 'localPlayer', iconColor = tocolor(255, 255, 255) },
    { name = 'База дальнобойщиков', icon = 'blipTrucker', iconColor = tocolor(255, 255, 255) },
    { name = 'Дом', icon = 'blipProperty', iconColor = tocolor(255, 255, 255) },
    { name = 'Бизнес', icon = 'blipBusiness', iconColor = tocolor(255, 255, 255) },
    { name = 'АЗС', icon = 'blipGasStation', iconColor = tocolor(255, 255, 255) },
    { name = 'Магазин одежды', icon = 'blipClothes', iconColor = tocolor(255, 255, 255) },
    { name = 'Автосалон', icon = 'blipCarshop', iconColor = tocolor(255, 255, 255) },
    { name = 'Тюнинг ателье', icon = 'blipTuning', iconColor = tocolor(255, 255, 255) },
    { name = 'Кафе (ресторан)', icon = 'blipRestaurant', iconColor = tocolor(255, 255, 255) },
    { name = 'Налоговая', icon = 'blipRevenueService', iconColor = tocolor(255, 255, 255) },
    { name = 'СТО', icon = 'blipSto', iconColor = tocolor(255, 255, 255) },
    { name = 'Аренда скутеров', icon = 'blipScooterRent', iconColor = tocolor(255, 255, 255) },
    { name = 'Покрасочная', icon = 'blipPaint', iconColor = tocolor(255, 255, 255) },
    { name = 'Установка номеров (ЕКХ)', icon = 'blipLicensePlate', iconColor = tocolor(255, 255, 255) },
    { name = 'Работа грузчика', icon = 'blipJobLoader', iconColor = tocolor(255, 255, 255) },
    { name = 'Метка', icon = 'blipCheckpoint', iconColor = tocolor(255, 255, 255) },
    { name = 'Больница', icon = 'blipHospital', iconColor = tocolor(255, 255, 255) },
}

local function isLegendValid(legendIcon)
    if (not legendIcon or type(legendIcon) ~= 'string') then
        outputDebugString('isLegendValid: bad arguments', 1)
        return false
    end
    for _, legend in pairs(LEGEND_PROPERTY) do
        if legend.icon == legendIcon then
            return true
        end
    end
    return false
end

local function getLegendProperty(legendIcon)
    if (not legendIcon or type(legendIcon) ~= 'string') then
        outputDebugString('getLegendProperty: bad arguments', 1)
        return false
    end
    for _, legend in pairs(LEGEND_PROPERTY) do
        if legend.icon == legendIcon then
            return legend
        end
    end
    return false
end

local _legendCreated = {}
local _currentLegendCount = 0

local function guiCreateMapLegend(name, icon, color)
    if (type(name) ~= 'string' or type(icon) ~= 'string') then
        outputDebugString('MapLegend.create: bad arguments', 1)
        return false
    end

    if (not color) then
		color = tocolor(255, 255, 255)
	end

    local _label = guiCreateLabel(0, 0, 0, 0, name, false)
    guiSetFont(_label, FONT)
    local textWidth, textHeight = guiLabelGetTextExtent(_label), guiLabelGetFontHeight(_label)
    destroyElement(_label)

    local posX = sW-textWidth-posOffsetX-10
    local posY = posOffsetY+_currentLegendCount*offsetY
    local width = textWidth+10
    local height = RECTANGLE_HEIGHT

    -- Icon
    local iconSize = RECTANGLE_HEIGHT/1.2
    posX = posX+width-iconSize-10

    local icon = exports.tmtaTextures:createStaticImage(
        sW*((posX) /sDW), 
        sH*((posY+(height-iconSize)/2) /sDH), 
        sW*((iconSize) /sDW), 
        sH*((iconSize) /sDH), 
        icon, 
        false
    )

    local hexColor = exports.tmtaUtils:colorToHEX(color)
    hexColor = hexColor:gsub("#", "")
    
    guiSetProperty(icon, 'ImageColours', 'tl:FF'..hexColor..' tr:FF'..hexColor..' bl:FF'..hexColor..' br:FF'..hexColor)
    icon.enabled = false
    
    -- Name
    posX = posX-5
    local text = guiCreateLabel(sW*((0) /sDW), sH*(posY /sDH), sW*((posX) /sDW), sH*(height /sDH), name, false)
    text.enabled = false
    guiLabelSetHorizontalAlign(text, 'right')
    guiLabelSetVerticalAlign(text, 'center')
    guiSetFont(text, FONT)
    
    -- Rectangle
    posX = posX-textWidth-10
    width = width+iconSize+10

    local rectangle = exports.tmtaUI:guiRectangleCreate(sW*((posX) /sDW), sH*(posY /sDH), sW*((width) /sDW), sH*(height /sDH))
    setElementParent(icon, rectangle)
    setElementParent(text, rectangle)

    return rectangle
end

function MapLegend.render()
    if MapLegend.isVisible then
        return false
    end
    
    local _legends = {}
    _legends.localPlayer = getLegendProperty('localPlayer')

    local playerPosition = Vector3(localPlayer.position)
    for _, blip in ipairs(getElementsByType('blip')) do
        local icon = blip:getData('icon')
        if (icon and not _legends[icon] and Map.textures[icon]) then
            local legendProperty = getLegendProperty(icon)
            if (legendProperty) then
                local legendName = legendProperty.name
                local color = blip:getData('color') or tocolor(255, 255, 255, 255)
                local data = blip:getData('data') or {}
    
                local bpX, bpY, bpZ = getElementPosition(blip)
                local permissibleDistance = (getDistanceBetweenPoints2D(bpX, bpY, playerPosition.x, playerPosition.y) <= Map.MAX_DISTANCE_BLIP_VISIBLE)
    
                -- Отображение дома/бизнеса
                --TODO: сделать отображение по приоритетам (Ваш дом/бизнес, Дом/бизнес)
                local legendVisible = true
                if (not permissibleDistance and (data.isHouseBlip or data.isBusinessBlip)) then
                    if (not data.isOwnerLocalPlayer) then
                        legendVisible = false
                    end
                end
               
                if legendVisible then
                    _legends[icon] = {
                        name = legendName,
                        icon = legendProperty.icon,
                        color = color,
                    }
                end
            end
        end
    end

    _legendCreated = {}
    _currentLegendCount = 0

    for _, legend in pairs(LEGEND_PROPERTY) do
        if (_legends[legend.icon]) then
            local _legend = guiCreateMapLegend(_legends[legend.icon].name, _legends[legend.icon].icon, _legends[legend.icon].color)
            if (_legend) then
                table.insert(_legendCreated, _legend)
                _currentLegendCount = _currentLegendCount + 1
            end
        end
    end

    MapLegend.isVisible = true

    return true
end

function MapLegend.destroy()
    if not MapLegend.isVisible then
        return false
    end

    for _, legend in pairs(_legendCreated) do
        destroyElement(legend)
    end

    MapLegend.isVisible = false

    return true
end

function MapLegend.setVisible()
    if (not Map.visible) then
        return false
    end

    if (not MapLegend.isVisible) then
        MapLegend.render()
    else
        MapLegend.destroy()
    end

    return true
end