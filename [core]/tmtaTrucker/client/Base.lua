local createdBase = {}
local _playerCurrentBase = nil

function Base.create(x, y, z, name)
    local marker = createMarker(x, y, z, "cylinder", 2, 0, 255, 155)
    marker.alpha = 0

    exports.tmtaBlip:createBlipAttachedTo(
        marker, 
        'blipTrucker',
        {name = 'База дальнобойщиков'},
        tocolor(255, 255, 0, 255)
    )

    exports.common_peds:createWorldPed({
        position = {
            coords = { x, y, z + 0.9, 0 },
            int = 0,
            dim = 0,
        },
        attachToLocalPlayer = true,
        text = name,
        model = 201,
        animations = {
            steps = 7,
            time = 10000,
            cycles = {
                {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                {"RAPPING", "RAP_A_Loop"},
                {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                {"COP_AMBIENT", "Coplook_think", 0, false, false, false, false},
                {"DEALER", "DEALER_IDLE_01", -1, false, false, false, false},
                {"ON_LOOKERS", "wave_loop", -1, false, false, false, false},
                {"COP_AMBIENT", "Coplook_think", 0, false, false, false, false}
            }
        }
    })

    return marker
end

function Base.init()
    for baseId, base in ipairs(Base.LIST) do
        local baseMarker = Base.create(base.position.x, base.position.y, base.position.z, base.name)

        createdBase[baseMarker] = { 
            id = baseId, 
            truckSpawnPosition = base.truckSpawnPosition,
        }

        addEventHandler("onClientMarkerHit", baseMarker, Trucker.onPlayerMarkerHit)
        addEventHandler("onClientMarkerLeave", baseMarker, Trucker.onPlayerMarkerLeave)
    end
end

function Base.setPlayerCurrentBase(baseMarker)
    _playerCurrentBase = isElement(baseMarker) and createdBase[baseMarker].id or nil
end

function Base.getPlayerCurrentBase()
    return _playerCurrentBase
end