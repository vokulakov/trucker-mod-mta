Radar = {}
Radar.visible = false

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local Textures = {}
local streamedPlayer = {}

local WORLD_SIZE = 3072
local BLIP_SIZE = 32
local ARROW_SIZE = 32
local SCALE_FACTOR = 2.5
local DEFAULT_SCALE = 2.5
local MAX_SPEED_SCALE = 0.9

local mapRenderTarget
local camera
local playerDamageLost = 0
local scale = DEFAULT_SCALE

local width, height
local posX, posY
local mapWidth, mapHeight

local radarLeft, radarTop
local radarCenterX, radarCenterY
local radarRadius

-- local function drawAreas()
-- end

-- local function drawBlips()
-- end

-- local function drawMap()
--     local x = (localPlayer.position.x + 3000) / 6000 * WORLD_SIZE
-- 	local y = (-localPlayer.position.y + 3000) / 6000 * WORLD_SIZE

--     --dxDrawRectangle(0, 0, mapWidth, mapHeight, tocolor(110, 158, 204))

   
--     -- dxDrawImage(X - (zmW)/2, Y - (zmH)/2, zmW, zmH, WORLD_TXT, camera_rotation.z, px/mapZoomScale, -(py/mapZoomScale), 0xFFFFFFFF)
    
--     dxDrawImage(mapWidth /2 - x, mapHeight /2 - y, mapWidth, mapHeight, Textures.world, camera.rotation.z)

--     -- Локальный игрок (стрелка)
--     local arrowSize = ARROW_SIZE*scale/(SCALE_FACTOR)
--     dxDrawImage((mapWidth - arrowSize) /2, (mapHeight - arrowSize) /2, arrowSize, arrowSize, Textures.arrowLocalPlayer, camera.rotation.z-localPlayer.rotation.z, 0, 0)
-- end

addEventHandler('onClientHUDRender', root, 
    function()
        if not Radar.visible or not exports.tmtaUI:isPlayerComponentVisible("radar") then
            return
        end

        if camera.interior ~= 0 then
            return
        end

        scale = DEFAULT_SCALE
        if localPlayer.vehicle then
            local speed = localPlayer.vehicle.velocity.length
            scale = scale - math.min(MAX_SPEED_SCALE, speed * 1)
        end

        local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
        local playerDimension = getElementDimension(localPlayer)
        local playerInterior = getElementInterior(localPlayer)

        -- Основа
        dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), tocolor(0, 0, 0, 155))

        -- Карта
        dxSetRenderTarget(mapRenderTarget, true)
            local mapZoomScale = 6000/WORLD_SIZE
            local X, Y = mapWidth/2 - (playerPosX/mapZoomScale), mapHeight*(3/5) + (playerPosY/mapZoomScale)
            local zmW, zmH = mapWidth, mapHeight

            dxDrawRectangle(0, 0, mapWidth, mapHeight, tocolor(110, 158, 204))
            dxDrawImage(X - (zmW)/2, Y - (zmH)/2, zmW, zmH, Textures.world, camera.rotation.z, playerPosX/mapZoomScale, -(playerPosY/mapZoomScale), 0xFFFFFFFF)
        dxSetRenderTarget()

        dxSetBlendMode("modulate_add")
            dxDrawImage(radarLeft, radarTop, radarWidth, radarHeight, mapRenderTarget, 0, 0, 0, tocolor(255, 255, 255, 255))
        dxSetBlendMode("blend")

        -- Урон по игроку
        local animData = getEasingValue(getAnimData('hiteffect'), 'InOutQuad')
        dxDrawImage(radarLeft, radarTop, radarWidth, radarHeight, Textures.damage, 0, 0, 0, tocolor(186, 58, 58, playerDamageLost*animData))
    
        -- Север
        local direction = math.rad(-camera.rotation.z + 180)
        local blipX, blipY = radarCenterX + math.sin(direction) * radarRadius, radarCenterY + math.cos(direction) * radarRadius
        local blipX = math.max(0, math.min(blipX, radarWidth))
        local blipY = math.max(0, math.min(blipY, radarHeight))
        local blipSize = 28

        dxDrawImage(radarLeft + blipX - blipSize/2, radarTop + blipY - blipSize/2, blipSize, blipSize, Textures.north, 0, 0, 0, tocolor(255, 255, 255, 255))
    end
)

function Radar.start()
    if (mapRenderTarget) then
        return
    end

    width, height = 250, 170
    posX, posY = 20, sDH-height-40

    mapRenderTarget = dxCreateRenderTarget(sW*((width) /sDW), sH*((height) /sDH), true)
    if not (mapRenderTarget) then
		outputDebugString("Radar: Failed to create renderTarget")
		return
	end

    
    Textures.world = dxCreateTexture('assets/map.jpg', 'dxt5', true, 'wrap')
    mapWidth, mapHeight = dxGetMaterialSize(Textures.world)

    radarLeft, radarTop = sW*((posX+5) /sDW), sH*((posY+5) /sDH)
    radarWidth, radarHeight = sW*((width-10) /sDW), sH*((height-10) /sDH)
    radarCenterX, radarCenterY = radarWidth/2, radarHeight*(3/5)
    radarRadius = math.sqrt((radarWidth/2)^2 + (radarHeight*(3/5))^2)

    Textures.north               = dxCreateTexture('assets/north.png')
    Textures.damage              = dxCreateTexture('assets/damage.png')
    Textures.arrowLocalPlayer    = exports.tmtaTextures:createTexture('localPlayer')

    Textures.blipMarker          = exports.tmtaTextures:createTexture('blipMarker')
    Textures.blipMarkerHigher    = exports.tmtaTextures:createTexture('blipMarkerHigher')
    Textures.blipMarkerLower     = exports.tmtaTextures:createTexture('blipMarkerLower')
    Textures.blipProperty        = exports.tmtaTextures:createTexture('blipProperty')
    Textures.blipGasStation      = exports.tmtaTextures:createTexture('blipGasStation')
    Textures.blipClothes         = exports.tmtaTextures:createTexture('blipClothes')
    Textures.blipSto             = exports.tmtaTextures:createTexture('blipSto')
    Textures.blipCarshop         = exports.tmtaTextures:createTexture('blipCarshop')
    Textures.blipPolice          = exports.tmtaTextures:createTexture('blipPolice')
    Textures.blipTuning          = exports.tmtaTextures:createTexture('blipTuning')
    Textures.blipScooterRent     = exports.tmtaTextures:createTexture('blipScooterRent')
    Textures.blipRestaurant      = exports.tmtaTextures:createTexture('blipRestaurant')
    Textures.blipPaint           = exports.tmtaTextures:createTexture('blipPaint')
    Textures.blipNumberPlate     = exports.tmtaTextures:createTexture('blipNumberPlate')

    camera = getCamera()
    setAnimData('hiteffect', 0.1)

    Radar.visible = true
end
addEventHandler("onClientResourceStart", resourceRoot, Radar.start)

addEventHandler("onClientPlayerDamage", localPlayer, 
    function(_, _, _, lost)
        playerDamageLost = 255*(lost/100)
        if playerDamageLost < 155 then
            playerDamageLost = 155
        end
        setAnimData('hiteffect', 0.01, 1)
        animate('hiteffect', 0)
    end
)

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