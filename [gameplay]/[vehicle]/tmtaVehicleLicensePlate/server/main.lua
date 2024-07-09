addEventHandler('onResourceStart', resourceRoot,
    function()
        LicensePlate.setup()
        LicensePlate.getInaccessibleLicensePlates()
        LicensePlate.getLicensePlates()
    end
)

addEventHandler('tmtaCore.register', root,
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end
        LicensePlateStorage.setPlayerDefaultSlot(player)
    end
)

addEventHandler('tmtaCore.login', root, 
    function(success)
        local player = source
        if (not success or not isElement(player)) then
            return
        end
        LicensePlateStorage.setPlayerDefaultSlot(player)
    end
)

addEventHandler('tmtaServerTimecycle.onServerMinutePassed', root, 
    function()
        local currentTimestamp = getRealTime().timestamp
        for licensePlateId, licensePlate in pairs(LicensePlate.getLicensePlates()) do
            if (licensePlate.userId and licensePlate.inStorage and licensePlate.deleteAt) then
                if (currentTimestamp >= licensePlate.deleteAt) then
                    LicensePlateStorage.deleteUserLicensePlate(licensePlate.userId, licensePlateId)
                end
            end
        end
    end
)