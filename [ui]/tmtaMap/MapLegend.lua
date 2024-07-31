MapLegend = {}
MapLegend.isVisible = false

local MAX_LEGEND_COUNT = 10
local FONT = exports.tmtaFonts:createFontGUI('RobotoRegular', 10)

local LEGEND_TABLE = {
    { name = 'Вы', icon = 'localPlayer', iconColor = tocolor(255, 255, 255) },
}

function MapLegend.create(name, icon, color)
    if (type(name) ~= 'string' or type(icon) ~= 'string') then
        outputDebugString('MapLegend.create: bad arguments', 1)
        return false
    end

    if (not color) then
		color = tocolor(255, 255, 255)
	end

    local tmpLbl = guiCreateLabel(0, 0, 0, 0, name, false)
    guiSetFont(tmpLbl, FONT)
    local textWidth, textHeight = guiLabelGetTextExtent(tmpLbl), guiLabelGetFontHeight(tmpLbl)
    destroyElement(tmpLbl)

    return legend
end


function MapLegend.render()
end

function MapLegend.setVisible()
    if (not Map.visible) then
        return
    end

end

-- function MapLegend.add()
-- end

-- function MapLegend.remove()
-- end


--[[
    * если у игрока есть дом, то выводить легенду с его домом (сверху)
    * если у игрока есть бизнес, то выводить легенду с его бизнесом (сверху)
--]]