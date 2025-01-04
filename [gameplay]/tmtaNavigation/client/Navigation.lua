Navigation = {}

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local TEXTURE_POINT = dxCreateTexture('assets/point.png', 'argb', false, 'clamp')
local MIN_DISTANCE = 2

local FONT = {
    ['DX_RB_10'] = exports.tmtaFonts:createFontDX('RobotoBold', 10),
    ['DX_RB_12'] = exports.tmtaFonts:createFontDX('RobotoBold', 12),
}

local zoom = 1
local minZoom = 2
if sW < sDW then
	zoom = math.min(minZoom, sDW/sW)
end
local w, h = 64/zoom, 64/zoom

local createdPoints = {}
local createdMarkers = {}

local function dxDrawText3D(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
	alignX = alignX or "center"
	alignY = alignY or "center"
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, _, _, _, true)
end

addEventHandler('onClientRender', root,
    function()
        if (not exports.tmtaUI:isPlayerComponentVisible("text3d") or localPlayer.interior ~= 0) then
            return
        end

        local rx, ry, rz = getElementPosition(localPlayer)
        for point, data in pairs(createdPoints) do
            if isElement(point) then
                local x, y, z = getElementPosition(point)
                local sx, sy = getScreenFromWorldPosition(x, y, z)
                local distance = getDistanceBetweenPoints3D(rx, ry, rz, x, y, z)
                if (sx and sy and distance > MIN_DISTANCE) then
                    dxDrawImage(sx-(w/1.7), sy-160/zoom, w, h, TEXTURE_POINT, 0, 0, 0, tocolor(255, 255, 255, 255), false)

                    local posY = 90
                    if data.title then
                        dxDrawText3D('#f2ab12'..data.title, sx-10/zoom+1, sy-posY/zoom+1, sx+1, sy+1, tocolor(255, 255, 255, 255), 1, FONT.DX_RB_10, 'center', 'top')
                        posY = posY - 40
                    end

                    local distance = tostring(exports.tmtaUtils:comma_value(math.floor(distance))) .. " м"
                    dxDrawText3D(distance, sx-10/zoom+1, sy-posY/zoom+1, sx+1, sy+1, tocolor(255, 255, 255, 255), 1, FONT.DX_RB_12, 'center', 'top')
                end
            end
        end
    end
)

function Navigation.createPoint(element, title)
    if (not isElement(element) or createdPoints[element]) then
        return false
    end

    createdPoints[element] = {}

    if (type(title) == 'string' and title:len() > 0) then
        createdPoints[element].title = title
    end

    return true
end
addEvent('tmtaNavigation.createPoint', true)
addEventHandler('tmtaNavigation.createPoint', root, Navigation.createPoint)

function Navigation.createPointWithMarker(element, title)
    if not Navigation.createPoint(element, title) then
        return false
    end

    local marker = createMarker(element.position, 'checkpoint', 5, 255, 255, 255, 75)
    exports.tmtaBlip:createBlipAttachedTo(
        marker, 
        'blipCheckpoint',
        {name='Метка (навигация)'},
        tocolor(255, 0, 0, 255)
    )

    createdPoints[element].marker = marker
    createdMarkers[marker] = element

    return true
end
addEvent('tmtaNavigation.createPointWithMarker', true)
addEventHandler('tmtaNavigation.createPointWithMarker', root, Navigation.createPointWithMarker)

addEventHandler('onClientMarkerHit', root,
    function(element)
        if not createdMarkers[source] then
            return
        end
        Navigation.destroyPoint(createdMarkers[source])
    end
)

function Navigation.destroyPoint(element)
    if (not isElement(element) or not createdPoints[element]) then
        return false
    end
    if createdPoints[element].marker then
        destroyElement(createdPoints[element].marker)
    end
    createdPoints[element] = nil
    triggerEvent('tmtaNavigation.onPointDestroy', element)
end

addEventHandler('onClientElementDestroy', root, 
	function()
        Navigation.destroyPoint(source)
    end
)