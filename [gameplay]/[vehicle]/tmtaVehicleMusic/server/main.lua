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

local function getTrackItem()
end

local function parsePage(data, err, player)
    local musicList = {}
	local lastPos = 0
	
	if data == "ERROR" then return end
	local posStart, posEnd = utf8.find(data, '<div id="allEntries">')
	lastPos = posEnd
	--iprint(posEnd)

    -- https://s1.songi.net/files/mp3/kirill_moyton_-_ya_budu_tebya_ispol_zovat__songi.net_128.mp3

    local data = utf8.sub(data, posStart, posEnd)
    for i = 1, 50 do
        local pos_start, pos_e = utf8.find(data, '<div id="entryID%d+"', lastPos)
        pos_e = pos_e and pos_e or 0
    end
end

local function getItemData(item)
	local startPos = utf8.find(item, "{")
	local endPos = utf8.find(item, "}")
	if startPos and endPos then else return end
	return fromJSON(utf8.sub(item, startPos, endPos))
end

local function searchCallback(result, _, player)
    if result == "ERROR" then 
        return
    end

    local trackList = {}
	local start = utf8.find(result, '<ul class="tracks__list">')

	local text
	local endpos = 0
	local soundsCount = 0
	local proccesed = ""

    if start then
        text = utf8.sub(result, start)
		local musics = utf8.gmatch(text, 'class="tracks__item track mustoggler"')
        for k in musics do
			local start, endPosition = utf8.find(text, k, endpos)
			local _, endPositionB = utf8.find(text, "</li>", start)
			local currentSection = utf8.sub(text,start, endPositionB)

            endpos = endPosition
            local trackData = getItemData(currentSection)

            soundsCount = soundsCount + 1
            table.insert(trackList, {author = trackData.artist, name = trackData.title, url = trackData.url})
        end
    end

    triggerClientEvent(player, "returnMusicSearch", player, trackList)
end

addEvent("onPlayerSearchMusic", true)
addEventHandler("onPlayerSearchMusic", root, 
    function(text)
        if utf8.len(text) >= 1 then
            fetchRemote("https://rus.hitmotop.com/search?q="..utf8.gsub(text, " ", "+"), searchCallback, "", false, client)
        else
            fetchRemote("https://rus.hitmotop.com/songs/top-today", searchCallback, "", false, client)
        end
    end
)

addEvent("setVehicleSound", true )
addEventHandler("setVehicleSound", resourceRoot, function( vehicle, data, playlist )
    if isElement(vehicle) then
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

addEvent("setVehicleSoundPaused", true)
addEventHandler("setVehicleSoundPaused", resourceRoot, function( vehicle, state )
    if isElement( vehicle ) then
        local data = vehicle:getData( "music:data" )
        if data then
            data.pause = state
            vehicle:setData( "music:data", data )

            triggerClientEvent( "setVehicleSoundPaused", resourceRoot, vehicle, state )
        end
    end
end )