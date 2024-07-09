addEvent(resourceName..".onPlayerSpawn", true)
addEventHandler(resourceName..".onPlayerSpawn", root, function()
    local player = source

    toggleAllControls(true, true, true)
    showChat(true)

    exports.tmtaUI:setPlayerComponentVisible("all", true)

    -- Включение фоновых звуков ветра
    setWorldSoundEnabled(0, 0, true)
	setWorldSoundEnabled(0, 29, true)
	setWorldSoundEnabled(0, 30, true)
end)