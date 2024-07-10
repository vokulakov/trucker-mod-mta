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
local mapZoomScale = 6000/WORLD_SIZE

local width, height
local posX, posY
local mapWidth, mapHeight

local radarLeft, radarTop
local radarCenterX, radarCenterY
local radarRadius

addEventHandler('onClientHUDRender', root, 
    function()
        if not Radar.visible or not exports.tmtaUI:isPlayerComponentVisible("radar") then
            return
        end

        if camera.interior ~= 0 then
            return
        end

        -- scale = DEFAULT_SCALE
        -- if localPlayer.vehicle then
        --     local speed = localPlayer.vehicle.velocity.length
        --     scale = scale - math.min(MAX_SPEED_SCALE, speed * 1)
        -- end

        local playerPos = Vector2(localPlayer.position)
        --local playerDimension = getElementDimension(localPlayer)
        --local playerInterior = getElementInterior(localPlayer)

        -- Основа
        dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), tocolor(0, 0, 0, 155))

        -- Карта
        local X, Y = radarCenterX - (playerPos.x/mapZoomScale), radarCenterY + (playerPos.y/mapZoomScale)
        dxSetRenderTarget(mapRenderTarget)
            dxDrawRectangle(0, 0, radarWidth, radarHeight, tocolor(110, 158, 204))
            dxDrawImage(X - (mapWidth)/2, Y - (mapHeight)/2, mapWidth, mapHeight, Textures.world, camera.rotation.z, playerPos.x/mapZoomScale, -(playerPos.y/mapZoomScale), 0xFFFFFFFF)
        dxSetRenderTarget()

        dxSetBlendMode("modulate_add")
            dxDrawImage(radarPosX, radarPosY, radarWidth, radarHeight, mapRenderTarget, 0, 0, 0, tocolor(255, 255, 255, 255))
        dxSetBlendMode("blend")

        -- Урон по игроку
        local animData = getEasingValue(getAnimData('hiteffect'), 'InOutQuad')
        dxDrawImage(radarPosX, radarPosY, radarWidth, radarHeight, Textures.damage, 0, 0, 0, tocolor(186, 58, 58, playerDamageLost*animData))
    
        -- Север
        local direction = math.rad(-camera.rotation.z + 180)
        local blipX, blipY = radarCenterX + math.sin(direction) * radarRadius, radarCenterY + math.cos(direction) * radarRadius
        local blipX = math.max(0, math.min(blipX, radarWidth))
        local blipY = math.max(0, math.min(blipY, radarHeight))
        local blipSize = 28

        dxDrawImage(radarPosX + blipX - blipSize/2, radarPosY + blipY - blipSize/2, blipSize, blipSize, Textures.north, 0, 0, 0, tocolor(255, 255, 255, 255))

        -- Локальный игрок
        local arrowSize = ARROW_SIZE/1.2
        dxDrawImage(radarPosX + radarCenterX - arrowSize/2, radarPosY + radarCenterY - arrowSize/2, arrowSize, arrowSize, Textures.arrowLocalPlayer, camera.rotation.z-localPlayer.rotation.z, 0, 0)
    
        --dxDrawRectangle(radarPosX, radarPosY + radarCenterY, radarWidth, 1, tocolor(255, 0, 0))
        --dxDrawRectangle(radarPosX + radarCenterX, radarPosY, 1, radarHeight, tocolor(255, 0, 0))
    end
)

function Radar.start()
    if (mapRenderTarget) then
        return
    end

    width, height = 250, 170
    posX, posY = 20, sDH-height-40

    mapRenderTarget = dxCreateRenderTarget(sW*((width-10) /sDW), sH*((height-10) /sDH))
    if not (mapRenderTarget) then
		outputDebugString("Radar: Failed to create renderTarget")
		return
	end

    Textures.world = dxCreateTexture('assets/map.jpg', 'dxt5', true, 'wrap')
    mapWidth, mapHeight = dxGetMaterialSize(Textures.world)

    radarPosX, radarPosY = sW*((posX+5) /sDW), sH*((posY+5) /sDH)
    radarWidth, radarHeight = dxGetMaterialSize(mapRenderTarget)
    radarCenterX, radarCenterY = radarWidth/2, radarHeight/2
    radarRadius = math.sqrt(radarCenterX^2 + radarCenterY^2)

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