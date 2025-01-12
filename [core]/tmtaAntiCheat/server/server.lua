local function log(message)
    if not message then 
        return 
    end

    outputServerLog(message)
    outputDebugString(message, 4, 255, 127, 0)
    exports.tmtaLogger:log('anticheat', message) 
end

-- @see https://wiki.multitheftauto.com/wiki/OnPlayerTriggerInvalidEvent
addEventHandler('onPlayerTriggerInvalidEvent', root, 
    function(eventName, isAdded, isRemote)

        log(string.format(
            "Kick player %s (nickname: %s, serial: %s), trigger invalid event (eventName: %s, isAdded: %s, isRemote: %s)",
            inspect(source), 
            getPlayerName(source), 
            getPlayerSerial(source) or "N/A",
            eventName, 
            tostring(isAdded), 
            tostring(isRemote)
        ))

        kickPlayer(source, 'AntiCheat')
    end
)

-- @see https://wiki.multitheftauto.com/wiki/OnPlayerTriggerEventThreshold
addEventHandler('onPlayerTriggerEventThreshold', root, 
    function()
        log(string.format(
            "Kick player %s (nickname: %s, serial: %s), exceeded event trigger threshold of %s", 
            inspect(source), 
            getPlayerName(source), 
            getPlayerSerial(source) or "N/A",
            tostring(getServerConfigSetting('max_player_triggered_events_per_interval'))
        ))

        kickPlayer(source, 'AntiCheat')
    end
)

addEvent('tmtaAntiCheat.banPlayer', true)
addEventHandler('tmtaAntiCheat.banPlayer', resourceRoot,
    function(reason)
        reason = reason or 'No reason provided'
        
        log(string.format(
            "Banned client %s (nickname: %s, serial: %s), reason: %s", 
            inspect(client), 
            getPlayerName(client), 
            getPlayerSerial(client) or "N/A",
            reason
        ))

        banPlayer(client, true, false, true, 'AntiCheat', reason)
    end
)

function detectedEventHack(player, eventName)
    if not isElement(player) then
        return
    end

    log(string.format(
        "Kick player %s (nickname: %s, serial: %s), detected event hack `%s`", 
        inspect(player), 
        getPlayerName(player), 
        getPlayerSerial(player) or "N/A",
        eventName or "none"
    ))

    kickPlayer(player, 'AntiCheat')
end

function detectedChangeElementData(player, dataName, oldValue, newValue, resource)
    if not isElement(player) then
        return
    end

    log(string.format(
        "Kick player %s (nickname: %s, serial: %s), tried to change elementdata `%s` of resource `%s` from `%s` to `%s`", 
        inspect(player), 
        getPlayerName(player), 
        getPlayerSerial(player) or "N/A",
        tostring(dataName),
        tostring(resource),
        tostring(oldValue),
        tostring(newValue)
    ))

    kickPlayer(player, 'AntiCheat')
end

addEventHandler('onResourceStart', resourceRoot,
    function()
        setServerConfigSetting('player_triggered_event_interval', '1000', true)
        setServerConfigSetting('max_player_triggered_events_per_interval', '100', true)
    end
)