local currentBoxes = {}

local function createBox(id, x, y, z, bl, bw, bh) -- создать ящики
	local currentX = 0
	local currentY = 0.8
	local currentH = 0
	for i = 1, bh do
		currentX = 0
		for i = 1, bl do
			box = createObject (1271, x + currentX, y, z + currentH)
			setElementData(box, "exv_jobLoader:isBox", true)
			setElementData(box, "exv_jobLoader:boxID", id)
			currentY = 0.8
			for i = 2, bw do
				box = createObject (1271, x + currentX, y + currentY, z + currentH)
				setElementData(box, "exv_jobLoader:isBox", true)
				setElementData(box, "exv_jobLoader:boxID", id)
				currentY = currentY + boxDistance
			end
			currentX = currentX + boxDistance
		end
		currentH = currentH + boxHeight
	end
	currentBoxes[id] = bl*bw*bh
end

local function setPlayerToggleControl(player, state) -- действия игрока
	for _, control in ipairs(TABLE_CONTROL) do
		toggleControl(player, control, state)
	end
end

function refreshBox(id)
	createBox(id, BOX_POSITIONS[id].x, BOX_POSITIONS[id].y, BOX_POSITIONS[id].z, BOX_POSITIONS[id].bl, BOX_POSITIONS[id].bw, BOX_POSITIONS[id].bh)
	for _, player in ipairs(getElementsByType('player')) do
		if getElementData(player, 'exv_jobLoader:loaderData') then
			exports.tmtaNotification:showInfobox(
				player, 
				"info", 
				"#FFA07AРабота грузчика", 
				'На склад привезли ящики!',  
				{240, 146, 115}
			)

			if not getElementData(player, "exv_jobLoader:isPlayerBox") then
				triggerClientEvent(player, 'exv_jobLoader.blipOnStorage', player)
			end
		end
	end
end

local function onPlayerDoLoad(thePlayer, theBox)
	triggerClientEvent(thePlayer, 'exv_jobLoader.createShipMarker', thePlayer)

	triggerClientEvent(thePlayer, 'exv_jobLoader.blipOnStorage', thePlayer, true)
	setPedWalkingStyle(thePlayer, 119) 
	setPlayerToggleControl(thePlayer, false)

	local id = getElementData(theBox, "exv_jobLoader:boxID")
	currentBoxes[id] = currentBoxes[id] - 1

	if tonumber(currentBoxes[id]) == 0 then
		for _, player in ipairs(getElementsByType('player')) do
			if getElementData(player, 'exv_jobLoader:loaderData') then
				exports.tmtaNotification:showInfobox(
					player, 
					"info", 
					"#FFA07AРабота грузчика", 
					'На складе закончились ящики! Дождитесь новой партии.',  
					{240, 146, 115}
				)
			end
		end

		setTimer(refreshBox, timerRestartBox * 60 * 1000, 1, id)
	end
end

local function setBoxPlayer(thePlayer, theBox) -- взять ящик
	if (not thePlayer or not isElement(theBox)) then 
		return 
	end

	setPedAnimation(thePlayer, "CARRY", "liftup", 1.0, false)
	setElementData(thePlayer, "exv_jobLoader:isPlayerBox", theBox)

	setTimer(function() 

		exports.bone_attach:attachElementToBone(theBox, thePlayer, 4, -0.06, 0.65, -0.6, -90, 0, 0 )

		setPedAnimation(thePlayer, "CARRY", "crry_prtial", 4.1, true, true, true)

		if theBox:getData('exv_jobLoader:isBox') then
			onPlayerDoLoad(thePlayer, theBox) -- ЕСЛИ ВЫПОЛНЯЕМ ПОГРУЗКУ
		else
			-- ЕСЛИ ВЫПОЛНЯЕМ РАЗГРУЗКУ --
			setPedWalkingStyle(thePlayer, 119) 
			setPlayerToggleControl(thePlayer, false)
		end

	end, 1000, 1)

end
addEvent('exv_jobLoader.setBoxPlayer', true)
addEventHandler('exv_jobLoader.setBoxPlayer', root, setBoxPlayer)

local function destroyBoxPlayer(thePlayer, isPlayerTargetSphere) -- убрать ящик
	if not thePlayer then return end

	local box = getElementData(thePlayer, "exv_jobLoader:isPlayerBox") 
	local id = getElementData(box, "exv_jobLoader:boxID")

	removeElementData(thePlayer, "exv_jobLoader:isPlayerBox")
	removeElementData(box, "exv_jobLoader:boxID")

	setPedAnimation(thePlayer, "CARRY", "putdwn", 1.0, false, false, false, true)

	setTimer(function() 
		destroyElement(box)

		setPedAnimation(thePlayer, "CARRY", "liftup", 0.0, false, false, false, false)
		setPedWalkingStyle(thePlayer, 0) 
		setPlayerToggleControl(thePlayer, true)

		if not id then
			return
		end

		triggerClientEvent(thePlayer, 'exv_jobLoader.createShipMarker', thePlayer, true)

		if tonumber(currentBoxes[id]) ~= 0 then 
			triggerClientEvent(thePlayer, 'exv_jobLoader.blipOnStorage', thePlayer) 
		end
		
		if isPlayerTargetSphere then
			local loaderData = getElementData(thePlayer, 'exv_jobLoader:loaderData')
			if loaderData then
				setElementData(thePlayer, 'exv_jobLoader:loaderData',
					{
						boxCount = loaderData.boxCount + 1, 
						oldSkin = loaderData.oldSkin, 
						salary = loaderData.salary + SALARY
					}
				)

				--local data = getElementData(thePlayer, 'exv_jobLoader:loaderData')
				--triggerClientEvent(thePlayer, 'exv_notify.addInformation', thePlayer, 'ЯЩИКОВ ДОСТАВЛЕНО: '..data.boxCount)
				

				exports.tmtaExperience:givePlayerExp(thePlayer, 1) -- выдача опыта
			end
		end
	end, 1000, 1)

end
addEvent('exv_jobLoader.destroyBoxPlayer', true)
addEventHandler('exv_jobLoader.destroyBoxPlayer', root, destroyBoxPlayer)

addEventHandler("onResourceStart", resourceRoot, function()
	for i, box in ipairs(BOX_POSITIONS) do -- спавн ящиков
		createBox(i, box.x, box.y, box.z, box.bl, box.bw, box.bh)
	end

	for i, marker in ipairs(JOB_MARKER) do -- маркеры устройства на работу
		local EMPLOYED = createPickup(marker.x, marker.y, marker.z, 3, 1275, 1000)
		exports.tmtaBlip:createAttachedTo(
			EMPLOYED, 
			'blipJobLoader',
			'Работа грузчика',
			tocolor(0, 255, 255, 255)
		)

		setElementData(EMPLOYED, "exv_jobLoader:isLoaderJobMarker", true)

		addEventHandler("onPickupHit", EMPLOYED, function(player)
			if getElementType(player) ~= 'player' then 
				return 
			end

			if getElementData(player, "exv_jobLoader:isPlayerBox") then
				exports.tmtaNotification:showInfobox(
					player, 
					"info", 
					"#FFA07AРабота грузчика", 
					"Отнесите ящик",  
					{240, 146, 115}
				)
				return
			end

			triggerClientEvent(player, 'exv_jobLoader.showLoaderJobWindow', player)
		end)

	end

	-- База данных
	db = exports.tmtaSQLite:dbGetConnection()
	if not isElement(db) then
		stopResource(resourceRoot)
		return
	end

	dbExec(db, "CREATE TABLE IF NOT EXISTS jobLoader (Account, boxCount, oldSkin, salary)")
end)

local function stopPlayerJob(player, quit, restart)
	local loaderData = getElementData(player, 'exv_jobLoader:loaderData')
	if not loaderData then return end

	local box = getElementData(player, "exv_jobLoader:isPlayerBox") 

	if box then
		local id = getElementData(box, "exv_jobLoader:boxID")
		destroyElement(box)

		currentBoxes[id] = currentBoxes[id] - 1


		removeElementData(box, "exv_jobLoader:boxID")
		removeElementData(player, "exv_jobLoader:isPlayerBox")
	end


	if quit then

		dbExec(db, "UPDATE jobLoader SET boxCount = ?, oldSkin = ?, salary = ? WHERE Account = ?",
			loaderData.boxCount,
			loaderData.oldSkin,
			loaderData.salary,
			getAccountName(getPlayerAccount(player))
		)

		removeElementData(player, "exv_jobLoader:loaderData")

		return
	end

	setPedWalkingStyle(player, 0) 
	setPlayerToggleControl(player, true)
	setElementModel(player, loaderData.oldSkin)

	setPedAnimation(player, false)

	exports.tmtaNotification:showInfobox(
		player, 
		"info", 
		"#FFA07AРабота грузчика", 
		"Вы закончили рабочую смену",  
		{240, 146, 115}
	)

	if not restart then
		triggerClientEvent(player, 'exv_jobLoader.blipOnStorage', player, true)
		triggerClientEvent(player, 'exv_jobLoader.createShipMarker', player, true) 
	end

	--TODO: setElementData(player, 'exv_caseMoney.isWeapon', false) 

	setTimer(function(pl, salary)
		exports.tmtaMoney:givePlayerMoney(pl, salary)
		--givePlayerMoney(pl, salary)
		--triggerClientEvent(pl, 'exv_notify.addInformation', pl, 'ЗАРПЛАТА: '..salary..'$', true)
	end, 5000, 1, player, loaderData.salary)

	removeElementData(player, "exv_jobLoader:loaderData")

	local query = dbQuery(db, "SELECT * FROM jobLoader WHERE Account = ?", getAccountName(getPlayerAccount(player)))
	local result = dbPoll(query, -1)

	if type(result) == "table" and #result ~= 0 then
		dbExec(db, "DELETE FROM jobLoader WHERE Account = ?", getAccountName(getPlayerAccount(player)))
	end
end
addEvent('exv_jobLoader.onPlayerServerQuit', true)
addEventHandler('exv_jobLoader.onPlayerServerQuit', root, stopPlayerJob)

addEventHandler('onPlayerQuit', root, function() stopPlayerJob(source, true) end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in ipairs(getElementsByType('player')) do
		if getElementData(player, 'exv_jobLoader:loaderData') then
			stopPlayerJob(player, false, true)
		end
	end
end)

-- Устройство на работу
addEvent('exv_jobLoader.changeJobLoader', true)
addEventHandler('exv_jobLoader.changeJobLoader', root, function()
	local loaderData = getElementData(source, 'exv_jobLoader:loaderData')
	if not loaderData then
		-- ПОДГРУЗКА ДАННЫХ --
		local data 
		local acc = getAccountName(getPlayerAccount(source))
		local query = dbQuery(db, "SELECT * FROM jobLoader WHERE Account = ?", acc)
		local result = dbPoll(query, -1)

		if type(result) == "table" and #result ~= 0 then
			data = {boxCount = result[1]['boxCount'], oldSkin = result[1]['oldSkin'], salary = result[1]['salary']} 
		else
			dbExec(db, "INSERT INTO jobLoader VALUES(?, ?, ?, ?)", acc, 0, getElementModel(source), 0)
			data = {boxCount = 0, oldSkin = getElementModel(source), salary = 0} 
		end

		setElementData(source, 'exv_jobLoader:loaderData', data)
		setElementModel(source, loaderSkin)
		--TODO: setElementData(source, 'exv_caseMoney.isWeapon', true) -- убираем кейс
		
		exports.tmtaNotification:showInfobox(
			source, 
			"info", 
			"#FFA07AРабота грузчика", 
			"Вы начали рабочую смену",  
			{240, 146, 115}
		)

		triggerClientEvent(source, 'exv_jobLoader.blipOnStorage', source)
		----------------------
	else
		stopPlayerJob(source, false)
	end
end)