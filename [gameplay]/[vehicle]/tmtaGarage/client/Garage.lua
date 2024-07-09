Garage = {}

addEvent('tmtaGarage.onClientUpdateGarageSlotCount', true)

addEvent('tmtaGarage.onPlayerVehiclesUpdate', true)
addEventHandler('tmtaGarage.onPlayerVehiclesUpdate', resourceRoot,
    function(playerVehicles)
        GarageGUI.updateVehicleList(playerVehicles)
    end
)

function Garage.spawnVehicle(vehicle)
    if (not vehicle or type(vehicle) ~= 'table') then
        return false
    end
    GarageGUI.setVisible(false)
    triggerServerEvent('tmtaGarage.spawnVehicle', resourceRoot, vehicle)
end

function Garage.destroyVehicle(vehicle)
    if (not vehicle or type(vehicle) ~= 'table') then
        return false
    end
    GarageGUI.setVisible(false)
    triggerServerEvent('tmtaGarage.destroyVehicle', resourceRoot, vehicle)
end

function Garage.sellVehicle(vehicle)
    if (not vehicle or type(vehicle) ~= 'table') then
        return false
    end
    GarageGUI.setVisible(false)
    triggerServerEvent('tmtaGarage.sellVehicle', resourceRoot, vehicle)
end

function Garage.returnVehiclesToGarage()
    GarageGUI.setVisible(false)
    triggerServerEvent('tmtaGarage.returnVehiclesToGarage', resourceRoot)
end