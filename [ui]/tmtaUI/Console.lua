local consoleVisible = isConsoleActive()

addEventHandler('onClientRender', root,
    function()
        local _currentConsoleState = isConsoleActive()
        if (consoleVisible ~= _currentConsoleState) then
            consoleVisible = _currentConsoleState
            triggerEvent('tmtaUI.onClientChangeConsoleActive', root, consoleVisible)
        end
    end
)

addEvent('tmtaUI.onClientChangeConsoleActive', false)