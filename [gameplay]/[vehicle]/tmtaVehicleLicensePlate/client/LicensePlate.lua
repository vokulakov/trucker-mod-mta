LicensePlate = {}
LicensePlate.created = {}

LicensePlate.width = 256
LicensePlate.height = 64

LicensePlate.texture = {
    plate_default       = exports.tmtaTextures:createTexture('vehiclePlate0'),
    plate_ru            = exports.tmtaTextures:createTexture('vehiclePlate1'),
    plate_ru_no_flag    = exports.tmtaTextures:createTexture('vehiclePlate2'),
    plate_ru_tr         = exports.tmtaTextures:createTexture('vehiclePlate3'),
    plate_ru_federal    = exports.tmtaTextures:createTexture('vehiclePlate4'),
    plate_by            = exports.tmtaTextures:createTexture('vehiclePlate5'),
    plate_kz            = exports.tmtaTextures:createTexture('vehiclePlate6'),
    plate_az            = exports.tmtaTextures:createTexture('vehiclePlate7'),
    plate_ua            = exports.tmtaTextures:createTexture('vehiclePlate8'),
    plate_arm           = exports.tmtaTextures:createTexture('vehiclePlate9'),
}

LicensePlate.font = {
    ['RoadNumbers_18'] = exports.tmtaFonts:createFontDX('RoadNumbers', 18),
    ['RoadNumbers_28'] = exports.tmtaFonts:createFontDX('RoadNumbers', 28),

    ['EuroPlate_28'] = exports.tmtaFonts:createFontDX('EuroPlate', 28),
    ['KZNumber_72'] = exports.tmtaFonts:createFontDX('KZNumber', 72),

    ['GOSTTypeBU_42'] = exports.tmtaFonts:createFontDX('GOSTTypeBU', 42, true),
}

local function isLicensePlateTextureValid(textureName)
    if (not textureName or type(textureName) ~= 'string') then
        outputDebugString('isLicensePlateTextureValid: bad arguments', 1)
        return false
    end
    return not not LicensePlate.texture[textureName]
end

local _dxDrawText = dxDrawText
local function dxDrawText(offsetX, offsetY, mul, text, x, y, ex, ey, c, s, ...)
    if (not text) then return end
	return _dxDrawText(text, (x)*mul + offsetX, (y)*mul + offsetY, (ex)*mul + offsetX, (ey)*mul + offsetY, c, s*mul, ...)
end

local _dxDrawImage = dxDrawImage
local function dxDrawImage(offsetX, offsetY, mul, x, y, ex, ey, ...)
	return _dxDrawImage((x)*mul + offsetX, (y)*mul + offsetY, (ex)*mul, (ey)*mul, ...)
end

local function dxDrawDefaultLicensePlateTexture(vehicle, _, forGUI)
    if not forGUI then
        local r, g, b = getVehicleColor(vehicle, true)
        local color = vehicle:getData('BodyColor')
        if (color and type(color) == 'table') then
            r, g, b = color[1], color[2], color[3]
        end
        dxDrawRectangle(0, 0, LicensePlate.width, LicensePlate.height, tocolor(r, g, b, 255))
    end
    
    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_default'])
end

local function dxDrawRuLicensePlateRegion(numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'table') then
        return 
    end

    if (numberPlate[9]) then
        dxDrawText(0, 0, 1, numberPlate[7], 188, 1, 218, 36, tocolor(0, 0, 0, 255), 0.9, 1.0, LicensePlate.font['RoadNumbers_18'], 'center', 'bottom')
        dxDrawText(0, 0, 1, numberPlate[8], 218, 1, 224, 36, tocolor(0, 0, 0, 255), 0.9, 1.0, LicensePlate.font['RoadNumbers_18'], 'center', 'bottom')
        dxDrawText(0, 0, 1, numberPlate[9], 224, 1, 254, 36, tocolor(0, 0, 0, 255), 0.9, 1.0, LicensePlate.font['RoadNumbers_18'], 'center', 'bottom')
    else
        dxDrawText(0, 0, 1, numberPlate[7], 202, 1, 215, 36, tocolor(0, 0, 0, 255), 0.9, 1.0, LicensePlate.font['RoadNumbers_18'], 'center', 'bottom')
        dxDrawText(0, 0, 1, numberPlate[8], 220, 1, 235, 36, tocolor(0, 0, 0, 255), 0.9, 1.0, LicensePlate.font['RoadNumbers_18'], 'center', 'bottom')
    end
end

local function dxDrawRuLicensePlate(numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'table') then
        return 
    end

    dxDrawText(0, 0, 1, numberPlate[1], 10, 5, 35, LicensePlate.height, tocolor(0, 0, 0, 255), 0.9, 1.05, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[2], 43, 5, 68, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[3], 71, 5, 96, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[4], 99, 5, 124, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[5], 130, 5, 155, LicensePlate.height, tocolor(0, 0, 0, 255), 0.9, 1.05, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[6], 160, 5, 180, LicensePlate.height, tocolor(0, 0, 0, 255), 0.9, 1.05, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
end

--- Русский
local function dxDrawRuLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)
    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_ru'])
    dxDrawRuLicensePlate(numberPlate)
    dxDrawRuLicensePlateRegion(numberPlate)
end

--- Русский (без флага)
local function dxDrawRuNoFlagLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)
    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_ru_no_flag'])
    dxDrawRuLicensePlate(numberPlate)
    dxDrawRuLicensePlateRegion(numberPlate)
end

--- Русский (федеральный)
local function dxDrawRuFederalLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)
    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_ru_federal'])
    dxDrawRuLicensePlate(numberPlate)
end

--- Русский (транзитный)
local function dxDrawRuTrLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)

    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_ru_tr'])
    
    dxDrawText(0, 0, 1, numberPlate[1], 10, 5, 35, LicensePlate.height, tocolor(0, 0, 0, 255), 0.9, 1.05, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[2], 40, 5, 65, LicensePlate.height, tocolor(0, 0, 0, 255), 0.9, 1.05, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[3], 70, 5, 95, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[4], 98, 5, 123, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[5], 126, 5, 152, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[6], 160, 5, 178, LicensePlate.height, tocolor(0, 0, 0, 255), 0.9, 1.05, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawRuLicensePlateRegion(numberPlate)
end

--- Русский (для прицепа)
local function dxDrawRuTrailerLicensePlateTexture(trailer, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)

    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_ru'])
    
    dxDrawText(0, 0, 1, numberPlate[1], 10, 5, 35, LicensePlate.height, tocolor(0, 0, 0, 255), 0.9, 1.05, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[2], 40, 5, 65, LicensePlate.height, tocolor(0, 0, 0, 255), 0.9, 1.05, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[3], 70, 5, 95, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[4], 98, 5, 123, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[5], 126, 5, 152, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[6], 160, 5, 178, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawRuLicensePlateRegion(numberPlate)
end

--- Белорусский
local function dxDrawByLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)

    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_by'])

    dxDrawText(0, 0, 1, numberPlate[1], 40, 0, 65, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[2], 65, 0, 90, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[3], 90, 0, 115, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[4], 115, 0, 140, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[5], 150, 0, 175, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[6], 180, 0, 205, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')

    if not numberPlate[7] then return end
    dxDrawText(0, -10, 1, '-', 205, 0, 225, LicensePlate.height, tocolor(0, 0, 0, 255), 0.5, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[7], 225, 0, 245, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
end

--- Казахстанский
local function dxDrawKzLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)

    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_kz'])

    dxDrawText(0, 30, 1, numberPlate[1], 43, 0, 66, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.0, LicensePlate.font['KZNumber_72'], 'center', 'center')
    dxDrawText(0, 30, 1, numberPlate[2], 66, 0, 89, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.0, LicensePlate.font['KZNumber_72'], 'center', 'center')
    dxDrawText(0, 30, 1, numberPlate[3], 89, 0, 112, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.0, LicensePlate.font['KZNumber_72'], 'center', 'center')

    if (numberPlate[6] and pregFind(numberPlate[6], '[0-9]')) then
        dxDrawText(0, 30, 1, numberPlate[4], 125, 0, 150, LicensePlate.height, tocolor(0, 0, 0, 255), 0.65, 0.8, LicensePlate.font['KZNumber_72'], 'center', 'center')
        dxDrawText(0, 30, 1, numberPlate[5], 150, 0, 175, LicensePlate.height, tocolor(0, 0, 0, 255), 0.65, 0.8, LicensePlate.font['KZNumber_72'], 'center', 'center')

        numberPlate[8] = numberPlate[7]
        numberPlate[7] = numberPlate[6]
    else
        dxDrawText(0, 30, 1, numberPlate[4], 116, 0, 139, LicensePlate.height, tocolor(0, 0, 0, 255), 0.65, 0.8, LicensePlate.font['KZNumber_72'], 'center', 'center')
        dxDrawText(0, 30, 1, numberPlate[5], 139, 0, 162, LicensePlate.height, tocolor(0, 0, 0, 255), 0.65, 0.8, LicensePlate.font['KZNumber_72'], 'center', 'center')
        dxDrawText(0, 30, 1, numberPlate[6], 162, 0, 185, LicensePlate.height, tocolor(0, 0, 0, 255), 0.65, 0.8, LicensePlate.font['KZNumber_72'], 'center', 'center')
    end

    dxDrawText(0, 30, 1, numberPlate[7], 197, 0, 222, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.0, LicensePlate.font['KZNumber_72'], 'center', 'center')
    dxDrawText(0, 30, 1, numberPlate[8], 222, 0, 245, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.0, LicensePlate.font['KZNumber_72'], 'center', 'center')
end

--- Азербайджанский
local function dxDrawAzLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)

    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_az'])

    dxDrawText(0, 0, 1, numberPlate[1], 45, 0, 60, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[2], 65, 0, 80, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')

    if not numberPlate[3] then return end
    dxDrawText(0, -10, 1, '-', 80, 0, 105, LicensePlate.height, tocolor(0, 0, 0, 255), 0.5, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[3], 105, 0, 125, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[4], 135, 0, 155, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')

    if not numberPlate[5] then return end
    dxDrawText(0, -10, 1, '-', 155, 0, 180, LicensePlate.height, tocolor(0, 0, 0, 255), 0.5, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[5], 180, 0, 200, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[6], 200, 0, 225, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[7], 225, 0, 245, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['GOSTTypeBU_42'], 'center', 'center')
end

--- Украинский
local function dxDrawUaLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)

    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_ua'])

    dxDrawText(0, -8, 1, numberPlate[1], 38, 0, 58, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.3, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, -8, 1, numberPlate[2], 62, 0, 82, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.3, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[3], 90, 0, 115, LicensePlate.height, tocolor(0, 0, 0, 255), 0.8, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[4], 115, 0, 140, LicensePlate.height, tocolor(0, 0, 0, 255), 0.8, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[5], 140, 0, 165, LicensePlate.height, tocolor(0, 0, 0, 255), 0.8, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[6], 165, 0, 190, LicensePlate.height, tocolor(0, 0, 0, 255), 0.8, 1.0, LicensePlate.font['RoadNumbers_28'], 'center', 'center')

    dxDrawText(0, -8, 1, numberPlate[7], 198, 0, 218, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.3, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
    dxDrawText(0, -8, 1, numberPlate[8], 222, 0, 242, LicensePlate.height, tocolor(0, 0, 0, 255), 0.75, 1.3, LicensePlate.font['RoadNumbers_28'], 'center', 'center')
end

--- Армянский
local function dxDrawArmLicensePlateTexture(vehicle, numberPlate)
    if (not numberPlate or type(numberPlate) ~= 'string') then
        return 
    end
    numberPlate = Utils.splitLicensePlate(numberPlate)

    dxDrawImage(0, 0, 1, 0, 0, LicensePlate.width, LicensePlate.height, LicensePlate.texture['plate_arm'])

    dxDrawText(0, 0, 1, numberPlate[1], 50, 0, 75, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['EuroPlate_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[2], 75, 0, 100, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['EuroPlate_28'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[3], 110, 0, 135, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['EuroPlate_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[4], 135, 0, 160, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.00, LicensePlate.font['EuroPlate_28'], 'center', 'center')

    dxDrawText(0, 0, 1, numberPlate[5], 170, 0, 195, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['EuroPlate_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[6], 195, 0, 220, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['EuroPlate_28'], 'center', 'center')
    dxDrawText(0, 0, 1, numberPlate[7], 220, 0, 245, LicensePlate.height, tocolor(0, 0, 0, 255), 0.85, 1.0, LicensePlate.font['EuroPlate_28'], 'center', 'center')
end

local enumLicensePlateTypeFunction = {
    default = dxDrawDefaultLicensePlateTexture,
    ru = dxDrawRuLicensePlateTexture,
    ru_no_flag = dxDrawRuNoFlagLicensePlateTexture,
    ru_tr = dxDrawRuTrLicensePlateTexture,
    ru_trailer = dxDrawRuTrailerLicensePlateTexture,
    ru_federal = dxDrawRuFederalLicensePlateTexture,
    by = dxDrawByLicensePlateTexture,
    kz = dxDrawKzLicensePlateTexture,
    az = dxDrawAzLicensePlateTexture,
    ua = dxDrawUaLicensePlateTexture,
    arm = dxDrawArmLicensePlateTexture,
}

local function getTextureCacheKey(licensePlateType, licensePlate)
    if (not licensePlateType or type(licensePlateType) ~= 'string' or not licensePlate or type(licensePlate) ~= 'string') then
        return false
    end
    return string.format('%s_%s', licensePlateType, licensePlate)
end

--TODO: возможно необходимо переодически очищать "кэш" текстур иначе будет ОЗУ забивать
-- можно будет хранить временную метку последнего использования текстуры
local _createdLicensePlateTexture = {}
local function getLicensePlateTexture(licensePlateType, licensePlate, width, height, vehicle, forGUI)
    if not Utils.isLicensePlateTypeValid(licensePlateType) then
        outputDebugString('getLicensePlateTexture: bad arguments', 1)
        return false
    end

    forGUI = (type(forGUI) == 'boolean') and forGUI or false
    width = (width and type(width) == 'number') and width or LicensePlate.width
    height = (height and type(height) == 'number') and height or LicensePlate.height

    local _cacheKey = getTextureCacheKey(licensePlateType, licensePlate)
    if _cacheKey then
        local _cachedTexture = _createdLicensePlateTexture[_cacheKey]
        if (isElement(_cachedTexture)) then
            local _width, _height = dxGetMaterialSize(_cachedTexture)
            if (width == _width and height == _height) then
                return _cachedTexture
            end
        end
    end

    local renderTarget = dxCreateRenderTarget(width, height, true)
	if not isElement(renderTarget) then
        outputDebugString('getLicensePlateTexture: failed create render targer', 1)
		return false
	end

    dxSetRenderTarget(renderTarget)
        dxSetBlendMode('modulate_add')
        enumLicensePlateTypeFunction[tostring(licensePlateType)](vehicle, licensePlate, forGUI)
        dxSetBlendMode('blend')
    dxSetRenderTarget()

    local texture = dxCreateTexture(dxGetTexturePixels(renderTarget))
    dxSetTextureEdge(texture, 'clamp')
    destroyElement(renderTarget)
    if not isElement(texture) then
        outputDebugString('getLicensePlateTexture: failed create texture', 1)
		return false
	end

    if _cacheKey then
        _createdLicensePlateTexture[_cacheKey] = texture
    end

    return texture
end

function LicensePlate.getTextureByVehicle(vehicle, width, height, forGUI)
    if not isElement(vehicle) then
        return false
    end

    forGUI = (type(forGUI) == 'boolean') and forGUI or false
    width = (width and type(width) == 'number') and width or LicensePlate.width
    height = (height and type(height) == 'number') and height or LicensePlate.height

    local licensePlateType, licensePlate = getVehicleLicensePlate(vehicle)
    if (licensePlateType ~= Config.LICENSE_PLATE_TYPE[0] and licensePlateType ~= Config.LICENSE_PLATE_TYPE[4]) then
        if not Utils.isLicensePlateValid(licensePlate, licensePlateType) then
            return false
        end
    end

    return getLicensePlateTexture(licensePlateType, licensePlate, width, height, vehicle, forGUI)
end

function LicensePlate.guiGetLicensePlateTexture(licensePlateType, licensePlate, width, height)
    if (
        not (licensePlateType and type(licensePlateType) == 'string') or 
        not (licensePlate and type(licensePlate) == 'string')
        --not (width and type(width) == 'number') or
        --not (height and type(height) == 'number')
    ) then
        return false
    end

    return getLicensePlateTexture(licensePlateType, licensePlate, width, height)
end

function LicensePlate.setOnVehicle(vehicle)
    if (not isElement(vehicle)) then
        outputDebugString('LicensePlate.setOnVehicle: bad arguments', 1)
        return false
    end

    local texture = LicensePlate.getTextureByVehicle(vehicle)
	if not isElement(texture) then
        outputDebugString('LicensePlate.setOnVehicle: failed texture', 1)
		return false
	end

    if not LicensePlate.created[vehicle] then
		LicensePlate.created[vehicle] = exports.tmtaShaders:createShader('texreplace', 0, 200, false, 'vehicle')
	end

    if (type(Config.LICANSE_PLATE_TEXTURE_NAME) == 'table') then
        for _, textureName in pairs(Config.LICANSE_PLATE_TEXTURE_NAME) do
            engineApplyShaderToWorldTexture(LicensePlate.created[vehicle], textureName, vehicle)
        end
    else
        engineApplyShaderToWorldTexture(LicensePlate.created[vehicle], Config.LICANSE_PLATE_TEXTURE_NAME, vehicle)
    end

	dxSetShaderValue(LicensePlate.created[vehicle], 'TEXTURE_REMAP', texture)

    return true
end

function LicensePlate.destroyFromVehicle(vehicle)
    if (not isElement(vehicle)) then
        outputDebugString('LicensePlate.destroyFromVehicle: bad arguments', 1)
        return false
    end

    local plateShader = LicensePlate.created[vehicle]
    if not plateShader then
        return false
    end

    if (type(Config.LICANSE_PLATE_TEXTURE_NAME) == 'table') then
        for _, textureName in pairs(Config.LICANSE_PLATE_TEXTURE_NAME) do
            engineRemoveShaderFromWorldTexture(plateShader, textureName, vehicle)
        end
    else
        engineRemoveShaderFromWorldTexture(plateShader, Config.LICANSE_PLATE_TEXTURE_NAME, vehicle)
    end

    destroyElement(plateShader)
	LicensePlate.created[vehicle] = nil

    return true
end