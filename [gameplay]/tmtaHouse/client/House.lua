House = {}

-- Вход в дом
function House.enter(houseId)
    if type(houseId) ~= "number" then
        return false
    end
    HouseGUI.closeWindow()
    triggerServerEvent("tmtaHouse.onPlayerHouseEnter", resourceRoot, houseId)

    showChat(false)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end

-- Выход из дома
function House.exit(houseId)
    if type(houseId) ~= "number" then
        return false
    end
    triggerServerEvent("tmtaHouse.onPlayerHouseExit", resourceRoot, houseId)

    showChat(false)
    exports.tmtaUI:setPlayerComponentVisible("all", false)
end

-- Покупка дома
function House.buy(houseId)
    if type(houseId) ~= "number" then
        return false
    end
    HouseGUI.closeWindow()
    triggerServerEvent("tmtaHouse.onPlayerBuyHouse", resourceRoot, houseId)
end

-- Events
addEvent("tmtaHouse.onClientPlayerHouseEnter", true)
addEventHandler("tmtaHouse.onClientPlayerHouseEnter", root,
    function(success)

        showChat(true)
        exports.tmtaUI:setPlayerComponentVisible("all", true)
        exports.tmtaUI:setPlayerComponentVisible("map", false)
    end
)

addEvent("tmtaHouse.onClientPlayerHouseExit", true)
addEventHandler("tmtaHouse.onClientPlayerHouseExit", root,
    function(success)

        showChat(true)
        exports.tmtaUI:setPlayerComponentVisible("all", true)
    end
)

addEvent("tmtaHouse.addHouseResponse", true)
addEventHandler("tmtaHouse.addHouseResponse", root,
    function(success)
        local typeNotice, typeMessage = 'error', 'Ошибка создания дома'
        if success then
            CreateHouseGUI.resetEditBox()
            CreateHouseGUI.closeWindow()
            typeNotice, typeMessage = 'success', 'Дом создан'
        end
        Utils.showNotice(typeNotice, typeMessage)
    end
)