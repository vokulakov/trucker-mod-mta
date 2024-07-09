addEventHandler("onClientResourceStart", resourceRoot,
    function()
        CreateBusinessGUI.render()
        BusinessBlip.init()
        BusinessMarker.init()
    end
)

addEventHandler('tmtaCore.onClientPlayerLogin', root,
    function(success)
        if (not success) then
            return
        end
        BusinessBlip.init()
    end
)