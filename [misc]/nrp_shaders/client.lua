local X, Y = guiGetScreenSize()

local LOCALPLAYER = getLocalPlayer()
local ROOTELEMENT = getRootElement()
local RESROOTELEMENT = getResourceRootElement(getThisResource())

effects = {}
effects.list = { "contrast", "blur", "carpaint", "water", "detail", "skybox" }

function effects.toggle()
    --enableRadialBlur()
    --startCarPaintReflectLite()
end

function effects.toggle1()
    effects.enabled = not effects.enabled
    if effects.enabled then
        enableRadialBlur()
        startCarPaintReflectLite()
        enableWaterShine()
        enableDetail()
        enableLUT()
        enableAO()
        SunShader:enable( )
        triggerEvent( "ToggleSkybox", root, true )
        for i, v in ipairs(effects.list) do
            setElementData(LOCALPLAYER, "shaders." .. v, true, false)
        end
    else
        disableRadialBlur()
        stopCarPaintReflectLite()
        disableWaterShine()
        disableDetail()
        disableContrast()
        triggerEvent( "ToggleSkybox", root, false )
        for i, v in ipairs(effects.list) do
            setElementData(LOCALPLAYER, "shaders." .. v, false, false)
        end
    end
end
addCommandHandler("shaders", effects.toggle1)
--bindKey("k","down","shaders")

function effects.toggle(_, name)
    local tostate = false
    if name == "blur" then
        if getBlurState() then
            disableRadialBlur()
        else
            enableRadialBlur()
            tostate = true
        end
    elseif name == "carpaint" then
        if getCarpaintState() then
            stopCarPaintReflectLite()
        else
            startCarPaintReflectLite()
            tostate = true
        end
    elseif name == "water" then
        if getWaterState() then
            disableWaterShine()
        else
            enableWaterShine()
            tostate = true
        end
    elseif name == "detail" then
        if getDetailState() then
            disableDetail()
        else
            enableDetail()
            tostate = true
        end
    elseif name == "lut" then
        if LUT.enabled then
            disableLUT()
        else
            enableLUT()
            tostate = true
        end
    elseif name == "ssao" then
        if SSAO.enabled then
            disableAO()
        else
            enableAO()
            tostate = true
        end
    elseif name == "sun" then
        if SunShader.enabled then
            SunShader:disable( )
        else
            SunShader:enable( )
            tostate = true
        end
    end
    setElementData(LOCALPLAYER, "shaders." .. name, tostate, false)
end
addCommandHandler("sh", effects.toggle)

function onSettingsChange_handler( changed, values )

    if changed.reflection then
        if getCarpaintState() then stopCarPaintReflectLite() end
        if values.reflection then
            startCarPaintReflectLite()
        end
    end

    if changed.water then
        if getWaterState() then disableWaterShine() end
        if values.water then
            enableWaterShine()
        end
    end

    if changed.blur then
        if getBlurState() then disableRadialBlur() end
        if values.blur then
            enableRadialBlur()
        end
    end

    if changed.ssao then
        if SSAO.enabled then disableAO() end
        if values.ssao then
            enableAO()
        end
    end

    if changed.lut then
        if LUT.enabled then disableLUT() end
        if values.lut then
            enableLUT()
        end
    end

    if changed.sun then
        if SunShader.enabled then SunShader:disable( ) end
        if values.sun then
            SunShader:enable( )
        end
    end
end
addEvent( "onSettingsChange" )
addEventHandler( "onSettingsChange", root, onSettingsChange_handler )

addEventHandler( "onClientResourceStart", resourceRoot, 
    function()
        triggerEvent( "onSettingsUpdateRequest", localPlayer, "reflection" )
    end
)


local _SCREEN_X, _SCREEN_Y = guiGetScreenSize( )

engineSetAsynchronousLoading( false, false )

--[[for i, v in pairs( getElementsByType( "object" ) ) do
    engineSetModelLODDistance( v.model, 280 )
end]]

setBlurLevel( 15 ) -- уменьшение блюр-левела. Дефолт 36
setBirdsEnabled( false ) -- Нахуя нам ПТЫЦЫ? Bekky, lemme smash.
setCloudsEnabled( false ) -- Облака тоже в минус
setOcclusionsEnabled( true ) -- Отрисовка объектов за предметами в минус


-- Расстояние отрисовки
setFarClipDistance( 350 )
setFogDistance( 250 )

local min_distance = 150
local max_distance = 1500

local min_vehdistance = 30
local max_vehdistance = 250

function onSettingsChange_handler( changed, values )
    if changed.drawdistance then
        if values.drawdistance then
            local new_distance = math.floor( min_distance + ( max_distance - min_distance ) * values.drawdistance )
            setFarClipDistance( new_distance )
            setFogDistance( math.floor( new_distance * 0.6 ) )
        end
    end
    if changed.vehdrawdistance then
        if values.vehdrawdistance then
            local new_distance = math.floor( min_vehdistance + ( max_vehdistance - min_vehdistance ) * values.vehdrawdistance )
            setVehiclesLODDistance( new_distance, new_distance * 2.14 )
        end
    end
end
addEventHandler( "onSettingsChange", root, onSettingsChange_handler )

triggerEvent( "onSettingsUpdateRequest", localPlayer, "drawdistance" )
triggerEvent( "onSettingsUpdateRequest", localPlayer, "vehdrawdistance" )


local FADE_DIST = 10
local FADE_START = 5
local WATER_RENDERING

function FuckWater( )

      if not WATER_RENDERING and localPlayer.inWater then
            WATER_RENDERING = true
            addEventHandler( "onClientRender", root, FuckWaterRender, false, "low-999999999999" )
      elseif WATER_RENDERING and not localPlayer.inWater then
            WATER_RENDERING = nil
            removeEventHandler( "onClientRender", root, FuckWaterRender )
      end
end
setTimer( FuckWater, 1000, 0 )

function FuckWaterRender( )
      local px, py, pz = getElementPosition( localPlayer )
      local water_level = getWaterLevel( px, py, pz, true )

      if water_level then
            local dist = water_level - pz - FADE_START

            if dist > 0 then
                  local alpha = math.min( 255, dist / FADE_DIST * 255 )
                  dxDrawRectangle( 0, 0, _SCREEN_X, _SCREEN_Y, tocolor( 0, 0, 0, alpha ) )
            end
      end
end

--Timer( effects.toggle1, 50, 1 )