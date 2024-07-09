function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamEnabled", getRootElement(), x, y, z, dontChangeFixedMode)
end

local isDebug = false

function setAdminMode (player)
    if (isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(player)), aclGetGroup("Admin"))) then
        local veh = getPedOccupiedVehicle (player)
		if isDebug == false then
			if not veh then
				local x,y,z = getElementPosition(player)
				setPlayerFreecamEnabled(player, x, y, z)
				setElementAlpha(player, 0)
				setElementFrozen(player, true)
			else
				local x,y,z = getElementPosition(veh)
				setPlayerFreecamEnabled(veh, x, y, z)
				setElementFrozen(veh, true)
			end
	    else
			if not veh then
				setPlayerFreecamDisabled(player)
				setElementAlpha(player, 255)
				setElementFrozen(player, false)
			else
				setPlayerFreecamDisabled(veh)
				setElementFrozen(veh, false)
			end
	    end
	    isDebug = not isDebug
	end
end

addEventHandler ("onPlayerJoin",root,function()
	bindKey (source,"e","down",setAdminMode)
end)

addEventHandler ("onResourceStart",resourceRoot,function()
	for i,v in ipairs (getElementsByType("player")) do
		bindKey (v,"e","down",setAdminMode)
	end
end)


addCommandHandler("fly", setAdminMode)


function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", getRootElement(), dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecam:state")
end

-- function onAdminComand (player, cmd)
    -- if (isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(player)), aclGetGroup("Admin"))) or (isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(player)), aclGetGroup("SuperModerator"))) then
	    -- if cmd == "fix" then
		    -- local vehicle = getPedOccupiedVehicle(player)
			-- if not vehicle then outputChatBox("#C7C7C7*Вы #FF0000не #C7C7C7в тс!", player, 0, 255, 0,true) return end
			-- fixVehicle(vehicle)
			-- setElementHealth(vehicle, 1000)
			-- outputChatBox("#C7C7C7*ТС #00FF00Починена!", player, 0, 255, 0,true)
		-- elseif cmd == "gm" then
		    -- if not getElementData(player, "god_mode") then setElementData(player, "god_mode", false) end
			-- local god = getElementData(player, "god_mode")
			-- if god == false then
			    -- setElementData(player, "god_mode", not god)
				-- outputChatBox("#C7C7C7*GM #00FF00Включен!", player, 0, 255, 0,true)
			-- elseif god == true then --Gm
			    -- setElementData(player, "god_mode", not god)
				-- outputChatBox("#C7C7C7*GM #FF0000Выключен!", player, 0, 255, 0,true)
			-- end
		-- elseif cmd == "hp" then --Дает хп
		    -- setElementHealth(player, 100)
			-- outputChatBox("#C7C7C7*HP #00FF00восстановлено!", player, 0, 255, 0,true)
		-- elseif cmd == "arm" then -- Дате броню
		    -- setPedArmor(player, 100)
			-- outputChatBox("#C7C7C7*Броня #00FF00восстановленна!", player, 0, 255, 0,true)
		-- end
	-- end
-- end
-- addCommandHandler("fix", onAdminComand) --Чинит авто
-- addCommandHandler("gm", onAdminComand) --Гм
-- addCommandHandler("hp", onAdminComand) --Дает Хп
-- addCommandHandler("arm", onAdminComand) --Дает Броню
