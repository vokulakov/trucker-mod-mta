Garage = {}

local componentsFromData

addEventHandler("onResourceStart", resourceRoot,
    function()
        componentsFromData = exports.tmtaVehTuning:getComponents()
    end
)

addEvent("onVehicleCreated", true)

-- TODO:: костыль из системы колес 
local wheelsFromData = {
	["WheelsWidthF"] 	= true,
	["WheelsWidthR"] 	= true,
	["WheelsAngleF"] 	= true,
	["WheelsAngleR"] 	= true,
	["Wheels"] 			= true,
	["WheelsF"] 		= true,
	["WheelsR"] 		= true,
	["WheelsSize"] 		= true,
	["WheelsColorR"] 	= true,
	["WheelsColorF"] 	= true,
	["WheelsOutF"]      = true,
	["WheelsOutR"]      = true,
}

function Garage.spawnVehicle(id)
    if type(id) ~= 'number' then 
        return
    end

    local player = source

    local dataVehicle = Garage.getPlayerVehicle(player, id)
    if not dataVehicle then 
        return
    end

    local carName = customCarNames[dataVehicle['model']] or getVehicleNameFromModel(dataVehicle['model'])

    local vehicle = Garage.getVehicleByID(id)

    if isElement(vehicle) then 

        local px, py, pz = getElementPosition(player)
        local _, _, prot = getElementRotation(player)
        local posVector = Vector3(px+2, py+2, pz+1.5)
        local rotVector = Vector3(0, 0, prot)

        vehicle.position = posVector
        vehicle.rotation = rotVector
        
        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "", 
            "#FFA07A"..carName.." #FFFFFFдоставлен", 
            _, 
            {240, 146, 115}
        )
        return
    end

    local px, py, pz = getElementPosition(player)
	local _, _, prot = getElementRotation(player)
	local posVector = Vector3(px+2, py+2, pz+1.5)
	local rotVector = Vector3(0, 0, prot)

    vehicle = Vehicle(dataVehicle['model'], posVector, rotVector)

    vehicle.interior = source.interior
	vehicle.dimension = source.dimension
	
    if vehicle.vehicleType == "Bike" then vehicle.velocity = Vector3(0, 0, -0.01) end

    setVehicleOverrideLights(vehicle, 1) -- отключаем фары, чтобы при смене времени автоматические не загорались
	setVehicleEngineState(vehicle, false)

	local colSphere = createColSphere(px, py, pz, 20.0) 
	attachElements(colSphere, vehicle, 0, 0, 0)
    
    -- Handlings
    local handlings = fromJSON(dataVehicle['handlings'])
    for key,value in pairs(handlings or {}) do
        setVehicleHandling(vehicle, key, value)
    end
    
    -- Numbers
    local numbers = fromJSON(dataVehicle["number"])
    --outputDebugString( "Vehicle created with numbers: "..tostring(numbers[1]).." | "..tostring(numbers[2]))
    if numbers then
        setElementData(vehicle,"numberType", numbers[1])
        setElementData(vehicle,"number:plate", numbers[2])
    end

    -- Tuning 
	local tuning = fromJSON(dataVehicle["tuning"])
    if tuning then
        for key,value in pairs(tuning) do
            setElementData(vehicle, key, value)
        end
    end

    -- Колеса
    local wheels = fromJSON(dataVehicle['wheels'])
    if wheels then 
        for key, value in pairs(wheels) do
            setElementData(vehicle, key, value)
        end
    end 

    -- Покраска
    local Colors = fromJSON(dataVehicle['colors'])

    local color = split(Colors[1], ',')
    setVehicleColor(vehicle, color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 255, color[5] or 255, color[6] or 255)

    if Colors[2] then
        setElementData(vehicle, "colorType", Colors[2])
        if Colors[3] then
            local colorRGB = split(Colors[3], ',')
            setElementData(vehicle, "colorTypeRGB", 
                {
                    colorRGB[1],
                    colorRGB[2],
                    colorRGB[3]
                }
            )
        end
    end

    -- Toner
    local toner = fromJSON(dataVehicle["toner"])
    if toner then
       setElementData(vehicle, "toner", toner)
    end

     -- Xenon
    local headlight = fromJSON(dataVehicle["headlight"]) or {}
    if headlight[1] then
        vehicle:setData("vehicle.vehLightColor", headlight)
    end 

    -- Сигнал
    if dataVehicle["horn"] and tonumber(dataVehicle["horn"]) ~= 0 then
        vehicle:setData('vehicle.isHorn', dataVehicle["horn"]) 
    end

    -- Data
    vehicle:setData("ID", id)
    vehicle:setData("colsphere", colSphere)
    vehicle:setData("owner", player)
    vehicle:setData("mileage", fromJSON(dataVehicle['mileage']))
    vehicle:setData("exv_fuelSystem.fuel", dataVehicle['fuel'])

    setElementHealth(vehicle, tonumber(dataVehicle['health']))

    triggerEvent("onVehicleCreated", vehicle)
	triggerClientEvent(root, "onClientVehicleCreated", vehicle)

    exports.tmtaNotification:showInfobox(
        player, 
        "info", 
        "", 
        "#FFA07A"..carName.." #FFFFFFзаспавнен", 
        _, 
        {240, 146, 115}
    )

end

addEvent("tmtaVehCarshop.spawnPlayerVehicle", true)
addEventHandler("tmtaVehCarshop.spawnPlayerVehicle", root, Garage.spawnVehicle)

function Garage.destroyVehicle(vehicle)
    if not isElement(vehicle) then 
        return false
    end

    local ID = vehicle:getData("ID")
    local mileage = vehicle:getData("mileage")
    local health = getElementHealth(vehicle)

    local owner = vehicle:getData("owner")
    if not isElement(owner) then
        return
    end 

    local account = getPlayerAccount(owner)
    if not account then
        return
    end

    local db = Database.getConnection()
    if not db then 
        return
    end 

    -- Handlings 
    local handlings = getVehicleHandling(vehicle)
    

    -- Тюнинг
    local Tuning = {}
    for name, comp in pairs(componentsFromData) do
        Tuning[name] = getElementData(vehicle, name)
    end 

    -- Колеса
    local Wheels = {}
    for wheel_data_name in pairs(wheelsFromData) do
        Wheels[wheel_data_name] = vehicle:getData(wheel_data_name)
    end

    -- Покраска
    local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
    local color = r1..","..g1..","..b1..","..r2..","..g2..","..b2

    local Colors = {
        tostring(color),
        tostring(getElementData(vehicle, 'colorType') or 0),
        tostring(getElementData(vehicle, 'colorTypeRGB') or false)
    }

    -- Fuel
    local fuel = getElementData(vehicle, 'exv_fuelSystem.fuel') or 50

    -- Number
    local realnumber = {false, false}
    if getElementData(vehicle, "numberType") then
        realnumber = {getElementData(vehicle,"numberType"), getElementData(vehicle, "number:plate")}
    end
    
    -- Toner
    local Toner = getElementData(vehicle, "toner") or {}

    -- Xenon
    local Headlight = vehicle:getData('vehicle.vehLightColor') or {}

    -- Сигнал
    local Horn = vehicle:getData('vehicle.isHorn')

    dbExec(db, "UPDATE "..VEHICLES_TABLE_NAME.." SET mileage = ?, fuel = ?, health = ?, handlings = ?, number = ?, colors = ?, tuning = ?, headlight = ?, wheels = ?, toner = ?, horn = ? WHERE account = ? AND ID = ?", 
        toJSON(mileage),
        fuel,
        health,
        toJSON(handlings),
        toJSON(realnumber),
        toJSON(Colors),
        toJSON(Tuning),
        toJSON(Headlight),
        toJSON(Wheels),
        toJSON(Toner),
        Horn,
        getAccountName(account),
        ID 
    )

    local colSphere = vehicle:getData("colsphere")
    destroyElement(colSphere)
    destroyElement(vehicle)

    return true
end 

addEvent("tmtaVehCarshop.destroyPlayerVehicle", true)
addEventHandler("tmtaVehCarshop.destroyPlayerVehicle", root, function(id)
    if type(id) ~= 'number' then 
        return
    end

    local player = source 

    local vehicle = Garage.getVehicleByID(id)
    local dataVehicle = Garage.getPlayerVehicle(player, id)
    if not dataVehicle then 
        return
    end
    local carName = customCarNames[dataVehicle['model']] or getVehicleNameFromModel(dataVehicle['model'])

    if not isElement(vehicle) then
        exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "", 
            "#FFA07A"..carName.." #FFFFFFне заспавнен", 
            _, 
            {240, 146, 115}
        )
        return
    end
    
    if not Garage.destroyVehicle(vehicle) then
        return
    end 

    Garage.updatePlayerVehiclesInfo(player)

    exports.tmtaNotification:showInfobox(
        player, 
        "info", 
        "", 
        "#FFA07A"..carName.." #FFFFFFубран", 
        _, 
        {240, 146, 115}
    )
end)

addEvent("tmtaVehCarshop.destroyPlayerAllVehicles", true)
addEventHandler("tmtaVehCarshop.destroyPlayerAllVehicles", root, function()
    local player = source
    if not isElement(player) then 
        return
    end 

    for _, vehicle in ipairs(getElementsByType("vehicle")) do
		if getElementData(vehicle, "owner") == player then
			Garage.destroyVehicle(vehicle)
		end
	end

    Garage.updatePlayerVehiclesInfo(player)
end)

addEvent("tmtaVehCarshop.sellPlayerVehicle", true)
addEventHandler("tmtaVehCarshop.sellPlayerVehicle", root, function(id)
    if type(id) ~= 'number' then 
        return
    end

    local player = source 

    local account = getPlayerAccount(player)
    if not account then
        return
    end

    local db = Database.getConnection()
    if not db then 
        return
    end 

    local vehicle = Garage.getVehicleByID(id)
    if isElement(vehicle) then 
        Garage.destroyVehicle(vehicle)
    end 

    local vehicle_data = Garage.getPlayerVehicle(player, id)
    if not vehicle_data then
        return 
    end 
    local carName = customCarNames[vehicle_data['model']] or getVehicleNameFromModel(vehicle_data['model'])

    local price = vehicle_data["price"] or 0

    local money = math.ceil(price*.7)
	exports.tmtaMoney:givePlayerMoney(player, money)

    exports.tmtaNotification:showInfobox(
        player, 
        "info", 
        "#FFA07AУведомление", 
        "Вы продали #FFA07A"..carName.." #FFFFFFза #FFA07A"..convertNumber(money).." #FFFFFF₽", 
        _, 
        {240, 146, 115}
    )
		
    dbExec(db, "DELETE FROM "..VEHICLES_TABLE_NAME.." WHERE account = ? AND ID = ?", getAccountName(account), id)

    Garage.updatePlayerVehiclesInfo(player)
end)

-- Возвращает список ТС игрока
function Garage.getPlayerVehicles(player)
    if not isElement(player) then
        return false
    end 

    local account = getPlayerAccount(player)
    if not account then 
        return false 
    end

    local db = Database.getConnection()
    if not db then 
        return
    end 

    return dbPoll(dbQuery(db, "SELECT * FROM "..VEHICLES_TABLE_NAME.." WHERE account = ?", getAccountName(account)), -1)
end

-- Получить ТС игрока по ID
function Garage.getPlayerVehicle(player, id)
    if not isElement(player) or type(id) ~= 'number' then
        return false
    end 

    local account = getPlayerAccount(player)
    if not account then 
        return false 
    end

    local db = Database.getConnection()
    if not db then 
        return
    end 

    local vehicle = dbPoll(dbQuery(db, "SELECT * FROM "..VEHICLES_TABLE_NAME.." WHERE account = ? AND ID = ?", getAccountName(account), id), -1)
	if type(vehicle) ~= "table" or #vehicle == 0 then
        return false
    end 

    return vehicle[1]
end

-- обновить список транспорта для игрока
function Garage.updatePlayerVehiclesInfo(player)
    if not isElement(player) then 
        return
    end
    local vehicles = Garage.getPlayerVehicles(player)
    local parking_lots = Garage.getLimitVehiclesPlayer(player)
    if type(vehicles) == "table" then
        triggerClientEvent(player, "tmtaVehCarshop.onPlayerUpdateVehicles", player, vehicles, parking_lots)
    end
end 

-- Возвращает количество свободных мест 
function Garage.getLimitVehiclesPlayer(player)
    local account = getAccountName(getPlayerAccount(player))
    if not account then 
        return
    end 

    local house_parking_lots = player:getData("garageSlots") or 0

    -- TODO: временное решение. Нужно сделать нормальную систему выдачи слота
    local lvl = exports.tmtaExperience:getPlayerLvl(player)

    return (lvl > 3) and house_parking_lots + 3 + 1 or house_parking_lots + lvl + 1
end

-- TODO: сделать выдачу парковочных мест, чтобы можно было покупать за донат

-- Utils
-- TODO: вынести в Utils vehicles 

-- Получить ТС из мира по ID
-- TODO: вынести в таблицу и получать ТС сразу, а не через цикл
function Garage.getVehicleByID(id)
	local v = false
	for i, veh in ipairs(getElementsByType("vehicle")) do
		if getElementData(veh, "ID") == id then
			v = veh
			break
		end
	end
	return v
end

