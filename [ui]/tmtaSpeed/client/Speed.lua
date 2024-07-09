Speed = {}
Speed.visible = false

local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local width, height
local posX, posY

local Textures = {}
local Fonts = {}
local Shaders = {}

local ControlList = {
    { 
        key = '1', 
        texture = 'i_engine_', 
        get = function(vehicle)
            if not isElement(vehicle) then
                return false
            end
            return vehicle.engineState
        end
    },

    { 
        key = 'J', 
        texture = 'i_door_',
        get = function(vehicle)
            if not isElement(vehicle) then
                return false
            end
            return vehicle.locked
        end
    },

    { 
        key = 'L', 
        texture = 'i_light_',
        get = function(vehicle)
            if not isElement(vehicle) then
                return false
            end
            return vehicle.overrideLights == 2
        end
    },

    { 
        key = 'c', 
        texture = 'i_cruise_',
        get = function(vehicle)
            if not isElement(vehicle) then
                return false
            end
            return vehicle:getData("vehicle.cruiseSpeedEnabled") or false
        end 
    },
}

-- Форматирование скорости
local function getFormatedSpeedString(unit)
    if unit < 10 then
        unit = "#5E5E5E00#FFFFFF" .. unit
	elseif unit < 100 then
		unit = "#5E5E5E0#FFFFFF" .. unit
	elseif unit < 1000 then
		unit = "" .. unit
    end
    return unit
end

-- Форматирование пробега
local function getFormatedMileageString(unitKm, unitM)
    local formated = string.format("%06d", unitKm)
    local pos = formated:find('[1-9]') or 0
    local left = pos > 0 and formated:sub(0, pos-1) or formated:sub(0, formated:len() - 1)
    local right = pos > 0 and formated:sub(pos) or "0"
    return "#5E5E5E"..left.."#FFFFFF"..right.."#FFAA05"..unitM
end

-- Обороты двигателя (GTA:SA)
local function getVehicleRPM(vehicle)
    if not isElement(vehicle) or not getVehicleEngineState(vehicle) then
        return 0
    end
    local vehicleRPM = 0
    local currentSpeed = getDistanceBetweenPoints3D(0, 0, 0, getElementVelocity(vehicle)) * 180
    if getVehicleCurrentGear(vehicle) > 0 then             
        vehicleRPM = math.floor(((currentSpeed / getVehicleCurrentGear(vehicle)) * 160) + 0.5) 
    else
        vehicleRPM = math.floor((currentSpeed * 160) + 0.5)
    end
    if (vehicleRPM < 650) then
        vehicleRPM = math.random(650, 750) -- Когда машина стоит, обороты будут колебаться от 650 до 750, их можно менять
    elseif (vehicleRPM >= 9000) then
        vehicleRPM = math.random(9000, 9900) -- Максимальное количество оборотов
    end
    return tonumber(vehicleRPM)
end

function Speed.draw()
    if not Speed.visible or not exports.tmtaUI:isPlayerComponentVisible("speedometer") then
        return
    end

    local veh = getPedOccupiedVehicle(localPlayer) 
    if not veh or getVehicleOccupant(veh) ~= localPlayer then 
        return 
    end

    -- BACKGROUND
    dxDrawImage(sW*((sDW-1920) /sDW), sH*((sDH-1080) /sDH), sW*((1920) /sDW), sH*((1080) /sDH), Textures.background, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxSetTextureEdge(Textures.bg_speed, "clamp")
    dxDrawImage(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), Textures.bg_speed, 0, 0, 0, tocolor(255, 255, 255, 255))

    -- LAUNCH_CONTROL
    --dxSetTextureEdge(Textures.i_launch, "clamp")
    --dxDrawImage(sW*((posX+(width-95)/2) /1280), sH*((posY+61) /720), sW*((95) /1280), sH*((21) /720), Textures.i_launch, 0, 0, 0, tocolor(255, 255, 255, 255), false)

    -- Скорость
    local currentSpeed = getDistanceBetweenPoints3D(0, 0, 0, getElementVelocity(veh)) * 180 -- в км
    local speedFormated = getFormatedSpeedString(math.floor(currentSpeed))
    dxDrawText(speedFormated, sW*((posX) /sDW), sH*((posY+76) /sDH), sW*((posX+width) /sDW), sH*((posY+height) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.GPM_36, "center", "top", false, false, false, true)
    dxDrawText("КМ/Ч", sW*((posX) /sDW), sH*((posY+136) /sDH), sW*((posX+width) /sDW), sH*((posY+height) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.GPM_7, "center", "top", false, false, false, true)
    
    -- Racelogic
    --Racelogic.draw(posX+width, posY, math.floor(currentSpeed))

    -- Тахометр
    if veh.engineState then
        local rpm = exports.bengines:getVehicleRPM(veh) or getVehicleRPM(veh)
        local rot = 5.65 * exports.tmtaUtils:lerp(0, 1, rpm/9000)

        local currentThCircle = Textures.th_circle1

        if rot >= 1.2 and rot <= 2.35 then 
            currentThCircle = Textures.th_circle2
        elseif rot >= 2.35 and rot <= 3.4 then 
            currentThCircle = Textures.th_circle3
        elseif rot >= 3.4 and rot <= 4.5 then
            currentThCircle = Textures.th_circle4
        elseif rot >= 4.5 and rot <= 5.65 then 
            currentThCircle = Textures.th_circle5
        end
        dxSetTextureEdge(currentThCircle, "clamp")
        Shaders.tahometr:setValue("sPicTexture", currentThCircle)
        Shaders.tahometr:setValue("gUVRotAngle", -rot)
        
        dxDrawImage(sW*((posX+width-254) /sDW), sH*((posY+height-249) /sDH), sW*((254) /sDW), sH*((249) /sDH), Shaders.tahometr, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end

    -- FUEL
    local vehicleFuel = veh:getData('exv_fuelSystem.fuel') or 0
	local vehicleFuelMax = veh:getData('exv_fuelSystem.fuelMax') or 0
    local currentFuel = (vehicleFuel/vehicleFuelMax)
    Shaders.fuel:setValue("gUVRotAngle", 1-currentFuel)
    dxSetTextureEdge(Textures.fuel_circle, "clamp")
    dxDrawImage(sW*((posX+width-248-3) /sDW), sH*((posY+height-246) /sDH), sW*((248) /sDW), sH*((246) /sDH), Shaders.fuel, 0, 0, 0, tocolor(56, 137, 255, 255))
    dxDrawText(string.format("%.f%%",currentFuel*100), sW*((posX) /sDW), sH*((posY) /sDH), sW*((posX+width) /sDW), sH*((posY+height-15) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.GPB_7, "left", "bottom", false, false, false, true)

    -- NOS
    local nosSeconds = veh:getData('nitro.seconds') or 0	
	local maxNos = veh:getData('nitro.seconds.max') or 7000	
    local currentNos = (nosSeconds/maxNos)
    Shaders.nos:setValue("gUVRotAngle", -1+currentNos)
    local nosColor = tocolor(255, 255, 255, 255) --tocolor(255, 255*currentNos, 255*currentNos, 255)
    dxSetTextureEdge(Textures.nos_circle, "clamp")
    dxDrawImage(sW*((posX+width-248-3) /sDW), sH*((posY+height-246) /sDH), sW*((248) /sDW), sH*((246) /sDH), Shaders.nos, 0, 0, 0, nosColor, false)
    dxDrawText(string.format("%.f%%",currentNos*100), sW*((posX) /sDW), sH*((posY) /sDH), sW*((posX+width) /sDW), sH*((posY+height-15) /sDH), nosColor, sW/sDW*1.0, Fonts.GPB_7, "right", "bottom", false, false, false, true)

    -- Контроль панель
    local controlPosX = posX+68
    local controlPosY = posY+height-50-42
    for _, control in pairs(ControlList) do
        local state = control.get(veh) and 'on' or 'off'
        
        dxSetTextureEdge(Textures[control.texture..state], "clamp")
        dxDrawImage(sW*((controlPosX) /sDW), sH*((controlPosY) /sDH), sW*((27) /sDW), sH*((42) /sDH), Textures[control.texture..state], 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(control.key, sW*((controlPosX) /sDW), sH*((controlPosY-7) /sDH), sW*((controlPosX+27) /sDW), sH*((controlPosY+42) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.GPM_7, "center", "bottom", false, false, false, true)
        
        controlPosX = controlPosX + 27 + 3
    end

    -- Пробег
    local currentMileage = veh:getData("mileage")
    if currentMileage then
        local mileageFormated = getFormatedMileageString(math.floor(currentMileage.km), math.floor(currentMileage.m/100))
        dxDrawText(mileageFormated, sW*((posX) /sDW), sH*((posY) /sDH), sW*((posX+width) /sDW), sH*((posY+height-27.5+5) /sDH), tocolor(255, 255, 255, 255), sW/sDW*1.0, Fonts.GPM_9, "center", "bottom", false, false, false, true)
    end

    -- Поворотники
    local vehicleTurnlights = veh:getData("turnlight")
    local turnAlpha = getAnimData('turn-alpha')
    local turnLeftColor = (vehicleTurnlights == 1 or vehicleTurnlights == 3) and tocolor(255, 170, 5, 255*turnAlpha) or tocolor(248, 245, 236, 75)
    local turnRightColor = (vehicleTurnlights == 2 or vehicleTurnlights == 3) and tocolor(255, 170, 5, 255*turnAlpha) or tocolor(248, 245, 236, 75)
    local turnLeftTexture = (vehicleTurnlights == 1 or vehicleTurnlights == 3) and Textures.i_turn_on or Textures.i_turn_off
    local turnRightTexture = (vehicleTurnlights == 2 or vehicleTurnlights == 3) and Textures.i_turn_on or Textures.i_turn_off
    dxSetTextureEdge(turnLeftTexture, "clamp")
    dxSetTextureEdge(turnRightTexture, "clamp")
    dxDrawImage(sW*((posX+70-5) /sDW), sH*((posY+height-47+5) /sDH), sW*((24) /sDW), sH*((24) /sDH), turnLeftTexture, 0, 0, 0, turnLeftColor, false)
    dxDrawImage(sW*((posX+width-70-24+5) /sDW), sH*((posY+height-47+5) /sDH), sW*((24) /sDW), sH*((24) /sDH), turnRightTexture, 180, 0, 0, turnRightColor, false)
end

function Speed.start()

    width, height = 254, 249
    posX, posY = sDW-254-20, sDH-249-25

    Textures = {
        background      = dxCreateTexture('assets/images/bg_shadow.png'),
        bg_speed        = dxCreateTexture('assets/images/bg_speed.png'),

        i_launch        = dxCreateTexture('assets/images/i_launch.png'),
        i_turn_off      = dxCreateTexture('assets/images/i_turn_off.png'),
        i_turn_on       = dxCreateTexture('assets/images/i_turn_on.png'),

        i_engine_off    = dxCreateTexture('assets/images/i_engine_off.png'),
        i_engine_on     = dxCreateTexture('assets/images/i_engine_on.png'),
        i_cruise_off    = dxCreateTexture('assets/images/i_cruise_off.png'),
        i_cruise_on     = dxCreateTexture('assets/images/i_cruise_on.png'),
        i_door_off      = dxCreateTexture('assets/images/i_door_off.png'),
        i_door_on       = dxCreateTexture('assets/images/i_door_on.png'),
        i_light_off     = dxCreateTexture('assets/images/i_light_off.png'),
        i_light_on      = dxCreateTexture('assets/images/i_light_on.png'),

        th_mask         = dxCreateTexture('assets/images/th_mask.png'),
        th_circle1      = dxCreateTexture('assets/images/th_circle1.png'),
        th_circle2      = dxCreateTexture('assets/images/th_circle2.png'),
        th_circle3      = dxCreateTexture('assets/images/th_circle3.png'),
        th_circle4      = dxCreateTexture('assets/images/th_circle4.png'),
        th_circle5      = dxCreateTexture('assets/images/th_circle5.png'),

        nos_mask        = dxCreateTexture('assets/images/nos_mask.png'),
        nos_circle      = dxCreateTexture('assets/images/nos_circle.png'),

        fuel_mask       = dxCreateTexture('assets/images/fuel_mask.png'),
        fuel_circle     = dxCreateTexture('assets/images/fuel_circle.png'),
    }

    Fonts = {
        GPM_36  = exports.tmtaFonts:createFontDX('GothamProMedium', 36),
        GPM_7   = exports.tmtaFonts:createFontDX('GothamProMedium', 7.5),
        GPM_9   = exports.tmtaFonts:createFontDX('GothamProMedium', 9),
        GPB_7   = exports.tmtaFonts:createFontDX('GothamProBold', 7.5),
    }

    Shaders = {
        tahometr   = exports.tmtaShaders:createShader('mask3d'),
        fuel        = exports.tmtaShaders:createShader('mask3d'),
        nos         = exports.tmtaShaders:createShader('mask3d'),
    }

    Shaders.tahometr:setValue("sMaskTexture", Textures.th_mask)

    Shaders.nos:setValue("sMaskTexture", Textures.nos_mask)
	Shaders.nos:setValue("sPicTexture", Textures.nos_circle)

    Shaders.fuel:setValue("sMaskTexture", Textures.fuel_mask)
	Shaders.fuel:setValue("sPicTexture", Textures.fuel_circle)

    addEventHandler("onClientHUDRender", root, Speed.draw)
end
addEventHandler("onClientResourceStart", resourceRoot, Speed.start)

local function vehicleTurnlightAnim()
    setAnimData('turn-alpha', 0.1, 0)
    animate('turn-alpha', 1, function()
        setTimer(function()
            vehicleTurnlightAnim()
        end, 500, 1)
    end)
end

addEventHandler("onClientVehicleEnter", root, 
    function(player, seat)
        if player == localPlayer and seat == 0 then
            Speed.visible = true
            vehicleTurnlightAnim()
        end
    end
)

addEventHandler("onClientVehicleStartExit", root, 
    function(player, seat)
        if player == localPlayer and seat == 0 then
            Speed.visible = false
        end
    end
)

addEventHandler("onClientElementDestroy", root, 
    function()
	    if getElementType(source) ~= "vehicle" or getPedOccupiedVehicle(localPlayer) ~= source then
            return
        end
		Speed.visible = false
    end
)

addEventHandler("onClientPlayerWasted", localPlayer, 
    function()
	    if not getPedOccupiedVehicle(source) then 
            return 
        end
	    Speed.visible = false
    end
)