Showroom = {}

local _playerCurrentShowroom = nil
local _showroomCurrentVehiclePreview = nil

function Showroom.vehiclePreview(vehicleModel)
    local vehicleId = tonumber(Utils.getVehicleModelFromName(vehicleModel))
    if isElement(_showroomCurrentVehiclePreview) then
        setElementModel(_showroomCurrentVehiclePreview, vehicleId)
        return
    end

    local showroomData = Showroom.getData()

    local vehicle = createVehicle(vehicleId, showroomData.vehiclePosition, showroomData.vehicleRotation)
    setVehicleDamageProof(vehicle, true)
    vehicle.dimension = localPlayer.dimension
    vehicle.interior = localPlayer.interior
    
    _showroomCurrentVehiclePreview = vehicle
    
    return vehicle
end

function Showroom.getData(showroom)
    local showroom = showroom or _playerCurrentShowroom
    if (not isElement(showroom) or not ShowroomMarker.created[showroom]) then
        return false
    end
    return ShowroomMarker.created[showroom]
end

function Showroom.enter(showroom)
    if (isElement(_playerCurrentShowroom)) then
        return
    end

    exports.tmtaUI:setPlayerComponentVisible('all', false)
    exports.tmtaUI:setPlayerComponentVisible('notifications', true)
	showChat(false)
    fadeCamera(false, 1)
    _playerCurrentShowroom = showroom
    
    return triggerServerEvent('tmtaCarShowroom.onPlayerEnterCarShowroom', localPlayer)
end

addEvent('tmtaCarShowroom.onPlayerEnterCarShowroom', true)
addEventHandler('tmtaCarShowroom.onPlayerEnterCarShowroom', root, 
    function()
        setElementFrozen(localPlayer, true)
        Showroom.objectInterior.interior = localPlayer.interior
        Showroom.objectInterior.dimension = localPlayer.dimension
    
        setTime(12, 0)
        setMinuteDuration(2147483647)

        ShowroomGUI.show()

        local vehicle = Showroom.vehiclePreview(ShowroomGUI.getSelectedVehicle())
        CameraManager.start(vehicle)

        Showroom.bgSound = exports.tmtaSounds:playSound('int_car_showroom', true)
        setSoundVolume(Showroom.bgSound, 0.4)

        fadeCamera(true)
    end
)

function Showroom.exit()
    ShowroomGUI.hide()
    fadeCamera(false, 1)
    return triggerServerEvent('tmtaCarShowroom.onPlayerExitCarShowroom', localPlayer)
end

addEvent('tmtaCarShowroom.onPlayerExitCarShowroom', true)
addEventHandler('tmtaCarShowroom.onPlayerExitCarShowroom', root, 
    function()
        exports.tmtaTimecycle:syncPlayerGameTime()
    
        if isElement(Showroom.bgSound) then
            stopSound(Showroom.bgSound)
        end

        localPlayer.position = _playerCurrentShowroom.position + Vector3(0, 0, 1)
        setElementFrozen(localPlayer, false)
        
        exports.tmtaUI:setPlayerComponentVisible("all", true)
        showChat(true)

        CameraManager.stop()
        fadeCamera(true)

        if isElement(_showroomCurrentVehiclePreview) then
            destroyElement(_showroomCurrentVehiclePreview)
        end

        _playerCurrentShowroom = nil
    end
)

function Showroom.createInterior()
    local txd = engineLoadTXD('assets/object/interiorShowroom.txd', true)
    engineImportTXD(txd, Config.showroomObjectId)

    local dff = engineLoadDFF('assets/object/interiorShowroom.dff', 0)
    engineReplaceModel(dff, Config.showroomObjectId)

    local col = engineLoadCOL('assets/object/interiorShowroom.col')
    engineReplaceCOL(col, Config.showroomObjectId)
    
    Showroom.objectInterior = createObject(Config.showroomObjectId, Config.showroomObjectPosition)
    engineSetModelLODDistance(Config.showroomObjectId, 50)

    Showroom.objectInterior.interior = Config.showroomObjectInterior
    Showroom.objectInterior.dimension = 1812
end

addEventHandler('onClientResourceStart', resourceRoot,
    function()
        Showroom.createInterior()

        for _, showroomData in pairs(Config.showroomList) do
            ShowroomMarker.create(showroomData)
        end
    end
)

-- Test
bindKey('F3', 'down', 
    function()
    end
)