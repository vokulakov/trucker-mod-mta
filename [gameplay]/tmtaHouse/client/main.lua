addEventHandler("onClientResourceStart", resourceRoot,
    function()
        CreateHouseGUI.render()
        HouseBlip.update()
        HouseMarker.init()
    end
)