--[[
Window_CHK = guiCreateWindow(screX/2-155,screY/2-60,400,180,"Скупка Т/С",false)
guiSetVisible(Window_CHK, false)
guiSetProperty(Window_CHK, "AlwaysOnTop", "true")
guiWindowSetSizable(Window_CHK, false)
Label_CHK = guiCreateLabel(10,15,380,100,"",false,Window_CHK)
guiLabelSetHorizontalAlign(Label_CHK,"center",true)
Button_CHK_Y = guiCreateButton(17,110,400,25,"Выставить на продажу.",false,Window_CHK)
Button_CHK_N = guiCreateButton(17,140,400,25,"Отказатся",false,Window_CHK)
]]


triggerServerEvent("onOpenGui", localPlayer)


function WINDOW_CLICK_VEHICLE (button, state, absoluteX, absoluteY)
	local id = guiGridListGetSelectedItem(Grid_VS)
	local ID = guiGridListGetItemData(Grid_VS, id, 1)
	local carName = guiGridListGetItemText(Grid_VS, id, 1)
	if source == Button_VS_close then
		guiSetVisible(Window_VS, false)
		showCursor(false)
	end
	if (source == Grid_VS) then
		if id == -1 and idd then
			guiGridListSetSelectedItem(Grid_VS, idd, 1)
			return false
		else
			idd = guiGridListGetSelectedItem(Grid_VS)
		end
	elseif (source == Button_VS_sn) then
		triggerServerEvent("SpawnMyVehicle", localPlayer, ID)
	elseif (source == Button_VS_dy) then 
		triggerServerEvent("DestroyMyVehicle", localPlayer, ID, carName)
	--elseif (source == Button_VS_lt) then 
		--triggerServerEvent("LightsMyVehicle", localPlayer, ID)
	--elseif (source == Button_VS_bp) then 
		--triggerServerEvent("BlipMyVehicle", localPlayer, ID)
	--elseif (source == Button_VS_lk) then 
		--triggerServerEvent("LockMyVehicle", localPlayer, ID)
	
	--[[
	elseif (source == Button_VS_sl) then 
		if localPlayer.vehicle and localPlayer.vehicle:getData("ID") == ID then
			if isElementWithinColShape(localPlayer.vehicle, sellcarColShape) then
				guiSetVisible(Window_CHK, true)
				local carName = guiGridListGetItemText(Grid_VS, guiGridListGetSelectedItem(Grid_VS), 1)
				local carprice = guiGridListGetItemText(Grid_VS, guiGridListGetSelectedItem(Grid_VS), 2)
				guiSetText(Label_CHK, 'Здравствуйте. Мы покупаем подержаные Т/С для дальнейшей их реализации.Мы проводим диагностику автомобиля и сообщаем вам цену за которую можем преобрести ваше Т/С, деньги вы получаете сразу , машина оформляется на нас и мы уже выставляем ее на продажу. По результату тех.осмотра мы предлагаем вам за "'..carName..'" сумму в  "'..carprice..'" Рублей.')
			else
	outputChatBox("[ARST Info]Для оформления авто на продажу вы должны быть на территории авторынка с Т/С которое желаете продать.", 255, 0, 0)
			end
		end
		]]
	elseif source == Button_VS_give then
		createPlayersList(id)
	--[[	
	elseif source == Button_CHK_Y then
		triggerServerEvent("SellMyVehicle", localPlayer, ID)
		guiSetVisible(Window_VS, false)
		guiSetVisible(Window_CHK, false)
		showCursor(false)
	elseif source == Button_CHK_N then
		guiSetVisible (Window_CHK, false)
		]]
		
	elseif source == Button_VS_Spc then
      if getElementInterior(localPlayer) == 0 then
if getElementData(localPlayer,"Stats") < 2 then
		SpecVehicle(ID)
end
end

	elseif source == Button_VS_Fix then
		triggerServerEvent("FixMyVehicle", localPlayer, ID)
	elseif source == Button_VS_Warp then
		triggerServerEvent("WarpMyVehicle", localPlayer, ID)
	elseif source == Button_PLS_Y then
		local row = guiGridListGetSelectedItem ( playerList_PLS )
		if row and row ~= -1 then
			-- if guiGridListGetItemText ( playerList_PLS, row, 1 ) == getPlayerName ( localPlayer ) then
				-- return true
			-- end
			if (tonumber(guiGetText (edit_PLS_price)) or 0) >= 0 then
				outputChatBox ( "Ожидайте ответа игрока", 10, 250, 10 )
				invitations_send = true
				triggerServerEvent ( 'inviteToBuyCarSended', localPlayer, guiGridListGetItemText ( playerList_PLS, row, 1 ), guiGetText (edit_PLS_price) or 0, guiGridListGetItemText(Grid_VS, id, 1), guiGridListGetItemData(Grid_VS, id, 1) )
				destroyElement ( Window_PLS )
			end
		end
	elseif source == Button_PLS_N then
		destroyElement ( Window_PLS)
	end
end
addEventHandler("onClientGUIClick", resourceRoot, WINDOW_CLICK_VEHICLE)

function invitationsClickVehicle ()
	if source == Button_ABC_Y then
		showCursor ( false )
		destroyElement ( Window_ABC )
		if exports.tmtaMoney:getPlayerMoney () >= ( tonumber(inv_price) or 0 ) then
			triggerServerEvent ("invitationBuyCarAccepted",localPlayer, inv_player, inv_acc, inv_price, inv_veh_name, inv_veh_id)
		else
			outputChatBox ( "У вас не хватает денег, сделка отменена", 250, 10, 10 )
			triggerServerEvent ("invitationBuyCarNotAccepted",localPlayer, inv_player )
		end
		if #listOfInvitations > 0 then
			createAcceptBuyCarWindow (listOfInvitations[1][1],listOfInvitations[1][2],listOfInvitations[1][3],listOfInvitations[1][4] )
			table.remove (listOfInvitations,1)
		end
	elseif source == Button_ABC_N then
		showCursor ( false )
		triggerServerEvent ("invitationBuyCarNotAccepted",localPlayer, inv_player )
		destroyElement ( Window_ABC )
		if #listOfInvitations > 0 then
			createAcceptBuyCarWindow (listOfInvitations[1][1],listOfInvitations[1][2],listOfInvitations[1][3],listOfInvitations[1][4] )
			table.remove (listOfInvitations,1)
		end
	end
end

addEventHandler("onClientGUIClick", resourceRoot, invitationsClickVehicle)

function createPlayersList (row_id)
	showCursor ( true )
	Window_PLS = guiCreateWindow(screX/2-155,screY/2-220,310,420,"Выбор покупателя",false)
	guiSetVisible(Window_PLS, true)
	guiSetProperty(Window_PLS, "AlwaysOnTop", "true")
	guiWindowSetSizable(Window_PLS, false)
	Label_PLS_info = guiCreateLabel(21,28,266,36,"Выберите покупателя и введите цену:",false,Window_PLS)
	edit_PLS_price = guiCreateEdit ( 110,58,90,36, guiGridListGetItemText(Grid_VS, row_id, 2) or 0, false, Window_PLS )
	guiLabelSetColor(Label_PLS_info, 38, 122, 216)
	guiLabelSetHorizontalAlign(Label_PLS_info,"center",true)
	Button_PLS_Y = guiCreateButton(17,379,129,36,"Выбор",false,Window_PLS)
	Button_PLS_N = guiCreateButton(161,379,129,36,"Отмена",false,Window_PLS)
	addEventHandler("onClientGUIChanged", edit_PLS_price, function(element) 
		guiSetText ( edit_PLS_price, string.gsub (guiGetText( edit_PLS_price ), "%a", "") )
	end)
	playerList_PLS = guiCreateGridList ( 21, 100, 268, 265, false, Window_PLS )
	local column = guiGridListAddColumn( playerList_PLS, "Игроки", 0.85 )
	if ( column ) then
		for id, player in ipairs(getElementsByType("player")) do
			local row = guiGridListAddRow ( playerList_PLS )
			guiGridListSetItemText ( playerList_PLS, row, column, getPlayerName ( player ), false, false )
		end
	end

end

--createPlayersList ()

listOfInvitations = {}
inv_player, inv_acc, inv_price, inv_veh_name, inv_veh_id = nil, nil, nil, nil, nil


addEvent("recieveInviteToBuyCar", true)
addEventHandler("recieveInviteToBuyCar", root, 
function(player, acc, price, veh_name, veh_id)
	if player and price and acc and veh_name and veh_id then
		if getPlayerFromName ( player ) then
			if not isElement ( Window_ABC ) then
				createAcceptBuyCarWindow (player,acc,price, veh_name, veh_id)
			else	
				table.insert ( listOfInvitations, {player,acc,price, veh_name, veh_id})
			end
		else
			outputChatBox ( "Игрок не найден, продажа отменена", source, 250, 10, 10)
		end
	end
end)

addEvent("cleanCarInvitations", true)
addEventHandler("cleanCarInvitations", root, 
function()
	invitations_send = false
end)

function createAcceptBuyCarWindow(player,acc,price, veh_name, veh_id)
	showCursor ( true )
	inv_player, inv_acc, inv_price, inv_veh_name, inv_veh_id = player,acc,price, veh_name, veh_id
	Window_ABC = guiCreateWindow(screX/2-155,screY/2-220,410,100,"Вам предложили купить машину",false)
	guiSetVisible(Window_ABC, true)
	guiSetProperty(Window_ABC, "AlwaysOnTop", "true")
	guiWindowSetSizable(Window_ABC, false)
	Label_ABC_info = guiCreateLabel(10,28,390,36,player.." предложил вам купить его автомобиль "..veh_name.." за "..price.." руб",false,Window_ABC)
	guiLabelSetColor(Label_ABC_info, 38, 216, 38)
	guiLabelSetHorizontalAlign(Label_ABC_info,"center",true)
	Button_ABC_Y = guiCreateButton(17,70,129,36,"Купить",false,Window_ABC)
	Button_ABC_N = guiCreateButton(264,70,129,36,"Не покупать",false,Window_ABC)
end

function SpecVehicle(id)

	if spc then 
		removeEventHandler("onClientPreRender", root, Sp)
		setCameraTarget(localPlayer)
		if isTimer(freezTimer) then killTimer(freezTimer) end
		freezTimer = setTimer(function() setElementFrozen(localPlayer, false) end, 2500, 1)
		spc = false
	return end
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		if getElementData(vehicle, "Owner") == localPlayer and getElementData(vehicle, "ID") == id then
			cVeh = vehicle
			spc = true
			addEventHandler("onClientPreRender", root, Sp)
			guiSetVisible(Window_VS, false)
			showCursor(false)
			break
		  end
                        
	end
end

function Sp()
	if isElement(cVeh) then
		local x, y, z = getElementPosition(cVeh)
		setElementFrozen(localPlayer, true)
		setCameraMatrix(x, y-1, z+15, x, y, z)

	else
		removeEventHandler("onClientPreRender", root, Sp)
		setCameraTarget(localPlayer)
		if isTimer(freezTimer) then killTimer(freezTimer) end
		freezTimer = setTimer(function() setElementFrozen(localPlayer, false) end, 2500, 1)
		spc = false
      end
end
 
 


--[[
addEventHandler("onClientRender", getRootElement(), function()
	for index, car in pairs(getElementsByType('vehicle')) do
        if car:getData("sellInfo") then
			local sellInfo = car:getData("sellInfo")
			local x, y, z = getElementPosition(car)
			local x2, y2, z2 = getElementPosition(localPlayer)				
			z = z+1
			local sx, sy = getScreenFromWorldPosition(x, y, z)
			if(sx) and (sy) then
				local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
				if(distance < 20) then
					local fontbig = 2-(distance/10)
					dxDrawBorderedCarText("Цена: "..tostring(sellInfo.price).." руб", sx, sy, sx, sy, tocolor(255, 255, 255, 200,true), fontbig, "default-bold", "center")	
				end
			end
		end
	end
end)

function dxDrawBorderedCarText( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x - 1, y, w - 1, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x + 1, y, w + 1, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y - 1, w, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y + 1, w, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
end

local sellGUI = {}
sellGUI.window = guiCreateWindow(155,60,400,180,"Оформление Т/С",false)
guiSetVisible(sellGUI.window, false)
guiSetProperty(sellGUI.window, "AlwaysOnTop", "true")
guiWindowSetSizable(sellGUI.window, false)
sellGUI.label = guiCreateLabel(10,20,380,100,"",false,sellGUI.window)
guiLabelSetHorizontalAlign(sellGUI.label,"center",true)
sellGUI.yes = guiCreateButton(17,110,400,25,"Приобрести",false,sellGUI.window)
sellGUI.no = guiCreateButton(17,140,400,25,"Отказатся",false,sellGUI.window)

addEvent("showBuyGUI", true)
addEventHandler("showBuyGUI", root, function ()
	local sellInfo = source:getData("sellInfo") 
	if type(sellInfo) ~= "table" then
		return
	end
	showCursor(true)
	sellGUI.window.visible = true
	sellGUI.label.text = "Здравствуйте.Вам понравилось это Т/С ? Его можно приобрести. Цена данного Т/С " .. tostring(sellInfo.price) .. " рублей. При регистрации авто на вас мы поставим вам номера которые вы сможите сменить в отделении полиции или оставить так как есть. Вы будете покупать? "
end)

addEvent("hideBuyGUI", true)
addEventHandler("hideBuyGUI", root, function ()
	showCursor(false)
	sellGUI.window.visible = false
end)


addEventHandler("onClientGUIClick", sellGUI.window, function ()
	showCursor(false)
	sellGUI.window.visible = false	
	if source == sellGUI.yes then
		Button_VS_sl.enabled = true
		local sellInfo = localPlayer.vehicle:getData("sellInfo") 
		if type(sellInfo) ~= "table" then
			return
		end			
		
		local veh = getPedOccupiedVehicle(localPlayer)
		
		if veh and isElement(veh) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		
			local r1, g1, b1, r2, g2, b2 = getVehicleColor(localPlayer.vehicle, true)
			triggerServerEvent("onBuyNewVehicle", localPlayer, 
				localPlayer.vehicle.model, 
				sellInfo.price, 
				r1, g1, b1, r2, g2, b2,
				true
			)
		end 
	else
		setControlState("enter_exit", true)
	end
end)
]]