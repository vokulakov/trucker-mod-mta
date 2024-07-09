local sx,sy = guiGetScreenSize()
local resStat = false
local serverStats = nil
local serverColumns, serverRows = {}, {}
local fps = 0
local nextTick = 0

function isAllowed()
	return true
end

addCommandHandler("stat", function()
	if isAllowed() then
		resStat = not resStat
		if resStat then
			outputChatBox("Resource stats enabled", 0, 255, 0, true)
			addEventHandler("onClientRender", root, resStatRender)
			addEventHandler("onClientPreRender", root, updateFPS)
			triggerServerEvent("getServerStat", localPlayer)
		else
			outputChatBox("Resource stats disabled", 255, 0, 0, true)
			removeEventHandler("onClientRender", root, resStatRender)
			removeEventHandler("onClientPreRender", root, updateFPS)
			serverStats = nil
			serverColumns, serverRows = {}, {}
			triggerServerEvent("destroyServerStat", localPlayer)
		end
	end
end)

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, function(stat1,stat2)
	serverStats = true
	serverColumns, serverRows = stat1,stat2
end)

function resStatRender()
	dxDrawText(math.floor(fps).." fps  |  "..getPlayerPing(localPlayer).." ms.", 1, 1, sx+1, 25+1, tocolor(0, 0, 0), 1, "default-bold", "center", "center")
	dxDrawText(math.floor(fps).." fps  |  "..getPlayerPing(localPlayer).." ms.", 0, 0, sx, 25, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end
	local columns, rows = getPerformanceStats("Lua timing")
	local height = (15*#rows)
	local y = sy/2-height/2
	if #serverRows == 0 then
		dxDrawText("Клиент",sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1,"default-bold","center")
	else
		dxDrawText("Клиент",sx-235,y-20,sx-235,y-20,tocolor(255,255,255,255),1,"default-bold","center")
	end
	dxDrawRectangle(x-10,y,150,height,tocolor(0,0,0,150))
	y = y + 5
	for i, row in ipairs(rows) do
		local text = row[1]:sub(0,15)..": "..row[2]
		dxDrawText(text,x,y,150,15,tocolor(255,255,255,255),1,"default-bold")
		y = y + 15
	end
	
	if #serverRows ~= 0 then
		local x = sx-140
		local height = (15*#serverRows)
		local y = sy/2-height/2
		dxDrawText("Сервер",sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1,"default-bold","center")
		dxDrawRectangle(x-10,y,150,height+15,tocolor(0,0,0,150))
		y = y + 5
		for i, row in ipairs(serverRows) do
			local text = row[1]:sub(0,15)..": "..row[2]
			dxDrawText(text,x,y,150,15,tocolor(255,255,255,255),1,"default-bold")
			y = y + 15
		end
	end

	local video = dxGetStatus()
	local num = 0
	for i,v in pairs(video) do
		num = num + 1
		if num % 2 == 0 then
			dxDrawText(i..": "..tostring(v), 0, 25+7*(num-1), sx/2-20, 25+7*num, tocolor(255, 255, 255), 1, "default-bold", "right", "bottom")
		else
			dxDrawText(i..": "..tostring(v), sx/2+20, 25+7*(num-1), sx, 25+7*num, tocolor(255, 255, 255), 1, "default-bold", "left", "bottom")
		end
	end
end

function updateFPS(msSinceLastFrame)
    local now = getTickCount()
    if (now >= nextTick) then
        fps = (1 / msSinceLastFrame) * 1000
        nextTick = now + 1000
    end
end