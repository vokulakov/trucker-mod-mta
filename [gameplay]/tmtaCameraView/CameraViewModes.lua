local vehicleCameraMode = { 1, 4, 2, 3 }
local pedCameraMode = { 1, 2, 3 }

local curVehicleCameraMode = 1
local curPedCameraMode = 1

--https://wiki.multitheftauto.com/wiki/SetCameraViewMode

local function changeVehicleCameraMode(mode)
	local isCircle = false
	if not mode then
		mode = 1
		isCircle = true
		playSoundFrontEnd(32)
	end
	curVehicleCameraMode = curVehicleCameraMode + mode
	if curVehicleCameraMode > #vehicleCameraMode then 
		curVehicleCameraMode =isCircle and 1 or #vehicleCameraMode 
	end
	if curVehicleCameraMode < 1 then 
		curVehicleCameraMode = 1 
	end
	setCameraViewMode(vehicleCameraMode[curVehicleCameraMode])
end

local function changePedCameraMode(mode, isCircle)
	local isCircle = false
	if not mode then
		mode = 1
		isCircle = true
		playSoundFrontEnd(32)
	end
	curPedCameraMode = curPedCameraMode + mode
	if curPedCameraMode > #pedCameraMode then 
		curPedCameraMode = isCircle and 1 or #pedCameraMode
	end
	if curPedCameraMode < 1 then 
		curPedCameraMode = 1 
	end
	setCameraViewMode(_, pedCameraMode[curPedCameraMode])
end

addEventHandler("onClientKey", root, 
	function(key, state)
		if isCursorShowing() then
			return
		end

		if key == 'v' and state then
			if not localPlayer.vehicle then
				changePedCameraMode()
			else
				changeVehicleCameraMode()
			end
		end

		if key == 'mouse_wheel_down' then
			if not localPlayer.vehicle then
				return
			end
			changeVehicleCameraMode(1)
		elseif key == 'mouse_wheel_up' then
			if not localPlayer.vehicle then
				return
			end
			changeVehicleCameraMode(-1)
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		setTimer(toggleControl, 1000, 0, "change_camera", false)
	end
)

addEventHandler("onClientResourceStop", resourceRoot, 
	function()
		toggleControl("change_camera", true)
	end
)