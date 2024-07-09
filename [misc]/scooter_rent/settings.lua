Settings = { 

	timeArenda = 15,
	
	moneyArenda = 500,
	
	id = 462,
	
	markers = {
		{ 379, -2434, 8 }, -- база ДБ

		-- Больнички
		{ 1184.299, -1306.919, 13.6 }, -- Market (Los Santos)
		{ 1998.986, -1441.462, 13.565 }, -- Idlewood (Los Santos)

		{ 1248.044, 353.445, 19.555 }, -- Montogomery (Red County)
		{ -322.906, 1055.949, 19.745 }, -- Fort Carson (Bone County)
		{ 1580.763, 1840.583, 10.821 },  -- Las Venturas Airport (Las Venturas)
		{ -1510.952, 2538.625, 55.7 }, -- El Quebrados (Tierra Robada)
		{ -2646.086, 615.833, 14.455 }, -- Santa Flora (San Fierro)
		{ -2175.925, -2284.627, 30.625 }, -- Angel Pine (Whetstone)

	},

}

function convertNumber(number) 
	while true do      
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')    
		if k==0 then      
			break   
		end  
	end  
	return number
end

function removeHex (s)
    if type (s) == "string" then
        while (s ~= s:gsub ("#%x%x%x%x%x%x", "")) do
            s = s:gsub ("#%x%x%x%x%x%x", "")
        end
    end
    return s or false
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
               for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
        	         return true
        	    end
	       end
	  end
     end
     return false
end