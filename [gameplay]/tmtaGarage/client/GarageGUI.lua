GarageGUI = {}
GarageGUI.visible = true

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

GarageGUI.params = {}
GarageGUI.params['windowTitle'] = "Личный транспорт [F3]"
GarageGUI.params['bindKey'] = 'f3'

GarageGUI.params['windowTitle'], height = 500, 450

GarageGUI.wnd = guiCreateWindow(0, 0, sW*((width) /sDW), sH*((height) /sDH), '', false)
exports.tmtaGUI:windowCentralize(GarageGUI.wnd)
guiWindowSetSizable(GarageGUI.wnd, false)
guiWindowSetMovable(GarageGUI.wnd, false)
GarageGUI.wnd.alpha = 0.8
GarageGUI.wnd.visible = false