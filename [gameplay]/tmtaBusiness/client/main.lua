addEventHandler("onClientResourceStart", resourceRoot,
    function()
        CreateBusinessGUI.render()
        for _, businessMarker in pairs(getElementsByType('marker', resourceRoot)) do
			Business.onStreamIn(businessMarker)
		end
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        for _, businessMarker in pairs(getElementsByType('marker', resourceRoot)) do
            BusinessBlip.remove(businessMarker)
        end
    end
)