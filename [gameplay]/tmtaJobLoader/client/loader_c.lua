local sW, sH = guiGetScreenSize()
local sDW, sDH = exports.tmtaUI:getScreenSize()

local sW, sH = guiGetScreenSize()
local UI = { ['loader'] = {} }

-- GUI [НАЧАЛО] --
local function showLoaderJobWindow(jobId)
	if source ~= localPlayer then return end
	if isElement(UI['loader'].wnd) then return end

	local loaderData = getElementData(localPlayer, 'exv_jobLoader:loaderData')
	
	UI['loader'].wnd = guiCreateWindow(sW/2-350/2, sH/2-120/2, 350, 120, "Работа грузчика", false)

	local wnd_info, wnd_do 

	if not loaderData then
		wnd_info = 'Ваша задача - переносить ящики со склада.\nОплата производится за каждый ящик.\nВы готовы приступить к работе?'
		wnd_do = 'Приступить к работе'
	else
		wnd_info = 'За рабочую смену вы перенесли '..loaderData.boxCount..' ящиков.\nВаша зарплата составляет '..loaderData.salary..'$\nВы точно хотите закончить работу?'
		wnd_do = 'Закончить рабочую смену'
	end

	UI['loader'].lbl_info = guiCreateLabel(0, 0.2, 1, 0.5, wnd_info, true, UI['loader'].wnd)
	guiSetFont(UI['loader'].lbl_info, "default-bold-small")
	guiLabelSetHorizontalAlign(UI['loader'].lbl_info, "center", false)
	guiLabelSetVerticalAlign(UI['loader'].lbl_info, "top")
	guiLabelSetColor(UI['loader'].lbl_info, 0, 185, 255)

	UI['loader'].but_do = guiCreateButton(140, 85, 220, 25, wnd_do, false, UI['loader'].wnd)
	guiSetProperty(UI['loader'].but_do, "NormalTextColour", "ff5af542")

	UI['loader'].but_close = guiCreateButton(0, 85, 120, 25, "Закрыть", false, UI['loader'].wnd)
    guiSetProperty(UI['loader'].but_close, "NormalTextColour", "ffd43422")

    addEventHandler('onClientGUIClick', UI['loader'].wnd, function(button)
    	if not isElement(UI['loader'].wnd) then return end

    	if button == "left" and isElement(UI['loader'].wnd) then
    		if source == UI['loader'].but_close or source == UI['loader'].but_do then

    			if source == UI['loader'].but_do then
    				triggerServerEvent('exv_jobLoader.changeJobLoader', localPlayer, jobId)
    			end

    			destroyElement(UI['loader'].wnd)
    			showCursor(false)
    		end
    	end

    end)

	showCursor(true)
end
addEvent('exv_jobLoader.showLoaderJobWindow', true)
addEventHandler('exv_jobLoader.showLoaderJobWindow', root, showLoaderJobWindow)
-- GUI [КОНЕЦ] --

local keyPaneElement

local isPlayerTargetBox
local isPlayerClickedMouse = false
local isPlayerTargetSphere 

local function setPlayerTargetBox()
	local isPlayerBox = getElementData(localPlayer, 'exv_jobLoader:isPlayerBox')

	if isPlayerTargetBox and not isPlayerBox then
		isPlayerClickedMouse = true
		if isPedDucked(localPlayer) then setPedControlState(localPlayer, 'crouch', true) end

		triggerServerEvent('exv_jobLoader.setBoxPlayer', root, localPlayer, isPlayerTargetBox)

		setTimer(
			function ()
				exports.tmtaSounds:playSound('box_up')
			end, 1000, 1)

		setTimer(function()
			if (isElement(keyPaneElement)) then
				destroyElement(keyPaneElement)
			end
			keyPaneElement = exports.tmtaUI:guiCreateActionKey('keyMouseRight', 'Бросить ящик')
			isPlayerTargetBox = false
		end, 2000, 1)

	else
		if not isPlayerBox or isPlayerTargetBox then return end

		if isElement(isPlayerTargetSphere) then
			triggerServerEvent("exv_jobLoader.destroyBoxPlayer", root, localPlayer, true)
		else
			triggerServerEvent("exv_jobLoader.destroyBoxPlayer", root, localPlayer, false)
		end
		
		setTimer(
			function ()
				exports.tmtaSounds:playSound('box_down')
			end, 1000, 1)

		isPlayerTargetSphere = false
		setTimer(function() isPlayerClickedMouse = false end, 5000, 1)
		unbindKey("mouse2", "down", setPlayerTargetBox)
	end

	if isElement(keyPaneElement) then
		destroyElement(keyPaneElement)
	end	
end

local function onPlayerTargetBox() -- ВЫВОДИМ ПОДСКАЗКУ
	if isPlayerClickedMouse then 
		removeEventHandler("onClientRender", root, onPlayerTargetBox)
		return 
	end

	local x, y, z = getElementPosition(isPlayerTargetBox)
	local px, py, pz = getElementPosition(localPlayer)
	local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if distanceBetweenPoints < 1.8 then
		if not isElement(keyPaneElement) then
			keyPaneElement = exports.tmtaUI:guiCreateActionKey('keyMouseRight', 'Взять ящик')
		end
	else
		if isElement(keyPaneElement) then
			destroyElement(keyPaneElement)
		end
		removeEventHandler("onClientRender", root, onPlayerTargetBox)
		isPlayerTargetBox = false
		unbindKey("mouse2", "down", setPlayerTargetBox)
	end

end

addEventHandler("onClientPlayerTarget", localPlayer, function(box)
	if not getElementData(localPlayer, 'exv_jobLoader:loaderData') then 
		return 
	end

	if not box or isPlayerTargetBox or isPlayerClickedMouse then return end
	if not getElementType(box) == "object" then return end
	if not getElementData(box, "exv_jobLoader:isBox" ) then return end
	if getElementData(localPlayer, 'exv_jobLoader:isPlayerBox') then return end

	if (localPlayer:getData('exv_jobLoader:jobId') ~= box:getData('exv_jobLoader:jobId')) then
		return
	end

	isPlayerTargetBox = box

	unbindKey("mouse2", "down", setPlayerTargetBox)
	bindKey("mouse2", "down", setPlayerTargetBox)

	addEventHandler("onClientRender", root, onPlayerTargetBox)
end)

-- МАРКЕРЫ / БЛИПЫ --
local shipBlip, shipMarker, shipSphere

local function createShipMarker(remove) -- СОЗДАТЬ МАРКЕР/БЛИП ДЛЯ РАЗГРУЗКИ (КОРАБЛЬ)

	if remove then
		if isElement(shipMarker) then destroyElement(shipMarker) end
		if isElement(shipBlip) then destroyElement(shipBlip) end
		if isElement(shipSphere) then destroyElement(shipSphere) end

		return
	end

	if not isElement(shipMarker) then
		local jobId = localPlayer:getData('exv_jobLoader:jobId')
		local SHIP_POSITIONS = LOADER_WORK[jobId].ship

		local shipPosId = math.random(1, #SHIP_POSITIONS)
		shipMarker = createMarker(SHIP_POSITIONS[shipPosId].x, SHIP_POSITIONS[shipPosId].y, SHIP_POSITIONS[shipPosId].z, "arrow", 1.5, 255, 0, 0, 255)
		shipBlip = exports.tmtaBlip:createBlipAttachedTo(shipMarker, 'blipCheckpoint')
		shipSphere = createColSphere(SHIP_POSITIONS[shipPosId].x, SHIP_POSITIONS[shipPosId].y, SHIP_POSITIONS[shipPosId].z-1, 2)
		
		exports.tmtaNavigation:setPoint(shipMarker, 'Донесите ящик')

		addEventHandler("onClientColShapeHit", shipSphere, function(hitPlayer, matchingDimension) 
			if hitPlayer == localPlayer and matchingDimension then
				if (isElement(keyPaneElement)) then
					destroyElement(keyPaneElement)
				end
				keyPaneElement = exports.tmtaUI:guiCreateActionKey('keyMouseRight', 'Положить ящик')
				isPlayerTargetSphere = source
			end
		end)	

		addEventHandler("onClientColShapeLeave", shipSphere, function(hitPlayer, matchingDimension) 
			if hitPlayer == localPlayer and matchingDimension then
				local isPlayerBox = getElementData(localPlayer, 'exv_jobLoader:isPlayerBox')
				if isPlayerBox then
					if (isElement(keyPaneElement)) then
						destroyElement(keyPaneElement)
					end
					keyPaneElement = exports.tmtaUI:guiCreateActionKey('keyMouseRight', 'Бросить ящик')
					isPlayerTargetSphere = false
				end
			end
		end)

	end

end
addEvent('exv_jobLoader.createShipMarker', true)
addEventHandler('exv_jobLoader.createShipMarker', root, createShipMarker)

local storageFakeMarker
local function blipOnStorage(remove) -- СОЗДАТЬ БЛИП НА СКЛАДЕ
	if remove then 
		if isElement(storageFakeMarker) then
			destroyElement(storageFakeMarker)
		end
		return
	end

	if not isElement(storageFakeMarker) then
		local jobId = localPlayer:getData('exv_jobLoader:jobId')
		local BOX_POSITIONS = LOADER_WORK[jobId].box

		local storageId = math.random(1, #BOX_POSITIONS)
		storageFakeMarker = createMarker(BOX_POSITIONS[storageId].x, BOX_POSITIONS[storageId].y, BOX_POSITIONS[storageId].z, "cylinder", 0, 0, 0, 0, 0)

		exports.tmtaBlip:createBlipAttachedTo(storageFakeMarker, 'blipCheckpoint')
		exports.tmtaNavigation:setPoint(storageFakeMarker, 'Возьмите ящик')
	end
end
addEvent('exv_jobLoader.blipOnStorage', true)
addEventHandler('exv_jobLoader.blipOnStorage', root, blipOnStorage)

---------------------

local function onPlayerMarkerUnloadEvent(hitPlayer, matchingDimension)
	if hitPlayer == localPlayer and matchingDimension then
		local isPlayerBox = getElementData(localPlayer, 'exv_jobLoader:isPlayerBox')

		if isElementWithinMarker(localPlayer, source) then
			if isPlayerBox then
				if (isElement(keyPaneElement)) then
					destroyElement(keyPaneElement)
				end
				keyPaneElement = exports.tmtaUI:guiCreateActionKey('keyMouseRight', 'Положить ящик')
				isPlayerTargetSphere = source
				bindKey("mouse2", "down", setPlayerTargetBox)
			end
		else 
			if isPlayerBox then
				if (isElement(keyPaneElement)) then
					destroyElement(keyPaneElement)
				end
				unbindKey("mouse2", "down", setPlayerTargetBox)
				isPlayerTargetSphere = false
				return
			end
		end

	end
end

-- ВОЗМОЖНЫЕ БАГИ --
addEventHandler('onClientVehicleEnter', root, function(player)
	if player ~= localPlayer then return end
	if not getElementData(localPlayer, 'exv_jobLoader:isPlayerBox') then return end
	if (isElement(keyPaneElement)) then
		destroyElement(keyPaneElement)
	end

	triggerServerEvent("exv_jobLoader.destroyBoxPlayer", root, localPlayer)

	setTimer(
		function ()
			exports.tmtaSounds:playSound('box_down')
		end, 1000, 1)

	setTimer(function() isPlayerClickedMouse = false end, 5000, 1)
end)