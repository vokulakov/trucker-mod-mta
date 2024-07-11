local function getMusicArtist(data, startS)
	if not data then return end
    local _, pos_e = utf8.find(data, '<a class="track__artist"', startS)
	local _, pos_start  = utf8.find(data, '<b>', pos_e)
	local pos_end  = utf8.find(data, '</b>', pos_start)
	
	local text_artist = utf8.sub(data, pos_start + 1, pos_end -1)
	local pos_start, pos_e = utf8.find(data, '">', pos_end)
	local pos_end  = utf8.find(data, "</a>", pos_e)
	
	local text_music = utf8.sub(data, pos_e + 1, pos_end - 1)
	return text_artist, text_music
end

local function parsePage(data, err, player)
    local musicList = {}
	local lastPos = 0
	
	if data == "ERROR" then return end
	local _, s = utf8.find(data, '<div class="results">')
	lastPos = s
	
	for i = 1, 30 do
		local pos_start, pos_e = utf8.find(data, '<div class="chkd"', lastPos)
		pos_e = pos_e and pos_e or 0
		local _, pos_end  = utf8.find(data, '.mp3"', pos_e + 28)
	
		local url = utf8.sub(data, pos_e + 12, pos_end - 1)
		
		local startS = utf8.find(data, '<span class="title">', lastPos)
		local _, endS = utf8.find(data, '</span>', startS)
	
		local artist, musicName = getMusicArtist(data, startS)
		
		if artist and musicName and url then
		    table.insert(musicList, {author = artist, name = musicName, url = url})
		end
	    lastPos = endS
	end

    triggerClientEvent(player, "returnMusicSearch", player, musicList)
end

addEvent("onPlayerSearchMusic", true)
addEventHandler("onPlayerSearchMusic", root, 
    function(text)
        if utf8.len(text) >= 1 then
            fetchRemote("https://dydki.info/?mp3="..utf8.gsub(text, " ", "+"), parsePage, "", false, client)
        else
            fetchRemote("https://dydki.info/", parsePage, "", false, client)
        end
    end
)

addEvent( "setVehicleSound", true )
addEventHandler( "setVehicleSound", resourceRoot, function( vehicle, data, playlist )
    if isElement( vehicle ) then

        local music_data = {
            name = data.name,
            author = data.author,
            url = data.url,
            playlist = playlist,
            pause = false,
        }

        vehicle:setData( "music:data", music_data )
        
        triggerClientEvent( "setVehicleSound", resourceRoot, vehicle, music_data )
    end
end )

addEvent( "setVehicleSoundPaused", true )
addEventHandler( "setVehicleSoundPaused", resourceRoot, function( vehicle, state )
    if isElement( vehicle ) then
        local data = vehicle:getData( "music:data" )
        if data then
            data.pause = state
            vehicle:setData( "music:data", data )

            triggerClientEvent( "setVehicleSoundPaused", resourceRoot, vehicle, state )
        end
    end
end )