ShowroomMarker = {}
ShowroomMarker.created = {}

local streamedShowrooms = {}

local Font = {
    ['DX_Elowen_22'] = exports.tmtaFonts:createFontDX('Elowen', 22),
}

local SHOWROOM_OFFSET = 0.5
local SHOWROOM_WIDTH = 250
local SHOWROOM_HEIGHT = 200
local SHOWROOM_MAX_DISTANCE = 50
local SHOWROOM_SCALE = 5.8

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

        local cX, cY, cZ = getCameraMatrix()
        for showroomMarker, showroomData in pairs(streamedShowrooms) do
            local x, y, z = getElementPosition(showroomMarker)
            local posX, posY = getScreenFromWorldPosition(x, y, z)
            if posX then
                local distance = getDistanceBetweenPoints3D(cX, cY, cZ, x, y, z)
                if (distance < SHOWROOM_MAX_DISTANCE) then
                    if isLineOfSightClear(cX, cY, cZ, x, y, z, true, true, false, true, false, false, false, showroomMarker) then
                        local scale = 1 / distance * SHOWROOM_SCALE
                        local width = SHOWROOM_WIDTH * scale
                        local height = SHOWROOM_HEIGHT * scale
                        local nx, ny = posX - width / 2, posY - height / 2

                    
                        dxDrawRectangle(nx, ny, width, height, tocolor(0, 0, 0, 255))

                        local offsetY = 0
                        dxDrawText3D(showroomData.name, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Font.DX_Elowen_22, 'center', 'top')
                    end
                end
            end
        end
    end
)

function ShowroomMarker.streamIn(showroom)
    if (getElementType(showroom) ~= 'marker' or not ShowroomMarker.created[showroom] or streamedShowrooms[showroom]) then
		return
	end

    streamedShowrooms[showroom] = Showroom.getData(showroom)
end
addEventHandler("onClientElementStreamIn", root, function() ShowroomMarker.streamIn(source) end)

function ShowroomMarker.streamOut(showroom)
    if (getElementType(showroom) ~= 'marker' or not ShowroomMarker.created[showroom] or not streamedShowrooms[showroom]) then
		return
	end
    streamedShowrooms[showroom] = nil
end

addEventHandler("onClientElementStreamOut", root, function() ShowroomMarker.streamOut(source) end)

function ShowroomMarker.create(showroomData)
    if (type(showroomData) ~= 'table') then
        return false
    end

    local carShowroom = createMarker(showroomData.markerPosition - Vector3(0, 0, 1), 'cylinder', 2, unpack(showroomData.markerColor))
    ShowroomMarker.streamIn(carShowroom)

    exports.tmtaBlip:createAttachedTo(
        carShowroom, 
        'blipCarshop',
        'Автосалон',
        tocolor(0, 255, 0, 255)
    )

    ShowroomMarker.created[carShowroom] = showroomData
    
    return true
end

addEventHandler('onClientMarkerHit', root, 
    function(player)
        if (player.type ~= "player" or player.vehicle) then
            return
        end
        if (not ShowroomMarker.created[source]) then
            return
        end

        local verticalDistance = localPlayer.position.z - source.position.z
        if (verticalDistance > 5 or verticalDistance < -1) then
            return
        end

        if (isElement(_playerCurrentShowroom)) then
            return
        end

        Showroom.enter(source)
    end
)