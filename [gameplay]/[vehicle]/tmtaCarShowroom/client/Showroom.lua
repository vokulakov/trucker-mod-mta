Showroom = {}

local _playerCurrentShowroom = nil
local _showroomCurrentVehiclePreview = nil

function Showroom.getData(showroom)
    local showroom = showroom or _playerCurrentShowroom
    if (not isElement(showroom) or not ShowroomMarker.created[showroom]) then
        return false
    end
    return ShowroomMarker.created[showroom]
end

function Showroom.vehiclePreview(model)
    local showroomData = Showroom.getData()

    local vehicle = _showroomCurrentVehiclePreview
    local vehicleId = tonumber(Utils.getVehicleModelFromName(model))
    if isElement(vehicle) then
        setElementModel(vehicle, vehicleId)

        local distanceToGround = getElementDistanceFromCentreOfMassToBaseOfModel(vehicle)
        vehicle.position = showroomData.vehiclePosition + Vector3(0, 0, distanceToGround -1)

        return
    end

    local vehicle = createVehicle(vehicleId, showroomData.vehiclePosition, showroomData.vehicleRotation)
    setVehicleDamageProof(vehicle, true)
    vehicle.dimension = localPlayer.dimension
    vehicle.interior = localPlayer.interior
    vehicle.collisions = false
    vehicle.frozen = true

    setTimer(
        function()
            local distanceToGround = getElementDistanceFromCentreOfMassToBaseOfModel(vehicle)
            vehicle.position = showroomData.vehiclePosition + Vector3(0, 0, distanceToGround -1)
        end, 100, 1)

    _showroomCurrentVehiclePreview = vehicle
    
    local r, g, b = ShowroomGUI.getColorFromColorPicker()
    Showroom.setVehiclePreviewColor(r, g, b)
    
    return vehicle
end

function Showroom.setVehiclePreviewColor(r, g, b)
    if (not isElement(_showroomCurrentVehiclePreview) or r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) then
        return false
    end

    setVehicleColor(_showroomCurrentVehiclePreview, r, g, b, r, g, b)
    triggerEvent('onClientVehicleSetColor', _showroomCurrentVehiclePreview)
end
addEvent('tmtaCarShowroom.onClientColorPick', true)
addEventHandler('tmtaCarShowroom.onClientColorPick', root, Showroom.setVehiclePreviewColor)

function Showroom.buyVehicle(vehicle)
    local r1, g1, b1, r2, g2, b2 = getVehicleColor(_showroomCurrentVehiclePreview, true)
    return triggerServerEvent('tmtaCarShowroom.buyPlayerVehicle', localPlayer, vehicle.model, vehicle.price, vehicle.level or 0, r1, g1, b1, r2, g2, b2)
end

function Showroom.enter(showroom)
    if (isElement(_playerCurrentShowroom) or not showroom) then
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

        ShowroomGUI._currentColorPick = math.random(1, #Config.colorList)
        ShowroomGUI._showroom = nil
        ShowroomGUI._cerrentSelectItem = nil
        
        ShowroomGUI.show()

        local selectedVehicle = ShowroomGUI.getSelectedVehicle()
        local vehicle = Showroom.vehiclePreview(selectedVehicle.model)
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
        if (not isElement(_playerCurrentShowroom)) then
            return
        end

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