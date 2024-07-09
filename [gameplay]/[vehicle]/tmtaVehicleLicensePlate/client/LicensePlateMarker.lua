LicensePlateMarker = {}
LicensePlateMarker.created = {}

local streamedMarker = {}

local MARKER_OFFSET = 2
local MARKER_WIDTH = 250
local MARKER_HEIGHT = 200
local MARKER_MAX_DISTANCE = 50
local MARKER_SCALE = 5.8

local FONT = {
    ['DX_RB_16'] = exports.tmtaFonts:createFontDX('RobotoBold', 16),
}

local function dxDrawText3D(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
	alignX = alignX or "center"
	alignY = alignY or "center"
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, _, _, _, true)
end

addEventHandler("onClientRender", root, 
    function()
        if not exports.tmtaUI:isPlayerComponentVisible("text3d") then
            return
        end

        local cx, cy, cz = getCameraMatrix()
        for marker in pairs(streamedMarker) do
            local x, y, z = getElementPosition(marker)
            local posX, posY = getScreenFromWorldPosition(x, y, z + MARKER_OFFSET)
            if posX then
                local distance = getDistanceBetweenPoints3D(cx, cy, cz, x, y, z)
                if (distance < MARKER_MAX_DISTANCE) then
                    local scale = 1 / distance * MARKER_SCALE
                    local width = MARKER_WIDTH * scale
                    local height = MARKER_HEIGHT * scale
                    local nx, ny = posX - width / 2, posY - height / 2

                    local offsetY = 0
                    dxDrawText3D('#FFFFFFГОСУДАРСТВЕННАЯ\n#0039A6РЕГИСТРАЦИЯ\n#D52B1EТРАНСПОРТНЫХ СРЕДСТВ', nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, FONT.DX_RB_16, 'center', 'top')
                
                    offsetY = offsetY + 100
					dxDrawText3D('Регистрация и хранение\nномерных знаков', nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, FONT.DX_RB_16, 'center', 'top')
                end
            end
        end
    end
)

function LicensePlateMarker.streamIn(marker)
    if (getElementType(marker) ~= 'marker' or not LicensePlateMarker.created[marker] or streamedMarker[marker] or not isElementStreamedIn(marker)) then
		return
	end
    streamedMarker[marker] = true
end
addEventHandler("onClientElementStreamIn", root, function() LicensePlateMarker.streamIn(source) end)

function LicensePlateMarker.streamOut(marker)
    if (getElementType(marker) ~= 'marker' or not streamedMarker[marker]) then
        return
    end
    streamedMarker[marker] = nil
end
addEventHandler("onClientElementStreamOut", root, function() LicensePlateMarker.streamOut(source) end)

function LicensePlateMarker.createMarkers()
    for _, licensePlateRegistrationPoint in pairs(Config.LICENSE_PLATE_REGISTRATION_POINTS) do
        for _, markerPosition in pairs(licensePlateRegistrationPoint.markerPosition) do
            local position = Vector3(markerPosition.x, markerPosition.y, markerPosition.z) - Vector3(0, 0, 1)
            local marker = createMarker(position, "cylinder", 2, unpack(licensePlateRegistrationPoint.markerColor))

            LicensePlateMarker.streamIn(marker)
            LicensePlateMarker.created[marker] = marker
        end

        local _fakeMarker = createMarker(licensePlateRegistrationPoint.blipPosition, "cylinder", 2, 255, 255, 255, 0)
        exports.tmtaBlip:createBlipAttachedTo(
            _fakeMarker, 
            'blipLicensePlate',
            {name='Регистрация номерных знаков'}
        )
    end
end

local _actionButton = nil
function LicensePlateMarker.onActionButtonPressed(_, _, marker)
    if (not isElement(marker) or not isElementWithinMarker(localPlayer, marker)) then
        return LicensePlateMarker.destroyActionButton()
    end
    if (not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer) then
        return LicensePlateMarker.destroyActionButton()
    end
    playSoundFrontEnd(32)
    LicensePlateGUI.openWindow()
end

function LicensePlateMarker.destroyActionButton()
    if (isElement(_actionButton)) then
        destroyElement(_actionButton)
    end

    unbindKey('e', 'down', LicensePlateMarker.onActionButtonPressed, source)
    toggleControl('vehicle_look_right', true)
end

addEventHandler('onClientMarkerHit', resourceRoot, 
    function(player)
        if (not LicensePlateMarker.created[source] or player.type ~= 'player' or not player.vehicle or player.vehicle.controller ~= player) then
            return
        end 
    
        local verticalDistance = localPlayer.position.z - source.position.z
        if (verticalDistance > 5 or verticalDistance < -1) then
            return
        end

        local owner = player.vehicle:getData("owner")
        if (not owner or owner ~= player) then
            return Utils.showNotice("Регистрационные действия доступны только с #FFA07Aличным транспортом")
        end

        playSoundFrontEnd(40)
        _actionButton = exports.tmtaUI:guiCreateActionKey('keyE', 'Зарегистрировать транспортное средство')
        bindKey('e', 'down', LicensePlateMarker.onActionButtonPressed, source)
        toggleControl('vehicle_look_right', false)
    end
)

addEventHandler('onClientMarkerLeave', resourceRoot,
    function(player)
        if (not LicensePlateMarker.created[source]) then
            return
        end
        LicensePlateMarker.destroyActionButton()
    end
)