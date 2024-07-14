CreateBusinessGUI = {}

function CreateBusinessGUI.render()
end

addEvent("tmtaBusiness.openCreateBusinessWindow", true)
addEventHandler("tmtaBusiness.openCreateBusinessWindow", root, CreateHouseGUI.openWindow)