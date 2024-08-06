Showroom = {}
Showroom.created = {}

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

function Showroom.vehicle()
end

function Showroom.enter()
    Showroom.objectInterior.interior = localPlayer.interior
    Showroom.objectInterior.dimension = localPlayer.dimension

    setTime(12, 0)
    setMinuteDuration(2147483647)
    ShowroomGUI.show()
end

function Showroom.exit()
    exports.tmtaTimecycle:syncPlayerGameTime()
    ShowroomGUI.hide()
end

function Showroom.create(showroomData)
    if (type(showroomData) ~= 'table') then
        return false
    end

    local marker = createMarker(showroomData.markerPosition - Vector3(0, 0, 1), 'cylinder', 2, unpack(showroomData.markerColor))

    exports.tmtaBlip:createAttachedTo(
        marker, 
        'blipCarshop',
        'Автосалон',
        tocolor(0, 255, 0, 255)
    )

    return marker
end

addEventHandler('onClientMarkerHit', root, 
    function(player)
        if (player.type ~= "player" or player.vehicle) then
            return
        end
        if (not Showroom.created[source]) then
            return
        end

        local verticalDistance = localPlayer.position.z - source.position.z
        if (verticalDistance > 5 or verticalDistance < -1) then
            return
        end

        --TODO: вход в автосалон
    end
)

addEventHandler('onClientResourceStart', resourceRoot,
    function()
        Showroom.createInterior()

        for _, showroomData in pairs(Config.showroomList) do
            local carShowroom = Showroom.create(showroomData)
            Showroom.created[carShowroom] = showroomData
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