VehicleControlGUI = {}
VehicleControlGUI.visible = false

-- Params
VehicleControlGUI.params = {}
VehicleControlGUI.params['windowTitle'] = "Управление транспортом [F2]"
VehicleControlGUI.params['bindKey'] = 'f2'

local width, height
local posX, posY

function VehicleControlGUI.setVisible()
    VehicleControlGUI.visible = Dashboard.setWindowVisible(VehicleControlGUI.wnd)
    showChat(not VehicleControlGUI.visible)
    exports.tmtaUI:setPlayerComponentVisible("controlHelp", not VehicleControlGUI.visible)
    exports.tmtaUI:setPlayerComponentVisible("chat", not VehicleControlGUI.visible)
end

bindKey(VehicleControlGUI.params['bindKey'], 'down',
    function()
        if not Dashboard.getVisible() then
            return
        end
        VehicleControlGUI.setVisible()
    end
)