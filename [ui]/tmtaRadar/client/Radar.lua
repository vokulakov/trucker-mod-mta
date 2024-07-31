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

local MAX_DISTANCE_BLIP_VISIBLE = 240
local MAX_DISTANCE_PLAYER_VISIBLE = 80

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

local playerPosition

local function drawBlips()
    for _, blip in ipairs(getElementsByType("blip")) do
        local blipIcon = blip:getData("icon")
        if (blipIcon and Textures[blipIcon]) then
            local x, y, z = getElementPosition(blip)
            local distance = getDistanceBetweenPoints2D(x, y, playerPosition.x, playerPosition.y)
            if (distance <= blip.visibleDistance and distance <= MAX_DISTANCE_BLIP_VISIBLE) then
                local radius = distance/mapZoomScale
                local direction = math.atan2(blip.position.x - playerPosition.x, blip.position.y - playerPosition.y) + math.rad(camera.rotation.z)
                local blipX, blipY = Radar.calcBlipPos(direction, radius)

                local blipSize = BLIP_SIZE/1.3
                local blipColor = blip:getData("color") or tocolor(255, 255, 255)
                local isVisible = true
    
                if isVisible then
                    dxDrawImage(radarPosX + blipX - (blipSize)/2, radarPosY + blipY - (blipSize)/2, blipSize, blipSize, Textures[blipIcon], 0, 0, 0, blipColor)
                end
            end
        end
    end
end

local function drawPlayers()
    for player in pairs(streamedPlayer) do
        if (player ~= localPlayer) then
            local x, y, z = getElementPosition(player)
            local distance = getDistanceBetweenPoints2D(x, y, playerPosition.x, playerPosition.y)
            if (distance <= MAX_DISTANCE_PLAYER_VISIBLE) then
                local radius = distance/mapZoomScale
                local direction = math.atan2(x - playerPosition.x, y - playerPosition.y) + math.rad(camera.rotation.z)
                local blipX, blipY = Radar.calcBlipPos(direction, radius)

                local blipIcon = Textures.blipMarker
                local diffPosZ = z - playerPosition.z
                if diffPosZ >= 5 then
                    blipIcon = Textures.blipMarkerHigher
                elseif diffPosZ <= -5 then
                    blipIcon = Textures.blipMarkerLower
                end

                local blipColor = tocolor(255, 255, 255)
                local vehicle = player.vehicle
                if isElement(vehicle) then
                    local r, g, b = getVehicleColor(vehicle, true)
                    blipColor = tocolor(r, g, b)
                end

                local blipSize = BLIP_SIZE/1.3
                dxDrawImage(radarPosX + blipX - (blipSize)/2, radarPosY + blipY - (blipSize)/2, blipSize, blipSize, blipIcon, -camera.rotation.z, 0, 0, blipColor)
            end
        end
    end
end

addEventHandler('onClientHUDRender', root, 
    function()
        if (not Radar.visible or not exports.tmtaUI:isPlayerComponentVisible("radar") or camera.interior ~= 0) then
            return
        end

        playerPosition = Vector3(localPlayer.position)

        -- scale = DEFAULT_SCALE
        -- if localPlayer.vehicle then
        --     local speed = localPlayer.vehicle.velocity.length
        --     scale = scale - math.min(MAX_SPEED_SCALE, speed * 1)
        -- end

        -- Север
        local direction = math.rad(-camera.rotation.z + 180)
        local blipX, blipY = radarCenterX + math.sin(direction) * radarRadius, radarCenterY + math.cos(direction) * radarRadius
        local blipX = math.max(0, math.min(blipX, radarWidth))
        local blipY = math.max(0, math.min(blipY, radarHeight))
        local blipSize = 28

        dxDrawImage(radarPosX + blipX - blipSize/2, radarPosY + blipY - blipSize/2, blipSize, blipSize, Textures.north, 0, 0, 0, tocolor(255, 255, 255, 255), true)

        -- Рамка
        dxDrawRectangle(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), tocolor(0, 0, 0, 155))

        --dxDrawRectangle(radarPosX, radarPosY + radarCenterY, radarWidth, 1, tocolor(255, 0, 0))
        --dxDrawRectangle(radarPosX + radarCenterX, radarPosY, 1, radarHeight, tocolor(255, 0, 0))

        -- Карта
        local X, Y = radarCenterX - (playerPosition.x/mapZoomScale), radarCenterY + (playerPosition.y/mapZoomScale)
        dxSetRenderTarget(mapRenderTarget)
            dxDrawRectangle(0, 0, radarWidth, radarHeight, tocolor(110, 158, 204))
            dxDrawImage(X - (mapWidth)/2, Y - (mapHeight)/2, mapWidth, mapHeight, Textures.world, camera.rotation.z, playerPosition.x/mapZoomScale, -(playerPosition.y/mapZoomScale), 0xFFFFFFFF)
        dxSetRenderTarget()

        dxSetBlendMode("modulate_add")
            dxDrawImage(radarPosX, radarPosY, radarWidth, radarHeight, mapRenderTarget, 0, 0, 0, tocolor(255, 255, 255, 255))
            drawBlips()
            drawPlayers()
            -- Локальный игрок
            local arrowSize = ARROW_SIZE/1.2
            dxDrawImage(radarPosX + radarCenterX - arrowSize/2, radarPosY + radarCenterY - arrowSize/2, arrowSize, arrowSize, Textures.arrowLocalPlayer, camera.rotation.z-localPlayer.rotation.z, 0, 0)
        dxSetBlendMode("blend")

        -- Урон по игроку
        local animData = getEasingValue(getAnimData('hiteffect'), 'InOutQuad')
        dxDrawImage(radarPosX, radarPosY, radarWidth, radarHeight, Textures.damage, 0, 0, 0, tocolor(186, 58, 58, playerDamageLost*animData))
    end
)

function Radar.calcBlipPos(direction, radius)
    local x, y = radarCenterX + math.sin(direction) * radius, radarCenterY - math.cos(direction) * radius
    local x = math.max(0, math.min(x, radarWidth))
    local y = math.max(0, math.min(y, radarHeight))
    return x, y
end

local function onPlayerStreamIn(player)
    if (player.type ~= "player") then
        return
    end
    streamedPlayer[player] = true
end

local function onPlayerStremOut(player)
    if (player.type ~= "player") then
        return
    end
    streamedPlayer[player] = nil
end

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
    Textures.blipTrucker         = exports.tmtaTextures:createTexture('blipTrucker')
    Textures.blipCheckpoint      = exports.tmtaTextures:createTexture('blipCheckpoint')
    Textures.blipHospital        = exports.tmtaTextures:createTexture('blipHospital')
    Textures.blipBusiness        = exports.tmtaTextures:createTexture('blipBusiness')
    Textures.blipRevenueService  = exports.tmtaTextures:createTexture('blipRevenueService')
    Textures.blipJobLoader       = exports.tmtaTextures:createTexture('blipJobLoader')

    camera = getCamera()
    setAnimData('hiteffect', 0.1)

    for _, player in pairs(getElementsByType("player", true)) do 
        onPlayerStremOut(player)
    end

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
        onPlayerStreamIn(source)
    end
)

addEventHandler("onClientElementStreamOut", root, 
    function()
        onPlayerStremOut(source)
    end
)

addEventHandler("onClientPlayerJoin", root, 
    function()
        if (not isElementStreamedIn(source)) then
            return
        end
	    onPlayerStreamIn(source)
    end
)

addEventHandler("onClientPlayerQuit", root, onPlayerStremOut)