Garage = {}

local _isPlayerOnTuning = false 

function Garage.playerEnter()
    if _isPlayerOnTuning then 
        return
    end 

    if not localPlayer.vehicle then
        Garage.playerExit()
        return
    end

    -- нужно переносить отдельно, чтобы объекту задавалось уже нужное
    GarageInterior.update(localPlayer.interior, localPlayer.dimension)
    setTime(12, 0)
    setMinuteDuration(2147483647)

    setTimer(
        function()
            CameraManager.start()
            UI.setWindowVisible(true)
            UI.setVisibleHelpPanel(true)
            fadeCamera(true, 1)
        end, 1000, 1)
    
        _isPlayerOnTuning = true

    --[[
    setTimer(function ()
        if localPlayer.vehicle and isPlayerOnTuning then
            localPlayer.vehicle.frozen = true
        end
    end, 3000, 1)]]

end
addEvent("tmtaVehTuning.onPlayerEnterGarage", true)
addEventHandler("tmtaVehTuning.onPlayerEnterGarage", root,  Garage.playerEnter)

function Garage.playerExit()
    if not _isPlayerOnTuning then 
        return
    end 

    -- Телепортировать игрока к выходу
    if PlayerCurrentGarageMarker then
        local targetPosition = PlayerCurrentGarageMarker.position
        local targetRotation = Vector3(0, 0, PlayerCurrentGarageMarker.angle)
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

    exports.tmtaHUD:moneyHide()
    UI.setVisibleHelpPanel(false)
    showCursor(false)
    UI.setWindowVisible(false)
    --triggerServerEvent("tmtaServerTimecycle.onGameTimeRequest", localPlayer)

    exports.tmtaUI:setPlayerComponentVisible("all", true)
	showChat(true)

    _isPlayerOnTuning = false
    toggleAllControls(true, true, true)
    fadeCamera(true, 1)
end
addEvent("tmtaVehTuning.onPlayerExitGarage", true)
addEventHandler("tmtaVehTuning.onPlayerExitGarage", root, Garage.playerExit)

-- Выход из гаража
--[[
addCommandHandler('tun', function()
    triggerServerEvent("tmtaVehTuning.onPlayerExitGarage", localPlayer)
end)
]]

-- exports
isPlayerOnTuning = function ()
    return _isPlayerOnTuning or false
end