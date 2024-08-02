UI = {}
UI.visibleComponents = {}

--- Компоненты интерфейса
UI.components = {
    ['all'] = true,
    ['hud'] = true, -- весь hud (радар, спидометр, статистика игрока)
    ['dashboard'] = true, -- панели (F1-F10)

    ['text3d'] = true,

    ['chat'] = true, -- чат
    ['notifications'] = true, -- уведомления

    ['controlHelp'] = true, -- помощь в управлении
    ['keyPane'] = true, -- панель клавиш

    ['radar'] = true, -- радар
    ['map'] = true, -- карта

    ['speedometer'] = true, -- спидометр
    ['racelogic'] = true, -- racelogic (замер разгона до 100 км/ч)

    ['driftpoints'] = true, -- дрифт-очки
    ['scoreboard'] = true, -- таблица игроков
    ['nametags'] = true, -- неймтеги (статистика над игроком)

    ['areaName'] = true, -- названия городов
    ['vehicleName'] = true, -- названия транспорта

    ['radio'] = true, -- радиостанции

    ['killmessages'] = true,
}

--- Компоненты худа
UI.hudComponents = {
    'radar', 'speedometer', 'racelogic', 'radio', 'chat',
    'killmessages', 'notifications', 'control_help', 'nametags',
    'area_name', 'vehicle_name', 'driftpoints', 'text3d',
}

--- Валидация компонента
--@tparam string component название компонента
--@treturn bool
local function componentValid(component)
    if type(component) ~= 'string' then
        return false
    end
    if UI.components[tostring(component)] then
        return true
    end
    return false
end

--- Проверка видимости компонента UI
--@tparam string component название компонента
--@treturn bool
function UI.isPlayerComponentVisible(component)
    if not componentValid(component) then
        outputDebugString("ERROR: UI.isPlayerComponentVisible: bad arguments", 1)
        return false
    end
    return UI.visibleComponents[component]
end

--- Установка видимости компонента UI
--@tparam string component название компонента
--@tparam bool show видимость компонента
--@treturn bool
function UI.setPlayerComponentVisible(component, show, excludedComponents)
    if not componentValid(component) or type(show) ~= 'boolean' then
        outputDebugString("ERROR: UI.setPlayerComponentVisible: bad arguments", 1)
        return false
    end
    
    if type(excludedComponents) ~= 'table' then
        excludedComponents = {}
    else
        local tmpExcludedComponents = {}
        for _, currentComponent in pairs(excludedComponents) do
            tmpExcludedComponents[currentComponent] = true
        end
        excludedComponents = tmpExcludedComponents
    end

    if component == "all" then
        for currentComponent in pairs(UI.components) do
            if not excludedComponents[currentComponent] then
                UI.visibleComponents[currentComponent] = show
                triggerEvent("tmtaUI.onSetPlayerComponentVisible", localPlayer, currentComponent, show)
            end
        end
    end

    if component == "hud" then
        for _, currentComponent in pairs(UI.hudComponents) do
            if not excludedComponents[currentComponent] then
                UI.visibleComponents[currentComponent] = show
                triggerEvent("tmtaUI.onSetPlayerComponentVisible", localPlayer, currentComponent, show)
            end
        end
    end

    UI.visibleComponents[component] = show
    triggerEvent("tmtaUI.onSetPlayerComponentVisible", localPlayer, component, show)
    
    return true
end

--TODO:: принудительное скрытие карты и чата, чтобы через showchat не работало
--TODO:: не открывать другие окна, если на экране уже есть активное окно
--TODO:: реализовать activeUi, чтобы исключить открытие sb или map одновременно

addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        setPlayerHudComponentVisible("all", false)
        setPlayerHudComponentVisible("crosshair", true)
        UI.setPlayerComponentVisible("all", false) -- выключаем весь интерфейс при старте

        UI.setPlayerComponentVisible("all", true)
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        setPlayerHudComponentVisible("all", true)
    end
)

addCommandHandler("showhud", 
    function()
        UI.setPlayerComponentVisible("hud", not UI.isPlayerComponentVisible("hud"))
    end
)

-- Events
addEvent("tmtaUI.onSetPlayerComponentVisible", true)

-- Exports
isPlayerComponentVisible = UI.isPlayerComponentVisible
setPlayerComponentVisible = UI.setPlayerComponentVisible