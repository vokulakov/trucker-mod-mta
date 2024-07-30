MapLegend = {}
MapLegend.isVisible = false

local MAX_LEGEND_COUNT = 10

local LEGEND_TABLE = {
    { name = 'Вы', icon = 'localPlayer', iconColor = tocolor(255, 255, 255) },
}

function MapLegend.add()
end

function MapLegend.remove()
end

-- Перерисовка легенд
function MapLegend.render()
end

function MapLegend.setVisible()
    if (not Map.visible) then
        return
    end

end

MapLegend.setVisible()