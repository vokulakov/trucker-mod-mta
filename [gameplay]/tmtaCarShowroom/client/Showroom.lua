Showroom = {}

local _playerCurrentShowroom = nil
local _showroomCurrentVehiclePreview = nil

function Showroom.vehiclePreview()
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
    
        Showroom.bgSound = exports.tmtaSounds:playSound('int_car_showroom', true)
        setSoundVolume(Showroom.bgSound, 0.1)

        --TODO: vehiclePreview
    end
)

function Showroom.exit()
    return triggerServerEvent('tmtaCarShowroom.onPlayerExitCarShowroom', localPlayer)
end

addEvent('tmtaCarShowroom.onPlayerExitCarShowroom', true)
addEventHandler('tmtaCarShowroom.onPlayerExitCarShowroom', root, 
    function()
        exports.tmtaTimecycle:syncPlayerGameTime()
        ShowroomGUI.hide()
    
        if isElement(Showroom.bgSound) then
            stopSound(Showroom.bgSound)
        end

        setElementFrozen(localPlayer, true)
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
        if not isElement(ShowroomGUI.wnd) then
            Showroom.enter()
        else
            Showroom.exit()
        end
    end
)