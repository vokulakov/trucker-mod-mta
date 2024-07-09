addEventHandler('onClientResourceStart', resourceRoot,
    function()
        CreateHouseGUI.render()
        HouseBlip.init()
        HouseMarker.init()
    end
)

addEventHandler('tmtaCore.onClientPlayerLogin', root,
    function(success)
        if (not success) then
            return
        end
        HouseBlip.init()
    end
)