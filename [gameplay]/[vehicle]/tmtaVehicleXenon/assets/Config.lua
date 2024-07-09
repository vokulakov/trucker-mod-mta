Config = {}

--[[
Config.xenonColors = {
    { name="3200K", price=30000, color={255, 254, 205 }},
    { name="4000K", price=30000, color={229, 230, 255 }},
    { name="4300K", price=30000, color={183, 186, 255 }},
    { name="5000K", price=30000, color={145, 150, 255 }},
    { name="6000K", price=30000, color={105, 112, 255 }},
    { name="7500K", price=30000, color={63, 72, 255 }},
    { name="Red 3200k",   price=60000, color={255, 105, 105 }},
    { name="Red 5000k",   price=60000, color={255, 57, 57 }},	
    { name="Red 7500k",   price=60000, color={255, 0, 0 }},		
    { name="Blue 3200k",   price=60000, color={107, 149, 255 }},
    { name="Blue 5000k",   price=60000, color={31, 94, 255 }},	
    { name="Blue 7500k",   price=60000, color={0, 48, 171 }},	
    { name="Gold 3200k",   price=60000, color={245, 255, 105 }},
    { name="Gold 5000k",   price=60000, color={242, 255, 64 }},	
    { name="Gold 7500k",   price=60000, color={207, 219, 39 }},	
    { name="Green 3200k",   price=60000, color={114, 255, 107 }},
    { name="Green 5000k",   price=60000, color={63, 252, 53 }},	
    { name="Green 7500k",   price=60000, color={9, 181, 0 }},
    { name="Purple 3200k",   price=60000, color={255, 97, 231 }},
    { name="Purple 5000k",   price=60000, color={255, 41, 223 }},	
    { name="Purple 7500k",   price=60000, color={181, 0, 154 }},
}
]]

Config.price = 2500

function convertNumber(number)
	return tostring(exports.tmtaUtils:formatMoney(number))
end