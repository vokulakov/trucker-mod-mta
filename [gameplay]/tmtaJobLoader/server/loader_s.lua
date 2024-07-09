local createdBox = {}

local function createStackOfBoxes(jobId, boxId, x, y, z, bl, bw, bh)
	local currentX = 0
	local currentY = 0.8
	local currentH = 0
	for i = 1, bh do
		currentX = 0
		for i = 1, bl do
			box = createObject (1271, x + currentX, y, z + currentH)
			setElementData(box, "exv_jobLoader:isBox", true)
			setElementData(box, "exv_jobLoader:boxID", boxId)
			setElementData(box, "exv_jobLoader:jobId", jobId)
			currentY = 0.8
			for i = 2, bw do
				box = createObject (1271, x + currentX, y + currentY, z + currentH)
				setElementData(box, "exv_jobLoader:isBox", true)
				setElementData(box, "exv_jobLoader:boxID", boxId)
				setElementData(box, "exv_jobLoader:jobId", jobId)
				currentY = currentY + boxDistance
			end
			currentX = currentX + boxDistance
		end
		currentH = currentH + boxHeight
	end
	createdBox[boxId] = bl*bw*bh
end

local function setPlayerToggleControl(player, state) -- действия игрока
	for _, control in ipairs(TABLE_CONTROL) do
		toggleControl(player, control, state)
	end
end

function refreshBox(jobId, boxId)
	local BOX_POSITIONS = LOADER_WORK[jobId].box
	createStackOfBoxes(jobId, boxId, BOX_POSITIONS[boxId].x, BOX_POSITIONS[boxId].y, BOX_POSITIONS[boxId].z, BOX_POSITIONS[boxId].bl, BOX_POSITIONS[boxId].bw, BOX_POSITIONS[boxId].bh)

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

	local jobId = getElementData(theBox, "exv_jobLoader:jobId")
	local boxId = getElementData(theBox, "exv_jobLoader:boxID")
	createdBox[boxId] = createdBox[boxId] - 1

	if tonumber(createdBox[boxId]) == 0 then
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

		setTimer(refreshBox, timerRestartBox * 60 * 1000, 1, jobId, boxId)
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

		if tonumber(createdBox[id]) ~= 0 then 
			triggerClientEvent(thePlayer, 'exv_jobLoader.blipOnStorage', thePlayer) 
		end
		
		if isPlayerTargetSphere then
			local loaderData = getElementData(thePlayer, 'exv_jobLoader:loaderData')
			if loaderData then
				setElementData(thePlayer, 'exv_jobLoader:loaderData',
					{
						boxCount = loaderData.boxCount + 1, 
						oldSkin = loaderData.oldSkin, 
						salary = loaderData.salary + (exports.tmtaX2:isPromoActive() and SALARY*2 or SALARY)
					}
				)

				--local data = getElementData(thePlayer, 'exv_jobLoader:loaderData')
				--triggerClientEvent(thePlayer, 'exv_notify.addInformation', thePlayer, 'ЯЩИКОВ ДОСТАВЛЕНО: '..data.boxCount)
				
				exports.tmtaExperience:givePlayerExp(thePlayer, (exports.tmtaX2:isPromoActive() and 2 or 1)) -- выдача опыта
			end
		end
	end, 1000, 1)

end
addEvent('exv_jobLoader.destroyBoxPlayer', true)
addEventHandler('exv_jobLoader.destroyBoxPlayer', root, destroyBoxPlayer)

addEventHandler("onResourceStart", resourceRoot, function()
	for jobId, jobData in pairs(LOADER_WORK) do
		local EMPLOYED = createPickup(jobData.job.x, jobData.job.y, jobData.job.z, 3, 1275, 1000)
		exports.tmtaBlip:createBlipAttachedTo(
			EMPLOYED, 
			'blipJobLoader',
			{name='Работа грузчика'},
			tocolor(0, 255, 255, 255)
		)

		EMPLOYED:setData('3dText', 'Работа грузчика')
		setElementData(EMPLOYED, "exv_jobLoader:isLoaderJobMarker", true)
		setElementData(EMPLOYED, "exv_jobLoader:jobId", jobId)

		for boxId, boxData in pairs(jobData.box) do -- спавн ящиков
			createStackOfBoxes(jobId, boxId, boxData.x, boxData.y, boxData.z, boxData.bl, boxData.bw, boxData.bh)
		end
	end

	-- База данных
	db = exports.tmtaSQLite:dbGetConnection()
	if not isElement(db) then
		stopResource(resourceRoot)
		return
	end

	dbExec(db, "CREATE TABLE IF NOT EXISTS jobLoader (Account, boxCount, oldSkin, salary)")
end)

addEventHandler("onPickupHit", resourceRoot, 
	function(player)
		if (getElementType(player) ~= 'player' or not source:getData('exv_jobLoader:isLoaderJobMarker')) then 
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

		triggerClientEvent(player, 'exv_jobLoader.showLoaderJobWindow', player, source:getData('exv_jobLoader:jobId'))
	end
)

local function stopPlayerJob(player, quit, restart)
	local loaderData = getElementData(player, 'exv_jobLoader:loaderData')
	if not loaderData then return end

	local box = getElementData(player, "exv_jobLoader:isPlayerBox") 

	if box then
		local id = getElementData(box, "exv_jobLoader:boxID")
		destroyElement(box)

		createdBox[id] = createdBox[id] - 1


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
	removeElementData(player, 'exv_jobLoader:jobId')

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
addEventHandler('exv_jobLoader.changeJobLoader', root, function(jobId)
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
		setElementData(source, 'exv_jobLoader:jobId', tonumber(jobId))
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