Dashboard = {}
Dashboard.windows = {}
Dashboard.visible = false
Dashboard.activeWindow = false

sW, sH = guiGetScreenSize()
sDW, sDH = exports.tmtaUI:getScreenSize()

Font = {
    ['RR_8'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 8),
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
}

-- Добавить окно в стек окон dashboard
function Dashboard.addWindow(window, setVisibleFunction, getVisibleFunction)
    if (not isElement(window) or type(setVisibleFunction) ~= 'function' or type(getVisibleFunction) ~= 'function') then
        outputDebugString('Dashboard.addWindow: bad arguments', 1)
        return false
    end

    Dashboard.windows[window] = {
        setVisible = setVisibleFunction,
        getVisible = getVisibleFunction,
    }
end

-- Установить видимость окна
function Dashboard.setWindowVisible(window, state)
    if not isElement(window) then
        return false
    end
    
    state = (type(state) == 'boolean') and state or not window.visible

    -- Скрыть все окна
    for currentWindow in pairs(Dashboard.windows) do
        if (window ~= currentWindow and currentWindow.visible) then
            Dashboard.windows[currentWindow].setVisible()
        end
    end

    window.visible = state
    showCursor(window.visible)

    triggerEvent('tmtaDashboard.onChangeVisible', localPlayer, state)

    Dashboard.activeWindow = window
    return window.visible
end

function Dashboard.setVisible(state)
    local state = (type(state) == 'boolean') and state or not Dashboard.getVisible()
    if not state then
        if Dashboard.activeWindow and not Dashboard.activeWindow.visible then
            Dashboard.activeWindow = nil
        end
        for window in pairs(Dashboard.windows) do
            if window.visible then
                Dashboard.windows[window].setVisible()
            end
        end
    end
    Dashboard.visible = state
end

function Dashboard.getVisible()
    return Dashboard.visible
end

addEventHandler("tmtaUI.onSetPlayerComponentVisible", root,
    function(changedComponent, componentVisible)
        if changedComponent ~= 'dashboard' then
            return
        end
        Dashboard.setVisible(componentVisible)
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        Dashboard.visible = true
    end
)

-- Events
addEvent("tmtaDashboard.onChangeVisible", true)