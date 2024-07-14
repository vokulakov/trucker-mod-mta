local function dataBaseConnect()
    if not exports.tmtaSQLite:dbConnect() then -- подключение базы данных 
        outputDebugString("ERROR: Database connection failed")
        stopResource(getResourceFromName("tmtaStartup"))
        return false
    end

    outputDebugString("Database connection success")

    return true
end

addEventHandler('onResourceStart', resourceRoot,
    function()
        if (dataBaseConnect()) then
            local ServerConfig = Config.SERVER

            setMapName(ServerConfig.MAP_NAME)
            setGameType(ServerConfig.GAME_TYPE)
            setServerPassword(ServerConfig.SERVER_PASSWORD)
            
            root:setData('ServerMaxPlayers', getMaxPlayers())
            root:setData('ServerInfo', ServerConfig)

            User.setup()
            outputDebugString("Server started!")
        end
    end
)

addEventHandler("onResourceStop", resourceRoot, 
    function ()
        for _, player in ipairs(getElementsByType("player")) do
            User.logout(player)
        end
    
        exports.tmtaSQLite:dbDisconnect()
        stopResource(getResourceFromName("tmtaStartup"))
    
        outputDebugString("Server stop!")
    end
)