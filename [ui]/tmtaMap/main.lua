Map = {}
Map.visible = false

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()
Map.textures = {}

Map.waterColor = tocolor(110, 158, 204)

Map.x = 0
Map.y = 0
Map.stateMove = false

Map.scale = 1 -- масштаб (const)
Map.minScale = 0.045 * 12
Map.maxScale = 1.7
Map.scaleSpeed = 0.05 -- скорость изменения масштаба
Map.zoomSpeed = 0.15 -- скорость зума

Map.blipSize = 32/1.2

Map.MAX_DISTANCE_PLAYER_VISIBLE = 180
Map.MAX_DISTANCE_BLIP_VISIBLE = 180

Map.sectionVisible = true 

local sectionNames = { 
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
}

-- Move --
local Pozmx, Pozmy = 0, 0
local Pozm, Pozym = 0, 0

local function updateMoving()
    local xX, yX = getMousePos()
	local Rx = Pozm - (Pozmx/Map.scale)
	local Ry = Pozym - (Pozmy/Map.scale)

    Map.x, Map.y = ((xX/Map.scale))+Rx, ((yX/Map.scale))+Ry

	if Map.x > 0  then
        Map.x = 0
    elseif Map.x < -3000 then
        Map.x = -3000
    end

    if Map.y > 0 then
        Map.y = 0
    elseif Map.y < -3000 then
        Map.y = -3000
    end
end

function Map.moveTo ( x, y )
    Map.x = x;
    Map.y = y;
end

local function posWorldToMapPos ( x, y )
    local offsetX = sW / 2;
    local offsetY = sH / 2;
    local mapX = offsetX + (x + 3000) / 6000 * 3072;
    local mapY = offsetY + (-y + 3000) / 6000 * 3072;
    return mapX, mapY;
end

function Map.moveToPlayer()
    x, y = posWorldToMapPos(getElementPosition(localPlayer))
    x = x - sW / 2
    y = y - sH / 2
    Map.x = -x
    Map.y = -y
    Map.moveTo(-x, -y)
end

local function posWorldToMap( x, y )
    local offsetX = Map.x * Map.scale + sW / 2
    local offsetY = Map.y * Map.scale + sH / 2
    local mapX = offsetX + (x + 3000) / 6000 * 3072 * Map.scale
    local mapY = offsetY + (-y + 3000) / 6000 * 3072 * Map.scale
    return mapX, mapY
end

function Map.zoomIn()
    Map.scale = Map.scale + Map.zoomSpeed
    if Map.scale > Map.maxScale then
        Map.scale = Map.maxScale
    end
end

function Map.zoomOut()
    Map.scale = Map.scale - Map.zoomSpeed
    if Map.scale < Map.minScale then
        Map.scale = Map.minScale
    end
end

addEventHandler('onClientKey', root,
    function(key)
        if not Map.visible then
            return
        end
        if key == 'mouse_wheel_down' then
            Map.zoomOut()
        elseif key == 'mouse_wheel_up' then
            Map.zoomIn()
        end
    end
)

local function posMapToWorld(x, y)
    local offsetX = Map.x * Map.scale + Display.Width / 2
    local offsetY = Map.y * Map.scale + Display.Height / 2
    local worldX = (x - offsetX) / (3072 * Map.scale) * 6000 - 3000
    local worldY = 6000 - (y - offsetY) / (3072 * Map.scale) * 6000 - 3000
    return worldX, worldY
end

local function isMouseInPositionBut(x, y, width, height)
	if not isCursorShowing() then
		return false
	end
    local sx, sy = guiGetScreenSize()
    local cx, cy = getCursorPosition()
    local cx, cy = (cx * sx), (cy * sy)
    if (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height) then
        return true
    else
        return false
    end
end

function getMousePos()
	local mx, my = getCursorPosition()
	if not mx or not my then
		mx, my = 0, 0
	end
	return mx * sW, my * sH
end

local str_title = 1;

addEventHandler('onClientClick', root, 
    function(button, state)
        if not Map.visible then
            return 
        end
        if button == 'left' and state == 'down' and not getKeyState ( 'lctrl' ) then
            local xZ, yZ = getCursorPosition ( )
            local xZ = ( xZ * sW )
            local yZ = ( yZ * sH )
            Pozmx, Pozmy = xZ, yZ
            Pozm, Pozym = Map.x, Map.y
            Map.stateMove = true
            elseif button == 'left' and state == 'up' and not getKeyState ( 'lctrl' ) then
                Map.stateMove = false

            local s, h = ( sW / 3 ), 100;
            local x, y, s, h = ( sW / 2 )- ( s / 2 ), sH - h, s, h;

            if isMouseInPositionBut ( ( x + s ) - 55, ( y + h ) - 25, 50, 20 ) then
                if str_title < 8 then
                str_title = str_title + 1;
                else
                str_title = 1;
                end
            end

            if isMouseInPositionBut ( ( x + s ) - 160, ( y + h ) - 25, 50, 20 ) then
                if str_title > 1 then
                str_title = str_title - 1;
                else
                str_title = 8;
                end
            end
        end
    end
)

----------
local streamedPlayer = {}

local function drawPlayers()
    local playerPosition = Vector3(localPlayer.position)
    for player in pairs(streamedPlayer) do
        if (player ~= localPlayer) then
            local x, y, z = getElementPosition(player)
            if (getDistanceBetweenPoints2D(x, y, playerPosition.x, playerPosition.y) <= Map.MAX_DISTANCE_PLAYER_VISIBLE) then
                local x, y = posWorldToMap(x, y)
                if x >= 0 and x <= sW and y >= 0 and y <= sH then
                    local blipIcon = Map.textures.blipMarker
                    local diffPosZ = z - playerPosition.z
                    if diffPosZ >= 5 then
                        blipIcon = Map.textures.blipMarkerHigher
                    elseif diffPosZ <= -5 then
                        blipIcon = Map.textures.blipMarkerLower
                    end

                    local blipColor = tocolor(255, 255, 255)
                    local vehicle = player.vehicle
                    if isElement(vehicle) then
                        local r, g, b = getVehicleColor(vehicle, true)
                        blipColor = tocolor(r, g, b)
                    end

                    local blipSize = Map.blipSize/1.3
                    dxDrawImage((x-blipSize/2), (y-blipSize/2), blipSize, blipSize, blipIcon, 0, 0, 0, blipColor)
                end
            end
        end
    end
end

local function drawBlips()
    local playerPosition = Vector3(localPlayer.position)
	for _, blip in ipairs(getElementsByType("blip")) do
        local icon = blip:getData("icon")
        if icon then
            local bpX, bpY, bpZ = getElementPosition(blip)
            local x, y = posWorldToMap(bpX, bpY)
            if (x >= 0 and x <= sW and y >= 0 and y <= sH) then
                if (Map.textures[icon] and localPlayer.interior == 0) then
                    local color = blip:getData("color") or tocolor(255, 255, 255, 255)
                    local data = blip:getData("data") or {}

                    local blipVisible = true
                    local permissibleDistance = (getDistanceBetweenPoints2D(bpX, bpY, playerPosition.x, playerPosition.y) <= Map.MAX_DISTANCE_BLIP_VISIBLE)
                    if (not data.isOwnerLocalPlayer and not permissibleDistance) then
                        if (data.isHouseBlip or data.isBusinessBlip) then
                            blipVisible = false
                        end
                        --local r, g, b, a = exports.tmtaUtils:fromColor(color)
                        --color = tocolor(r, g, b, 225)
                    end

                    if blipVisible then
                        dxDrawImage((x-Map.blipSize/2), (y-Map.blipSize/2), Map.blipSize, Map.blipSize, Map.textures[icon], 0, 0, 0, color)
                    end
                end
            end
        end
	end
end

function Map.draw()
    if not Map.visible then
        Map.close()
        return 
    end

    if Map.stateMove then
		updateMoving()
	end
    
    dxDrawRectangle(0, 0, sW,sH, Map.waterColor, false)
    local offsetX = sW /2
    local offsetY = sH /2

    dxSetTextureEdge(Map.textures.world, 'clamp')
    dxDrawImage(Map.x*Map.scale +offsetX, Map.y*Map.scale +offsetY, 3072 * Map.scale, 3072 * Map.scale, Map.textures.world, 0, 0, 0)

    drawBlips()
    drawPlayers()

    -- Сетка
    --[[
    if Map.sectionVisible then
        local St2 = 0
        for i = 1, 27 do
            local stx, sty = Map.x*Map.scale+offsetX, ((Map.y*Map.scale+offsetY))+St2
            local stx2, sty2 = ((Map.x*Map.scale+offsetX))+St2, (Map.y*Map.scale+offsetY)
            local space = 3
            --TODO:: попробовать реализовать пунктирные линии
            dxDrawRectangle(stx+((space /2) *Map.scale), sty, 3072 *Map.scale, space *Map.scale, tocolor(0, 40, 40, 180), false)
            dxDrawRectangle(stx2, sty2  + ( ( space / 2 ) * Map.scale ), space *Map.scale, 3072 *Map.scale, tocolor(0, 40, 40, 180), false)
            St2 = St2 + (3072*Map.scale)/26
        end
    end

    -- Секции (линейки)
    if Map.sectionVisible then
        local St = 0
        dxDrawRectangle((Map.x*Map.scale+offsetX), 0, 3072*Map.scale, 30, tocolor(40, 40, 40, 230), false)
        dxDrawRectangle(0, (Map.y*Map.scale+offsetY), 30, 3072*Map.scale, tocolor(40, 40, 40, 230), false)
        for i = 1, 26 do
            local section = sectionNames[i]
            if section then
                dxDrawText(tostring(section), ((Map.x*Map.scale+offsetX)+St)+((3072*Map.scale)/26)/2, 15, _, _, tocolor(255,255,255,255), 1, 1, 'default-bold', 'center', 'center', false, false, false, false, false)
                dxDrawText(tostring(i), 15, ((Map.y*Map.scale+offsetY)+St)+((3072*Map.scale)/26)/2, _, _, tocolor(255,255,255,255), 1, 1, 'default-bold', 'center', 'center', false, false, false, false, false)
            end
            St = St + (3072*Map.scale)/26
        end
    end
    --]]

    -- Локальный игрок
    dxSetTextureEdge(Map.textures.localPlayer, 'clamp')
    local x, y = posWorldToMap(getElementPosition(localPlayer))
    local playerRotation = getPedRotation(localPlayer)

    local animValue = getEasingValue(getAnimData('map-localPlayer-blip-flash'), 'InOutQuad')
    dxDrawImage((x-32/2), (y-32/2), 32, 32, Map.textures.localPlayer, -playerRotation, 0, 0, tocolor(255, 255, 255, 255*animValue))
end

function Map.setVisibleHelpPanel(state)
	if state then
		if isElement(Map.keyPane) then
			return
		end
        
		Map.keyPane = exports.tmtaUI:guiKeyPanelCreate(0, 0, {
			{"keyMouseLeft", "Перемещение"},
            {"keyMouseWheel", "Масштаб"},
            {"keySpace", "Легенда"},
            {"keyF11", "Закрыть"},
		}, true)

        local width, height = exports.tmtaUI:guiKeyPanelGetSize(Map.keyPane)
        exports.tmtaUI:guiKeyPanelSetPosition(Map.keyPane, sW*((sW-width-10) /sDW), sH*((sH-height-40) /sDH))
	else
		if not isElement(Map.keyPane) then
			return
		end
		destroyElement(Map.keyPane)
	end
end

local function localPlayerBlipFlash(value)
    setAnimData('map-localPlayer-blip-flash', 0.08, value)
    local _value = (value == 1) and 0 or 1
    animate('map-localPlayer-blip-flash', _value, function()
        setTimer(localPlayerBlipFlash, 200, 1, _value)
    end)
end

function Map.open()
    if (not exports.tmtaUI:isPlayerComponentVisible("map") or Camera.interior ~= 0) then
        return
    end

    showChat(false)
    showCursor(true)
    Map.scale = 1
    Map.moveToPlayer()
    fadeCamera(false, 1, 0, 0, 0)
    addEventHandler("onClientRender", root, Map.draw)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
    Map.setVisibleHelpPanel(true)
    
    localPlayerBlipFlash()
    
    Map.visible = true
    MapLegend.render()
    bindKey('space', 'down', MapLegend.setVisible)
end 

function Map.close()
    if not Map.visible then
        return
    end

    showChat(true)
	showCursor(false)
    Map.setVisibleHelpPanel(false)
 
    fadeCamera(true, 1, 0, 0, 0)
    removeEventHandler("onClientRender", root, Map.draw)
    exports.tmtaUI:setPlayerComponentVisible("all", true)
    Map.stateMove = false

    unbindKey('space', 'down', MapLegend.setVisible)
    MapLegend.destroy()

    Map.visible = false
end

function Map.start()
    setTimer(toggleControl, 50, 0, "radar", false) -- принудительная блокировка стандартной карты

    Map.textures.world = dxCreateTexture("assets/world.jpg", "dxt5", true, "clamp") -- карта

    Map.textures.localPlayer = exports.tmtaTextures:createTexture('localPlayer')

    -- Blips
    local blipTextures = exports.tmtaTextures:getBlipTextures()
    if (type(blipTextures) ~= 'table') then
        outputDebugString('Map.start: erorr load blip Textures', 1)
        return
    end

    Map.textures = exports.tmtaUtils:extendTable(Map.textures, blipTextures)

    bindKey("f11", "down", function()
        if not isCursorShowing() then
            return Map.open()
        end
        Map.close()
    end)
end
addEventHandler("onClientResourceStart", resourceRoot, Map.start)

addEventHandler("onClientElementStreamIn", root, 
    function()
        if source.type ~= "player" then
            return
        end
        streamedPlayer[source] = true
    end
)

addEventHandler("onClientElementStreamOut", root, 
    function()
        if source.type ~= "player" then
            return
        end
        streamedPlayer[source] = nil
    end
)

addEventHandler("onClientPlayerJoin", root, 
    function()
        if (not isElementStreamedIn(source)) then
            return
        end
	    streamedPlayer[source] = true
    end
)

addEventHandler("onClientPlayerQuit", root, 
    function()
	    streamedPlayer[source] = nil
    end
)

-- Exports
open = Map.open
close = Map.close