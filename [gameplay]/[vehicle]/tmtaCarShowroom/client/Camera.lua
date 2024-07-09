loadstring(exports['tmtaModule']:include('CameraManager'))()

CameraManager.setStartingCameraPresets(Vector3(0.02, 0.05, 0), 230, 6, 8, 65, 0)

function CameraManager.onStartMouseLook()
    ShowroomGUI.hide()
end

function CameraManager.onStopMouseLook()
    ShowroomGUI.show()
end