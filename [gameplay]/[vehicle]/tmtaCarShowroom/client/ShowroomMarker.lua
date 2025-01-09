ShowroomMarker = {}
ShowroomMarker.created = {}

local streamedShowrooms = {}

local Font = {
    ['DX_Elowen_24'] = exports.tmtaFonts:createFontDX('Elowen', 24),
    ['DX_RB_12'] = exports.tmtaFonts:createFontDX('RobotoBold', 12),
}

local SHOWROOM_OFFSET = 1.2
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
            local posX, posY = getScreenFromWorldPosition(x, y, z + SHOWROOM_OFFSET)
            if posX then
                local distance = getDistanceBetweenPoints3D(cX, cY, cZ, x, y, z)
                if (distance < SHOWROOM_MAX_DISTANCE) then
                    local scale = 1 / distance * SHOWROOM_SCALE
                    local width = SHOWROOM_WIDTH * scale
                    local height = SHOWROOM_HEIGHT * scale
                    local nx, ny = posX - width / 2, posY - height / 2
                
                    local offsetY = 0
                    dxDrawText3D('#f2ab12'..showroomData.name, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Font.DX_Elowen_24, 'center', 'top')
                
                    -- Класс имущества
					offsetY = offsetY + 45
                    local showroomClassStr = string.format('Класс: #f2ab12%s', utf8.lower(showroomData.class))
					dxDrawText3D(showroomClassStr, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Font.DX_RB_12, 'center', 'top')
                
                    -- Ассортимент
                    offsetY = offsetY + 25
                    local showroomTypeStr = string.format('Ассортимент: #f2ab12%s', utf8.lower(showroomData.type))
                    dxDrawText3D(showroomTypeStr, nx, ny + offsetY*scale, nx + width, ny + height, tocolor(255, 255, 255, 255), scale, Font.DX_RB_12, 'center', 'top')
                
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

    exports.tmtaBlip:createBlipAttachedTo(
        carShowroom, 
        'blipCarshop',
        {name='Автосалон'},
        tocolor(0, 255, 0, 255)
    )

    ShowroomMarker.created[carShowroom] = showroomData
    
    return true
end

local actionButton = nil

function ShowroomMarker.markerActionButton(key, state, marker)
    if (not isElement(marker) or not isElementWithinMarker(localPlayer, marker)) then
        return
    end
    playSoundFrontEnd(32)
    Showroom.enter(marker)
    if (isElement(actionButton)) then
        destroyElement(actionButton)
    end
end

addEventHandler('onClientMarkerHit', root, 
    function(player)
        if (player.type ~= "player" or player ~= 'localPlayer' or player.vehicle) then
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

        playSoundFrontEnd(40)
        actionButton = exports.tmtaUI:guiCreateActionKey('keyE', 'Войти в автосалон')
        bindKey('e', 'down', ShowroomMarker.markerActionButton, source)
    end
)

addEventHandler('onClientMarkerLeave', root,
    function(player)
        if (player.type ~= 'player' or not ShowroomMarker.created[source]) then
            return
        end

        if (isElement(actionButton)) then
            destroyElement(actionButton)
        end

        unbindKey('e', 'down', ShowroomMarker.markerActionButton, source)
    end
)