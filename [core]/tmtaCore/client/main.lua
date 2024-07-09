-- Информация о моде в нижнем правом углу
local function showModInfo()
    local sX, sY = guiGetScreenSize()
    local INFO = guiCreateLabel(sX-205, sY-30, 200, 20, Config.SERVER.MOD_INFO, false)
    guiLabelSetHorizontalAlign(INFO, "right")
    --guiLabelSetColor(INFO, 255, 255, 255)
    guiSetEnabled(INFO, false)
    guiSetAlpha(INFO, 0.5)
end 

-- Установка свойств окружающего мира
local function setWorldProperties()
    -- Отключение фоновых звуков стрельбы
	setWorldSoundEnabled(5, false)

	-- Отключение фоновых звуков ветра
	setWorldSoundEnabled(0, 0, false, true)
	setWorldSoundEnabled(0, 29, false, true)
	setWorldSoundEnabled(0, 30, false, true)

    -- https://wiki.multitheftauto.com/wiki/SetCoronaReflectionsEnabled
    setCoronaReflectionsEnabled(2)
    setColorFilter(65, 65, 65, 255, 0, 64, 146, 64)

    -- Отключение размытия при движении
	setBlurLevel(0)

    setWaterColor(11, 111, 231, 150)
    setWaveHeight(2)

    -- Отключение растительности (тип трава всякая)
    setWorldSpecialPropertyEnabled("randomfoliage", false)

    -- Отключение скрытия объектов
	setOcclusionsEnabled(false)
end

local function onStartResource()
    -- Скрытие чата
    --outputChatBox(('\n'):rep(getChatboxLayout("chat_lines")))
	--showChat(false) 
	-- Скрытие HUD
	--setPlayerHudComponentVisible("all", false)
	--setPlayerHudComponentVisible("crosshair", true)

    -- Отключение клавиатуры
	toggleAllControls(false, true, true)
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        onStartResource()
        showModInfo()
        setWorldProperties()
    end
)