addEvent(resourceName..".onPlayerSpawn", true)
addEventHandler(resourceName..".onPlayerSpawn", root, 
    function()
        local player = source

        showChat(true)
        toggleAllControls(true)
        guiSetInputMode("allow_binds")

        exports.tmtaUI:setPlayerComponentVisible("all", true)
        exports.tmtaUI:setPlayerDeadScreen(false)

        -- Включение фоновых звуков ветра
        setWorldSoundEnabled(0, 0, true)
        setWorldSoundEnabled(0, 29, true)
        setWorldSoundEnabled(0, 30, true)
    end
)

addEventHandler('onClientPlayerWasted', localPlayer, 
    function()
        exports.tmtaUI:setPlayerComponentVisible("all", false)
        showChat(false)
        exports.tmtaUI:setPlayerDeadScreen(true)
    end
)