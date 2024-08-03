VehicleShop = {}

function VehicleShop.getVehicleID()
    local db = Database.getConnection()
    if not db then 
        return false 
    end 
    local result = dbPoll(dbQuery(db, "SELECT ID FROM "..VEHICLES_TABLE_NAME.." ORDER BY ID ASC"), -1)
	return #result + 1
end 

function VehicleShop.addPlayerVehicle(model, cost, r1, g1, b1, r2, g2, b2)
    local player = source
    local carName = customCarNames[model] or getVehicleNameFromModel(model)

    local vehicles = Garage.getPlayerVehicles(player)
    if not vehicles then 
        return
    end

    local limit = Garage.getLimitVehiclesPlayer(player)
    if #vehicles >= limit then
		exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AАвтосалон", 
            "У вас нет мест в гараже, чтобы увеличить кол-во мест купите дом", 
            _, 
            {240, 146, 115}
        )
		return
	end

    if exports.tmtaMoney:getPlayerMoney(player) < tonumber(cost) then
        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AАвтосалон", 
            "У вас нехватает денежных средств для покупки #FFA07A"..carName, 
            _, 
            {240, 146, 115}
        )
        return
    end 

    local db = Database.getConnection()
    if not db then 
        return
    end 

    local ID = VehicleShop.getVehicleID()
    local account = getAccountName(getPlayerAccount(player))
    local Date = tostring(os.date("%d.%m.%Y"))

    -- Цвет
    local color = r1..","..g1..","..b1..","..r2..","..g2..","..b2
    local Colors = {tostring(color), ""}

    -- Номерной знак
    -- @string (JSON)
    local number = exports.tmtaVehNumbers:giveTransitNumber(ID, model)

    if not number then 
        return 
    end 
    
    dbExec(db, "INSERT INTO "..VEHICLES_TABLE_NAME.." VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
        ID, 
        account, 
        Date, 
        model, 
        cost,
        0,          -- пробег
        50,         -- топливо
        1000,       -- состояние
        "",         -- handlings
        toJSON(number),         -- номерной знак
        toJSON(Colors),         -- цвет
        "",         -- тонеровка
        "",         -- тюнинг
        "",
        "",
        ""
    )
   
    Garage.updatePlayerVehiclesInfo(player)

    exports.tmtaMoney:takePlayerMoney(player, cost)

    exports.tmtaNotification:showInfobox(
        player, 
        "info", 
        "#FFA07AАвтосалон", 
        "Поздравляем! Вы приобрели #FFA07A"..carName.." #FFFFFFза #FFA07A"..convertNumber(cost).." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )
    
    -- Выход из автосалона
	triggerClientEvent(player, "tmtaVehCarshop.exitCarDealership", player)
end

addEvent("tmtaVehCarshop.onBuyVehicle", true)
addEventHandler("tmtaVehCarshop.onBuyVehicle", root, VehicleShop.addPlayerVehicle)

