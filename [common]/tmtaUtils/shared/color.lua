--@link https://wiki.multitheftauto.com/wiki/Tocolor2rgba
function fromColor(color)
    if (not color or type(color) ~= 'number') then
        return false
    end

    local b = bitExtract(color, 0, 8) 
    local g = bitExtract(color, 8, 8) 
    local r = bitExtract(color, 16, 8) 
    local a = bitExtract(color, 24, 8)

    return r, g, b, a
end

--@link https://wiki.multitheftauto.com/wiki/Hex2rgb
function hexToRGB(hex) 
    if type(hex) ~= 'string' then 
        return false
    end
    hex = hex:gsub("#","") 
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) 
end 

--@link https://wiki.multitheftauto.com/wiki/RGBToHex
function RGBToHex(red, green, blue, alpha)
	if ((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end

	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end

function colorToHEX(color, enableAlpha)
    local r, g, b, a = fromColor(color)
    if not r then
        return false
    end
    enableAlpha = enableAlpha or false
    return RGBToHex(r, g, b, enableAlpha and a or nil)
end
