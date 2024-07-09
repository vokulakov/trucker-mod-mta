Garage = {}

local isPlayerOnTuning = false 

function Garage.playerEnter()
    if isPlayerOnTuning then 
        return
    end 

    if not localPlayer.vehicle then
        Garage.playerExit()
        return
    end

    -- нужно переносить отдельно, чтобы объекту задавалось уже нужное
    GarageObject.dimension = localPlayer.dimension
    GarageObject.interior  = localPlayer.interior
    
    setTime(12, 0)
    setMinuteDuration(2147483647)
    
    setTimer(
        function()
            showCursor(true)
            CameraManager.start()
            showPaintUI(true)
            setupColorPreview()
            fadeCamera(true, 1)
        end, 1000, 1)
    
    addEventHandler("onClientElementDestroy", localPlayer.vehicle, function()
        if not isPlayerOnTuning then 
            return
        end
        triggerServerEvent("tmtaVehPaint.onPlayerExitGarage", localPlayer)
    end)
    
    isPlayerOnTuning = true

    setTimer(function ()
        if localPlayer.vehicle and isPlayerOnTuning then
            localPlayer.vehicle.frozen = true
        end
    end, 3000, 1)

end
addEvent("tmtaVehPaint.onPlayerEnterGarage", true)
addEventHandler("tmtaVehPaint.onPlayerEnterGarage", root,  Garage.playerEnter)

function Garage.playerExit()
    if not isPlayerOnTuning then 
        return
    end 

    if localPlayer.vehicle then
        removeEventHandler("onClientElementDestroy", localPlayer.vehicle, function()
            if not isPlayerOnTuning then 
                return
            end
            triggerServerEvent("tmtaVehPaint.onPlayerExitGarage", localPlayer)
        end)
    end
    
    -- Телепортировать игрока к выходу
    if PlayerCurrentGarageMarker then
        local garageMarkerData = PlayerCurrentGarageMarker:getData('garageMarkerData')

        local targetPosition = garageMarkerData.position
        local targetRotation = Vector3(0, 0, garageMarkerData.angle)
        if localPlayer.vehicle then
            if localPlayer.vehicle.vehicleType == "Bike" then
                localPlayer.vehicle.frozen = true
                setTimer(function ()
                    localPlayer.vehicle.position = targetPosition + Vector3(0, 0, 1)
                    setElementRotation(localPlayer.vehicle, targetRotation)
                    setCameraTarget(localPlayer)
                end, 50, 1)

                setTimer(function ()
                    localPlayer.vehicle.velocity = Vector3()
                    localPlayer.vehicle.frozen = false
                    exports.tmtaTimecycle:syncPlayerGameTime()
                end, 500, 1)
            else
                localPlayer.vehicle.position = targetPosition + Vector3(0, 0, 1)
                setElementRotation(localPlayer.vehicle, targetRotation)
                setTimer(function ()
                    exports.tmtaTimecycle:syncPlayerGameTime()
                    setCameraTarget(localPlayer)
                    localPlayer.vehicle.frozen = false
                    localPlayer.vehicle.velocity = Vector3()
                end, 50, 1)
            end
        else
            localPlayer.position = targetPosition
            localPlayer.rotaion = targetRotation
        end
    end
    PlayerCurrentGarageMarker = nil

    CameraManager.stop()
    exports.tmtaUI:setPlayerComponentVisible("all", true)
	showChat(true)
    showCursor(false)

    isPlayerOnTuning = false
    toggleAllControls(true, true, true)
    fadeCamera(true, 1)
end
addEvent("tmtaVehPaint.onPlayerExitGarage", true)
addEventHandler("tmtaVehPaint.onPlayerExitGarage", root, Garage.playerExit)