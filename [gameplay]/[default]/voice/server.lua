local nearbyPlayers = {} 

addEventHandler("onPlayerVoiceStart", root, 
    function() 
        local r = 7 
        local posX, posY, posZ = getElementPosition(source) 
        local chatSphere = createColSphere(posX, posY, posZ, r) 
        nearbyPlayers = getElementsWithinColShape(chatSphere, "player") 
        destroyElement(chatSphere)
	   
        local empty = exports.voice:getNextEmptyChannel() 
        exports.voice:setPlayerChannel(source, empty) 
        for index, player in ipairs(nearbyPlayers) do 
            exports.voice:setPlayerChannel(player, empty) 
        end 
    end 
) 

addEventHandler("onPlayerVoiceStop", root, 
    function() 
        exports.voice:setPlayerChannel(source) 
        for index, player in ipairs(nearbyPlayers) do 
            exports.voice:setPlayerChannel(player) 
        end 
        nearbyPlayers = {} 
    end 
) 