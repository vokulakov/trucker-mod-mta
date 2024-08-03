THE_TIME_DELETE = 240 -- через сколько минут удалять транспорт с Б/У (4 часа)
THE_TIME_DES = 3 -- через сколько минут убирать транспорт

function getCarLimit(ply)
	return (getElementData(ply, '_carLimit') or 100)
end

function getFreeID()
	local result = dbPoll(dbQuery(db, "SELECT ID FROM VehicleList ORDER BY ID ASC"), -1)
	newID = false
	for i, id in pairs (result) do
		if id["ID"] ~= i then
			newID = i
			break
		end
	end
	if newID then return newID else return #result + 1 end
end

function getVehicleByID(id)
	v = false
	for i, veh in ipairs (getElementsByType("vehicle")) do
		if getElementData(veh, "ID") == id then
			v = veh
			break
		end
	end
	return v
end

function updateVehicleInfo(player)
	if isElement(player) then
		local result = dbPoll(dbQuery(db, "SELECT * FROM VehicleList WHERE Account = ?", getAccountName(getPlayerAccount(player))), -1)
		if type(result) == "table" then
			player:setData("VehicleInfo", {})
			player:setData("VehicleInfo", result)
		end
	end
end

--[[
addEventHandler("onResourceStart", resourceRoot,
function()
	db = dbConnect("sqlite", "database.db")
	dbExec(db, "CREATE TABLE IF NOT EXISTS VehicleList (ID, Account, Model, X, Y, Z, RotZ, Colors, Upgrades, Paintjob, Cost, HP, numbers, region, handlings, fuel, Lights, Toner, RealNumber, Paint)")
	
	--dbExec(db, "ALTER TABLE VehicleList ADD COLUMN Paint")

	for _, player in ipairs(getElementsByType("player")) do
		updateVehicleInfo(player)
	end
end)
]]

addEvent("onOpenGui", true)
addEventHandler("onOpenGui", root,
function()
	updateVehicleInfo(source)
end)

function destroyVehicle(theVehicle)
	if isElement(theVehicle) then
		local Owner = getElementData(theVehicle, "Owner")
		if Owner then
			local x, y, z = getElementPosition(theVehicle)
			local _, _, rz = getElementRotation(theVehicle)
			local r1, g1, b1, r2, g2, b2 = getVehicleColor(theVehicle, true)
			local color = r1..","..g1..","..b1..","..r2..","..g2..","..b2
			upgrade = ""
			for _, upgradee in ipairs (getVehicleUpgrades(theVehicle)) do
				if upgrade == "" then
					upgrade = upgradee
				else
					upgrade = upgrade..","..upgradee
				end
			end
			local Paintjob = getVehiclePaintjob(theVehicle) or 3
			local id = getElementData(theVehicle, "ID")
			local numbers = "AH0001EE"
			local region = "ua"
			local handlings = toJSON(getVehicleHandling(theVehicle))
			local fuel = getElementData(theVehicle, 'fuel') or 50--or exports.zapravrka:getVehicleFuel(theVehicle)

			local realnumber = toJSON({false,false})
			if getElementData(theVehicle,"numberType") then
				realnumber = toJSON({getElementData(theVehicle,"numberType"), getElementData(theVehicle,"number:plate")})
				numbers = tostring(getElementData(theVehicle,"numberType"))
				region = tostring(getElementData(theVehicle,"number:plate"))
			end
			
			-- СОХРАНЕНИЕ ТОНИРОВКИ [НАЧАЛО] --
			toner = toJSON({
				tostring(getElementData(theVehicle, "toner:pered_steklo") or 0), 
				tostring(getElementData(theVehicle, "toner:zad_steklo") or 0), 
				tostring(getElementData(theVehicle, "toner:lob_steklo") or 0),
				getElementData(theVehicle, "toner:color") or {0, 0, 0}
			})
			-- СОХРАНЕНИЕ ТОНИРОВКИ [КОНЕЦ] --

			-- СОХРАНЕНИЕ ПОКРАСКИ [НАЧАЛО] --
			local colorRGB = ""
			local colorTypeRGB = getElementData(theVehicle, 'arst_carPaint.colorTypeRGB') or false
			if colorTypeRGB then
				colorRGB = colorTypeRGB[1]..', '..colorTypeRGB[2]..', '..colorTypeRGB[3]
			end
			local paint = toJSON(
				{
					tostring(getElementData(theVehicle, 'arst_carPaint.colorType') or 0),
					tostring(colorRGB)
				}
			)
			-- СОХРАНЕНИЕ ПОКРАСКИ [КОНЕЦ] --

			-- Ксенон
			local lig_r, lig_g, lig_b = getVehicleHeadLightColor(theVehicle)
			local lights = lig_r..","..lig_g..","..lig_b

			outputDebugString( "Vehicle saved with numbers: "..realnumber)
			dbExec(db, "UPDATE VehicleList SET X = ?, Y = ?, Z = ?, RotZ = ?, HP = ?, Colors = ?, Upgrades = ?, Paintjob = ?, numbers=?, region=?, handlings=?, fuel=?, Lights = ?, Toner = ?, RealNumber = ?, Paint = ? WHERE Account = ? AND ID = ?", x, y, z, rz, getElementHealth(theVehicle), color, upgrade, Paintjob,numbers,region,handlings, fuel, lights, toner, realnumber, paint, getAccountName(getPlayerAccount(Owner)), id)

			updateVehicleInfo(Owner)
			local attached = getAttachedElements(theVehicle)
			if (attached) then
				for k,element in ipairs(attached) do
					if getElementType(element) == "blip" then
						destroyElement(element)
					end
				end
			end
		end
		destroyElement(theVehicle)
	end
end

addEvent("tmtaVehCarshop.onBuyNewVehicle", true)
addEventHandler("tmtaVehCarshop.onBuyNewVehicle", root, function(Model, cost, r1, g1, b1, r2, g2, b2, nospawn)

	local player = source
	local carName = customCarNames[Model] or getVehicleNameFromModel(Model)

	abc = false
	local data = dbPoll(dbQuery(db, "SELECT * FROM VehicleList WHERE Account = ?", getAccountName(getPlayerAccount(player))), -1)
	for i, data in ipairs (data) do
		if data["Model"] == Model then
			abc = false
			break
		end
	end
	local limit = getCarLimit(player)
	if #data+1 > limit then
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
	
	if exports.tmtaMoney:getPlayerMoney(player) >= tonumber(cost) then
		exports.tmtaMoney:takePlayerMoney ( player, cost )
		local x, y, z = getElementPosition(player)
		local _, _, rz = getElementRotation(player)
		local color = r1..","..g1..","..b1..","..r2..","..g2..","..b2
		if not nospawn then
				vehicle = createVehicle(Model, x-5, y+5, z, 0, 0, rz)
		else
			vehicle = client.vehicle
			vehicle.frozen = false
			vehicle.collisionsEnabled = true
			local sellInfo = vehicle:getData("sellInfo")
			
			vehicle:removeData("sellInfo")
		end
		setVehicleColor(vehicle, r1, g1, b1, r2, g2, b2)
		setElementData(vehicle, "Owner", player)
		local NewID = getFreeID()
		setElementData(vehicle, "ID", NewID)

		--------------
		local symbols = {
			'A',
			'B',
			'C',
			'Y',
			'O',
			'P',
			'T',
			'E',
			'X',
			'M',
			'H',
			'K'
		}
		
		local rand1 = math.random(1,9)
		local rand2 = math.random(0,9)
		local rand3 = math.random(0,9)
		local rand4 = math.random(777,777)
		local symbol_1 = symbols[math.random(#symbols)]
		local symbol_2 = symbols[math.random(#symbols)]
		local symbol_3 = symbols[math.random(#symbols)]
		local numbers = "O001OO"
		local region = "197"
		local fuel = getElementData(vehicle, 'fuel') or 50 --or exports.zapravrka:getVehicleFuel(vehicle)

		--outputDebugString(getElementData(vehicle, 'fuel'))
		-----------
		local realnumber = toJSON({false,false})
		setElementData(vehicle,"numberType","ru")
		setElementData(vehicle,"number:plate",symbol_1..rand1..rand2..rand3..symbol_2..symbol_3..rand4)
		
		if getElementData(vehicle,"numberType") then
			realnumber = toJSON({getElementData(vehicle,"numberType"), getElementData(vehicle,"number:plate")})
			numbers = tostring(getElementData(vehicle,"numberType"))
			region = tostring(getElementData(vehicle,"number:plate"))
		end
		

	--	setElementData(vehicle,"toner:toner", false)
	--	setElementData(vehicle,"toner:zad_steklo", 0)
	--	setElementData(vehicle,"toner:pered_steklo", 0)
	--	setElementData(vehicle,"toner:lob_steklo", 0)
	--	setElementData(vehicle,"toner:color", {0, 0, 0})

		local toner = toJSON({false, 0, 0, 0, {0, 0, 0}})

		local lr, lg, lb = getVehicleHeadLightColor(vehicle)
		local lights = lr..","..lg..","..lb

		dbExec(db, "INSERT INTO VehicleList VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", NewID, getAccountName(getPlayerAccount(player)), Model, x-5, y+5, z, rz, color, "", 3, cost, 1000, numbers,region, nil, fuel, lights, toner, realnumber, nil)
		
		exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AАвтосалон", 
            "Поздравляем! Вы приобрели "..carName.." за "..convertNumber(cost).." ₽", 
            _, 
            {240, 146, 115}
        )

		--outputChatBox("[Автосалон] #FFFFFFВы купили данный транснпорту за: "..cost.." руб", player, 38, 122, 216, true)
		updateVehicleInfo(player)
		vv[vehicle] = setTimer(function(source)
			--if not isElement(source) then killTimer(vv[source]) vv[source] = nil end
			if isElement(source) and getElementHealth(source) <= 255 then
				setElementHealth(source, 255.5)
				setVehicleDamageProof(source, true)
				setVehicleEngineState(source, false)
			end
		end, 50, 0, vehicle)
		addEventHandler("onVehicleDamage", vehicle,
		function(loss)
			local account = getAccountName(getPlayerAccount(getElementData(source, "Owner")))
			setTimer(function(source) if isElement(source) then dbExec(db, "UPDATE VehicleList SET HP = ? WHERE Account = ? AND Model = ?", getElementHealth(source), account, getElementModel(source)) updateVehicleInfo(getElementData(source, "Owner")) end end, 100, 1, source)
		end)
		addEventHandler("onVehicleEnter", vehicle,
		function(player)
			if getElementHealth(source) <= 255.5 then 
				setVehicleEngineState(source, false)
			else
				if isVehicleDamageProof(source) then
					setVehicleDamageProof(source, false)
				end
			end
		end)

		-- выход из автосалона
		triggerClientEvent(player, "tmtaVehCarshop.exitCarDealership", player)
	else
		exports.tmtaNotification:showInfobox(
            player, 
            "info", 
            "#FFA07AАвтосалон", 
            "У вас нехватает денежных средств для покупки #FFA07A"..carName, 
            _, 
            {240, 146, 115}
        )
	end
end)

vv = {}

addEvent("SpawnMyVehicle", true)
addEventHandler("SpawnMyVehicle", root, function(id)

	local player = source

	local data = dbPoll(dbQuery(db, "SELECT * FROM VehicleList WHERE Account = ? AND ID = ?", getAccountName(getPlayerAccount(player)), id), -1)
	if type(data) == "table" and #data ~= 0 then

		local carName = customCarNames[data[1]['Model']] or getVehicleNameFromModel(data[1]['Model'])

		if getVehicleByID(id) then
			exports.tmtaNotification:showInfobox(
				player, 
				"info", 
				"#", 
				"#FFA07A"..carName.." #FFFFFFне стоит в гараже!", 
				_, 
				{240, 146, 115}
			)
		else
			local color = split(data[1]["Colors"], ',')
			r1 = color[1] or 255
			g1 = color[2] or 255
			b1 = color[3] or 255
			r2 = color[4] or 255
			g2 = color[5] or 255
			b2 = color[6] or 255
			vehicle = createVehicle(data[1]["Model"], data[1]["X"], data[1]["Y"], data[1]["Z"], 0, 0, data[1]["RotZ"])
			setElementData(vehicle, "ID", id)
			setElementData(vehicle,'numbers',data[1]["numbers"])
			setElementData(vehicle,'region',data[1]["region"])
			setElementData(vehicle,'fuel', data[1]['fuel'])
			local handlings = fromJSON(data[1]['handlings'])
			for key,value in pairs(handlings or {}) do
				setVehicleHandling(vehicle, key, value)
			end
			local numbers = fromJSON(data[1]["RealNumber"])
			outputDebugString( "Vehicle created with numbers: "..tostring(numbers[1]).." | "..tostring(numbers[2]))
			if numbers[1] then
				setElementData(vehicle,"numberType",numbers[1])
				setElementData(vehicle,"number:plate",numbers[2])
			end
			
	        -- УСТАНОВКА ТОНИРОВКИ [НАЧАЛО] --
            if data[1]["Toner"] then
                local toner = fromJSON(data[1]["Toner"])
	            setElementData(vehicle, "toner:pered_steklo", tonumber(toner[1]))
	            setElementData(vehicle, "toner:zad_steklo", tonumber(toner[2]))
	            setElementData(vehicle, "toner:lob_steklo", tonumber(toner[3]))
	            setElementData(vehicle, "toner:color", toner[4])
	            setElementData(vehicle, "toner:toner", true)
	        end
            -- УСТАНОВКА ТОНИРОВКИ [КОНЕЦ] --
			
	        -- УСТАНОВКА ПОКРАСКИ [НАЧАЛО] --
            if data[1]['Paint'] then
            	local paint = fromJSON(data[1]['Paint'])
            	if paint ~= nil and paint[1] ~= '0' then
            		setElementData(vehicle, "arst_carPaint.colorType", paint[1])
            		if paint[2] ~= "" then
            			local colorRGB = split(paint[2], ',')
            			setElementData(vehicle, "arst_carPaint.colorTypeRGB", 
            				{
            					colorRGB[1],
            					colorRGB[2],
            					colorRGB[3]
            				}
            			)
            		end
            	end
                --setElementData(vehicle,'paint-system:remapTexture',tonumber(paint))
            end
            -- УСТАНОВКА ПОКРАСКИ [КОНЕЦ] --

			-- Ксенон
			local lights = split(data[1]["Lights"], ',')
			lig_r = lights[1] or 255
			lig_g = lights[2] or 255
			lig_b = lights[3] or 255

			setVehicleHeadLightColor(vehicle, lig_r, lig_g, lig_b)

			local upd = split(tostring(data[1]["Upgrades"]), ',')
			for i, upgrade in ipairs(upd) do
				addVehicleUpgrade(vehicle, upgrade)
			end
			local Paintjob = data[1]["Paintjob"] or 3
			setVehiclePaintjob(vehicle, Paintjob) 
			setVehicleColor(vehicle, r1, g1, b1, r2, g2, b2)
			if data[1]["HP"] <= 255.5 then data[1]["HP"] = 255 end
			setElementHealth(vehicle, data[1]["HP"])
			setElementData(vehicle, "Owner", source)
			--[[
			vv[vehicle] = setTimer(function(source)
		--		if not isElement(source) then killTimer(vv[source]) vv[source] = nil end
				if isElement(source) and getElementHealth(source) <= 255 then
					setElementHealth(source, 255.5)
					setVehicleDamageProof(source, true)
					setVehicleEngineState(source, false)
				end
			end, 50, 0, vehicle)]]
			--[[
			addEventHandler("onVehicleDamage", vehicle,
			function(loss)
				local account = getAccountName(getPlayerAccount(getElementData(source, "Owner")))
				setTimer(function(source) if isElement(source) then dbExec(db, "UPDATE VehicleList SET HP = ? WHERE Account = ? AND Model = ?", getElementHealth(source), account, getElementModel(source)) updateVehicleInfo(getElementData(source, "Owner")) end end, 100, 1, source)
			end)
			]]
			--[[
			addEventHandler("onVehicleEnter", vehicle,
			function(player)
				if getElementHealth(source) <= 255.5 then 
					setVehicleEngineState(source, false)
				else
					if isVehicleDamageProof(source) then
						setVehicleDamageProof(source, false)
					end
				end
			end)
			]]
			exports.tmtaNotification:showInfobox(
				player, 
				"info", 
				"", 
				"Вы выгнали #FFA07A"..carName.." #FFFFFFиз гаража", 
				_, 
				{240, 146, 115}
			)

			startDesTimer(vehicle)
		end
	end
end)

addEvent("DestroyMyVehicle", true)
addEventHandler("DestroyMyVehicle", root, function(id, carName)
	if type(id) ~= 'number' then 
		return
	end 

	local player = source
	local vehicle = getVehicleByID(id)

	if isElement(vehicle) then
		local data = dbPoll(dbQuery(db, "SELECT * FROM VehicleList WHERE Account = ? AND ID = ?", getAccountName(getPlayerAccount(source)), id), -1)
		if type(data) == "table" and #data ~= 0 then

			

			stopDesTimer(vehicle)
			destroyVehicle(vehicle)

			exports.tmtaNotification:showInfobox(
				player, 
				"info", 
				"", 
				"Вы загнали #FFA07A"..carName.." #FFFFFFв гараж", 
				_, 
				{240, 146, 115}
			)

			--outputChatBox ("#FFFFFF[Автосалон] #58FAF4Ваше транспортное средство #FF0000убрано.", source, 38, 122, 216, true)
		end
	else
		exports.tmtaNotification:showInfobox(
			player, 
			"info", 
			"", 
			"#FFA07A"..carName.." #FFFFFFнаходится в гараже", 
			_, 
			{240, 146, 115}
		)
		--outputChatBox("#FFFFFF[Автосалон] #58FAF4Ваш транспорт #FF0000не был заспавнен.", source, 38, 122, 216, true)
	end
end)

addEventHandler("onElementDestroy", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		local Owner = getElementData(source, "Owner")
		if Owner then
			local x, y, z = getElementPosition(source)
			local _, _, rz = getElementRotation(source)
			local r1, g1, b1, r2, g2, b2 = getVehicleColor(source, true)
			local color = r1..","..g1..","..b1..","..r2..","..g2..","..b2
			upgrade = ""
			for _, upgradee in ipairs (getVehicleUpgrades(source)) do
				if upgrade == "" then
					upgrade = upgradee
				else
					upgrade = upgrade..","..upgradee
				end
			end
			local Paintjob = getVehiclePaintjob(source) or 3
			local id = getElementData(source, "ID")
			local numbers = "AH0001EE"
			local region = "ua"
			local handlings = toJSON(getVehicleHandling(source))
			local fuel = getElementData(source, 'fuel') or 50--or exports.zapravrka:getVehicleFuel(source)

			local realnumber = toJSON({false,false})
			if getElementData(source,"numberType") then
				realnumber = toJSON({getElementData(source,"numberType"), getElementData(source,"number:plate")})
				numbers = tostring(getElementData(source,"numberType"))
				region = tostring(getElementData(source,"number:plate"))
			end

			-- СОХРАНЕНИЕ ПОКРАСКИ [НАЧАЛО] --
			local colorRGB = ""
			local colorTypeRGB = getElementData(source, 'arst_carPaint.colorTypeRGB') or false
			if colorTypeRGB then
				colorRGB = colorTypeRGB[1]..', '..colorTypeRGB[2]..', '..colorTypeRGB[3]
			end
			local paint = toJSON(
				{
					tostring(getElementData(source, 'arst_carPaint.colorType') or 0),
					tostring(colorRGB)
				}
			)
			-- СОХРАНЕНИЕ ПОКРАСКИ [КОНЕЦ] --

			-- Ксенон
			local lig_r, lig_g, lig_b = getVehicleHeadLightColor(source)
			local lights = lig_r..","..lig_g..","..lig_b

			outputDebugString( "Vehicle saved with numbers: "..realnumber)
			dbExec(db, "UPDATE VehicleList SET X = ?, Y = ?, Z = ?, RotZ = ?, HP = ?, Colors = ?, Upgrades = ?, Paintjob = ?, numbers=?, region=?, handlings=?, fuel=?, Lights = ?, Toner = ?, RealNumber = ?, Paint = ? WHERE Account = ? AND ID = ?", x, y, z, rz, getElementHealth(source), color, upgrade, Paintjob,numbers,region,handlings, fuel, lights, toner, realnumber,  paint, getAccountName(getPlayerAccount(Owner)), id)
			updateVehicleInfo(Owner)
			local attached = getAttachedElements(source)
			if (attached) then
				for k,element in ipairs(attached) do
					if getElementType(element) == "blip" then
						destroyElement(element)
					end
				end
			end
		end
	end
end)

addEvent("WarpMyVehicle", true)
addEventHandler("WarpMyVehicle", root, 
function(id)
    if not isPedInVehicle (source) then
	if getElementInterior(source) == 0 then
		local vehicle = getVehicleByID(id)
		if isElement(vehicle) then
			local x, y, z = getElementPosition(source)
			--warpPedIntoVehicle(client,vehicle)
			setElementPosition(vehicle, x+0, y+2, z+1.5)
			outputChatBox ("[Автосалон] #58FAF4Ваш транспорт #00FF00доставлен к Вам.", source, 38, 122, 216, true)
		else
			outputChatBox("[Автосалон] #58FAF4Ваш транспорт #FF0000не заспавнен.", source, 38, 122, 216, true)
		end
	else
		outputChatBox("[Автосалон] #FF0000Вы не можете изменять автомобиль, пока Вы внутри.", source, 38, 122, 216, true)
	end
     else
             outputChatBox("[Автосалон] #FF0000Не можем телепортировать Ваш транснпорт .. Пожалуйста, выйдите из другого транспорта .", source, 38, 122, 216, true)
    end
end)
	
addEvent("SellMyVehicle", true)
addEventHandler("SellMyVehicle", root, 
function(id)
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
	local vehicle = getVehicleByID(id)
	local data = dbPoll(dbQuery(db, "SELECT * FROM VehicleList WHERE Account = ? AND ID = ?", getAccountName(getPlayerAccount(source)), id), -1)
	
	--if exports.police_system:isVehicleOnFinePark(id) then
			--outputChatBox("[Автосалон] #58FAF4Ваш транспорт #58FAF4на штраф стоянке.", source, 38, 122, 216, true)
		--return
	--end
	stopDesTimer(vehicle)

	if type(data) == "table" and #data ~= 0 then
		local Money = math.ceil((data[1]["Cost"]*.9)*math.floor(data[1]["HP"])/100/10)
		givePlayerMoney (source, Money)
		
		if isElement(vehicle) then 
			if not vehicle:getData("sellInfo") then		
				makeSellVehicle(vehicle, Money)
			end 
		end
		dbExec(db, "DELETE FROM VehicleList WHERE Account = ? AND ID = ?", getAccountName(getPlayerAccount(source)), id)
		updateVehicleInfo(source)
		outputChatBox("[Автосалон] #FF0000Вы продали свой автомобиль за "..Money.."Руб.", source, 38, 122, 216, true)
	end
end)

function getDataOnLogin(_, account)
	updateVehicleInfo(source)
end
addEventHandler("onPlayerLogin", root, getDataOnLogin)

function SaveVehicleDataOnQuit()
	for i, veh in ipairs (getElementsByType("vehicle")) do
		if getElementData(veh, "Owner") == source then
			destroyVehicle(veh)
		end
	end
end
addEventHandler("onPlayerQuit", root,SaveVehicleDataOnQuit)

addEvent("inviteToBuyCarSended", true)
addEventHandler("inviteToBuyCarSended", root, 
function(player, price, veh_name, veh_id)
	if player and price and veh_name and veh_id then

		--if exports.police_system:isVehicleOnFinePark(veh_id) then
			--outputChatBox("[Автосалон] #58FAF4Ваш транспорт #58FAF4на штраф стоянке.", source, 38, 122, 216, true)
			--return
		--end

		local pl = getPlayerFromName ( player )
		if pl then
			triggerClientEvent ( pl, "recieveInviteToBuyCar", pl, getPlayerName (source), getAccountName(getPlayerAccount(source)), price, veh_name, veh_id )
		else
			outputChatBox ( "Игрок не найден, продажа отменена", source, 250, 10, 10)
			triggerClientEvent ( source, "cleanCarInvitations", source )
		end
	end
end)


addEvent("invitationBuyCarNotAccepted", true)
addEventHandler("invitationBuyCarNotAccepted", root, 
function(player, acc, price, veh_name, veh_id)
	local pl = getPlayerFromName ( player )
	if pl then
		triggerClientEvent ( pl, "cleanCarInvitations", pl )
		outputChatBox ( "Игрок отказался покупать ваше авто", pl, 250, 10, 10)
	end 
end)

addEvent("invitationBuyCarAccepted", true)
addEventHandler("invitationBuyCarAccepted", root, 
function(player, acc, price, veh_name, veh_id)
	local pl = getPlayerFromName ( player )
	local avail = false
	if pl and getAccountName ( getPlayerAccount (pl)) == acc then
		avail = true
		triggerClientEvent ( pl, "cleanCarInvitations", pl )
		--outputChatBox ( "Игрок отказался покупать ваше авто", pl, 250, 10, 10)
	else
		for i, v in ipairs( getElementsByType ( 'player' ) ) do
			if getAccountName(getPlayerAccount ( v )) == acc then
				avail = true
				pl = v
				break
			end
		end
	end
	price = tonumber(price) or 0
	if avail then
		if isGuestAccount ( getPlayerAccount ( source ) ) then
			triggerClientEvent ( pl, "cleanCarInvitations", pl )
			outputChatBox ( "Вы не зашли в аккаунт, сделка отменена", source, 250, 10, 10 )
			outputChatBox ( "Игрок не зашел в аккаунт, сделка отменена", pl, 250, 10, 10 )
			return true
		end
		if exports.tmtaMoney:getPlayerMoney ( source ) >= price then
			local vehicle = getVehicleByID(tonumber(veh_id))
			local data = dbPoll(dbQuery(db, "SELECT * FROM VehicleList WHERE Account = ? AND ID = ?", getAccountName(getPlayerAccount(pl)), veh_id), -1)
			if type(data) == "table" and #data ~= 0 and isElement ( vehicle ) then
				exports.tmtaMoney:givePlayerMoney ( pl, price )
				exports.tmtaMoney:takePlayerMoney ( source, price )		
				dbExec(db, "UPDATE VehicleList SET Account = ? WHERE Account = ? AND ID = ?", getAccountName(getPlayerAccount(source)), getAccountName(getPlayerAccount(pl)), veh_id)
				updateVehicleInfo(source)
				updateVehicleInfo(pl)
				setElementData(vehicle, "Owner", source)
				setElementData(vehicle, "ownercar", getAccountName(getPlayerAccount(source)))
				outputChatBox("[Автосалон] #00FF00Вы продали Ваш транспорт за "..price"Руб.", pl, 38, 122, 216, true)
				outputChatBox("[Автосалон] #00FF00Вы купили автомобиль за "..price"Руб.", source, 38, 122, 216, true)
				triggerClientEvent ( pl, "cleanCarInvitations", pl )
			else
				outputChatBox ( "Машина не найдена, сделка отменена", source, 250, 10, 10 )
				outputChatBox ( "Машина не найдена, сделка отменена. Попробуйте заспавнить автомобиль.", pl, 250, 10, 10 )
				triggerClientEvent ( pl, "cleanCarInvitations", pl )
			end
		else
			outputChatBox ( "У вас не хватает денег, сделка отменена", source, 250, 10, 10 )
		end
	else
		outputChatBox ( "Игрок не найден, сделка отменена", source, 250, 10, 10)
	end
end)



function makeSellVehicle(vehicle, price)

	if not isElement(vehicle) then
		return false
	end
	if vehicle:getData("sellInfo") then
		return false
	end
	local sellInfo = {
		price = price,
	}
	--[[
	for k, v in pairs(vehicle:getAllData()) do
		if k ~= 'numbers' and k ~= 'region' then
			vehicle:removeData(k)
		end
	end
	]]
	vehicle.frozen = true
	vehicle.collisionsEnabled = false
	vehicle:setData("sellInfo", sellInfo)
	stopDesTimer(vehicle)
	--outputDebugString(getElementData(vehicle, 'fuel'))
	setTimer(function ()
		if isElement(vehicle) then
			if vehicle:getData("sellInfo") then
				destroyElement(vehicle)
			end
		end
	end, 60 * 60 * 1000 * THE_TIME_DELETE, 1)

	return true
end

-- Костыль от закрывания дверей авто
addEventHandler("onVehicleStartEnter", getRootElement(), function(player, seat)
	local sellInfo = source:getData("sellInfo")
	
	if type(sellInfo) ~= "table" then
		return false
	end
	
	setVehicleLocked(source, false) 
end)

addEventHandler("onVehicleEnter", root, function (player, seat, jacked)
	local sellInfo = source:getData("sellInfo")
	
	if type(sellInfo) ~= "table" then
		return false
	end
	
	if seat == 0 then
	    triggerClientEvent(player, "showBuyGUI", source)
	    triggerClientEvent(jacked, "hideBuyGUI", jacked)
	else
	    triggerClientEvent(player, "hideBuyGUI", player)
	end
	
	triggerClientEvent(jacked, "hideBuyGUI", jacked)
end)


function updateNumbers(ply,veh,numbers,region, oldNums)
	local model = getElementModel(veh)
	dbExec(db, "UPDATE VehicleList SET numbers=?,region=? WHERE Account = ? AND Model = ? AND numbers=?",numbers,region, getAccountName(getPlayerAccount(ply)), model, oldNums)

	setTimer(function()
		updateVehicleInfo(ply)
	end,400,1)

end


function setNewNumbers(ply,model,oldNums,oldReg,current)

	local id = string.find(current,'|')
	local nums = string.sub(current,0,id)
	local reg = string.sub(current,id+1,id+3)

	local login = getAccountName(getPlayerAccount(ply))
	dbExec(db, "UPDATE VehicleList SET numbers=?,region=? WHERE Account = ? AND Model = ? AND numbers=?",nums,reg, getAccountName(getPlayerAccount(ply)), model, oldNums,oldReg)

	setTimer(function()
		updateVehicleInfo(ply)
	end,400,1)
end

function getVehicleDataByID(vehid)
	local data = dbPoll(dbQuery(db, "SELECT * FROM VehicleList WHERE ID = ?", vehid), -1)
	if type(data) == "table" and #data ~= 0 then
		return data[1]
	else
		return false
	end
end 

local function onPlayerQuitSalon()
	local x, y, z = getElementPosition(source)
	setElementPosition(source, x, y, z)
	setElementDimension(source, 0)
	fadeCamera(source, true, 0.5)
	setCameraTarget(source, source)
end
addEvent('onPlayerQuitSalon', true)
addEventHandler('onPlayerQuitSalon', root, onPlayerQuitSalon)


-- DESTROY [НАЧАЛО] --
local THE_TIMER = {}

function startDesTimer(vehicle)
	THE_TIMER[vehicle] = setTimer(destroyVehicle, 60 * 1000 * THE_TIME_DES, 1, vehicle)
end

function stopDesTimer(vehicle)
	if isTimer(THE_TIMER[vehicle]) then
        killTimer(THE_TIMER[vehicle])
    end
end

addEventHandler("onVehicleStartEnter", getRootElement(), function(player, seat)
    if not getElementData(source, "Owner") then return end

	if isTimer(THE_TIMER[source]) then
		killTimer(THE_TIMER[source])
	end
	
end)

addEventHandler("onVehicleExit", getRootElement(), function(player, seat)
    if not getElementData(source, "Owner") then return end
	
	local counter = 0
	for seat, player in pairs(getVehicleOccupants(source)) do
		counter = counter + 1
	end
	
	if counter == 0 then
		if isTimer(THE_TIMER[source]) then
			return 
		end
        THE_TIMER[source] = setTimer(destroyVehicle, 60 * 1000 * THE_TIME_DES, 1, source)
    end
	
end)

-- DESTROY [КОНЕЦ] --