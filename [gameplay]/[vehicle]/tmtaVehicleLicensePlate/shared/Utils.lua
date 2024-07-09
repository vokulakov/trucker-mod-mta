Utils = {}

local _outputDebugString = outputDebugString
function outputDebugString(...)
    if not Config.DEBUG then return end
    return _outputDebugString(...)
end

local _convertableCharTable = {
    ['А'] = 'A', ['В'] = 'B', ['С'] = 'C', ['У'] = 'Y',
    ['О'] = 'O', ['Р'] = 'P', ['Т'] = 'T', ['Е'] = 'E',
    ['Х'] = 'X', ['М'] = 'M', ['Н'] = 'H', ['К'] = 'K',
}

--- Форматирование текста номерного знака
function Utils.formatLicensePlate(licensePlate)
    return utf8.gsub(utf8.upper(licensePlate), '%w', function(char)
        return _convertableCharTable[char]
    end)
end

--- Разбить номерной знак на массив символов
function Utils.splitLicensePlate(licensePlate)
    return exports.tmtaUtils:strSplit(licensePlate)
end

--- Проверить является ли строка зеркальной
function Utils.isMirrorCharsString(str)
    if (not str or (type(str) ~= 'number' and type(str) ~= 'string')) then
        outputDebugString("Utils.isMirrorNumber: bad argument", 1)
        return 
    end

    str = tostring(str)
    local strLen = str:len()
    if (strLen < 2) then
        return true
    end

    local _subSize = math.ceil(strLen /2)
    return (str:sub(1, _subSize) == str:sub((strLen % 2 == 0) and _subSize + 1 or _subSize, strLen):reverse())
end

--- Проверить на одинаковые символы в строке
function Utils.isIdenticalCharsString(str)
    if (not str or (type(str) ~= 'number' and type(str) ~= 'string')) then
        outputDebugString("Utils.isMirrorNumber: bad argument", 1)
        return 
    end

    local result = true

    local _prevChar
    string.gsub(tostring(str), '%w', function(char)
        if (_prevChar and _prevChar ~= char) then
            result = false
        end
        _prevChar = char
    end)

    return result
end

--- Проверить на наличие в строке двух одинаковых символов подряд
function Utils.isComboCharsString(str)
    if (not str or (type(str) ~= 'number' and type(str) ~= 'string')) then
        outputDebugString("Utils.isComboCharsString: bad argument", 1)
        return 
    end

    local result = false

    local _prevChar
    string.gsub(tostring(str), '%w', function(char)
        if (_prevChar and _prevChar == char) then
            result = true
        end
        _prevChar = char
    end)

    return result
end

--- Проверить является ли тип номерного знака валидным
local _cacheLicensePlateTypeValid = {}
function Utils.isLicensePlateTypeValid(licensePlateType)
    if (not licensePlateType or type(licensePlateType) ~= 'string') then
        outputDebugString('Utils.isLicensePlateTypeValid: bad arguments', 1)
        return false
    end

    if _cacheLicensePlateTypeValid[licensePlateType] then
        return true
    end

    for _, _licensePlateType in pairs(Config.LICENSE_PLATE_TYPE) do
        if (_licensePlateType == licensePlateType) then
            _cacheLicensePlateTypeValid[licensePlateType] = true
            return true
        end
    end

    return false
end

--- Проверить является номерной знак валидным
--- --TODO: возвращать ошибки валидации
local _cacheLicensePlateValid = {}
function Utils.isLicensePlateValid(licensePlate, licensePlateType)
    if (not licensePlate or type(licensePlate) ~= 'string') then
        outputDebugString('Utils.isLicensePlateValid: bad arguments', 1)
        return false
    end
    
    if licensePlateType then
        if not Utils.isLicensePlateTypeValid(licensePlateType) then
            return false
        end
    else
        licensePlateType = Utils.getLicensePlateType(licensePlate)
    end

    if not licensePlateType then
        outputDebugString('Utils.isLicensePlateValid: licensePlateType not found', 1)
        return false
    end

    local _cacheKey = licensePlateType..licensePlate
    if _cacheLicensePlateValid[_cacheKey] then
        return true
    end

    -- Проверка на нули
    for result in licensePlate:gmatch("%d+") do 
        if (result == '00' or result == '000' or result == '0000') then
            return false, string.format('Номер не может содержать одни нули!')
        end
    end

    local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
    if not validateProperty then
        outputDebugString('Utils.isLicensePlateValid: validateProperty not found', 1)
        return false
    end

    isValid = (licensePlate:len() <= validateProperty.maxLength and string.find(licensePlate, validateProperty.regex))
    if (isValid and validateProperty.regionRegex) then
        local _licensePlate = licensePlate:gsub(validateProperty.numberRegex, '')
        local licensePlateRegion = _licensePlate:match(validateProperty.regionRegex)
        if licensePlateRegion then
            local licensePlateTypeRegion = Utils.getLicensePlateTypeProperty(licensePlateType, 'region')
            if (not licensePlateTypeRegion[licensePlateRegion]) then
                return false, string.format("Регион с кодом '%s' не найден!", licensePlateRegion)
            end
        end
    end

    _cacheLicensePlateValid[_cacheKey] = isValid
    
    return isValid
end

--- Проверить является ли номер приватным
function Utils.isLicensePlatePrivate(licensePlate, licensePlateType)
    if (not licensePlate or type(licensePlate) ~= 'string' or not licensePlateType or type(licensePlateType) ~= 'string') then
        return false
    end

    if not Utils.isLicensePlateValid(licensePlate, licensePlateType) then
        return false
    end

    local licensePlateType = licensePlateType:find('ru') and 'ru' or licensePlateType
    if Config.LICENSE_PLATE_PRIVATE[licensePlateType] then
        for licensePlatePattern in pairs(Config.LICENSE_PLATE_PRIVATE[licensePlateType]) do
            if (licensePlate:find(licensePlatePattern)) then
                return true
            end
        end
    end

    return false
end

--- Проверить является ли номер уникальным
function Utils.isLicensePlateUnique(licensePlate, licensePlateType)
    if (not licensePlate or type(licensePlate) ~= 'string' or not licensePlateType or type(licensePlateType) ~= 'string') then
        return false
    end

    if not Utils.isLicensePlateValid(licensePlate, licensePlateType) then
        return false
    end

    local licensePlateType = licensePlateType:find('ru') and 'ru' or licensePlateType
    if Config.LICENSE_PLATE_UNIQUE[licensePlateType] then
        for licensePlatePattern in pairs(Config.LICENSE_PLATE_UNIQUE[licensePlateType]) do
            if (licensePlate:find(licensePlatePattern)) then
                return true
            end
        end
    end

    return false
end

--- Получить тип номерного знака по номерному знаку
function Utils.getLicensePlateType(licensePlate)
    if (not licensePlate or type(licensePlate) ~= 'string') then
        outputDebugString('Utils.getLicensePlateType: bad arguments', 1)
        return false
    end

    for licensePlateType in pairs(Config.LICENSE_PLATE) do
        local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
        if (Utils.isLicensePlateValid(licensePlate, licensePlateType)) then
            return licensePlateType
        end
    end

    return false
end

--- Получить числовой тип номерного знака по символьному типу
function Utils.getNumericLicensePlateType(licensePlateType)
    if (not licensePlateType or type(licensePlateType) ~= 'string') then
        outputDebugString('Utils.getLicensePlateNumericType: bad arguments', 1)
        return false
    end
    
    for numericLicensePlateType, characterLicensePlateType in pairs(Config.LICENSE_PLATE_TYPE) do
        if (characterLicensePlateType == licensePlateType) then
            return numericLicensePlateType
        end
    end

    return false
end

--- Получить символьный тип номерного знака по числовому типу
function Utils.getCharacterLicensePlateType(licensePlateType)
    if (not licensePlateType or (type(licensePlateType) ~= 'number' and type(licensePlateType) ~= 'string')) then
        outputDebugString('Utils.getLicensePlateNumericType: bad arguments', 1)
        return false
    end
    return Config.LICENSE_PLATE_TYPE[tonumber(licensePlateType)]
end

--- Получить свойство конфигурации номерного знака по типу
function Utils.getLicensePlateTypeProperty(licensePlateType, propertyName)
    if (not licensePlateType or type(licensePlateType) ~= 'string') then
        outputDebugString('Utils.getLicensePlateTypeProperty: bad arguments', 1)
        return false
    end

    local licensePlateProperty = Config.LICENSE_PLATE[licensePlateType]
    if (not licensePlateProperty or type(licensePlateProperty) ~= 'table') then
        outputDebugString('Utils.getLicensePlateTypeProperty: not found licence plate type', 1)
        return false
    end

    return (type(propertyName) == 'string' and licensePlateProperty[propertyName]) and licensePlateProperty[propertyName] or licensePlateProperty
end

--- Проверить доступен ли номер к покупке (установке)
function Utils.isLicensePlateAvailable(licensePlateType, licensePlate)
    if (not licensePlate or type(licensePlate) ~= 'string' or not licensePlateType or type(licensePlateType) ~= 'string') then
        return false
    end

    if not Utils.isLicensePlateValid(licensePlate, licensePlateType) then
        return false
    end

    if Utils.isLicensePlateUnique(licensePlate, licensePlateType) then
        return false
    end

    local _inaccessibleLicensePlate = resourceRoot:getData('tmtaVehicleLicensePlate:inaccessibleLicensePlate') or {}
    if (type(_inaccessibleLicensePlate) == 'table') then
        local licensePlateType = licensePlateType:find('ru') and 'ru' or licensePlateType
        if _inaccessibleLicensePlate[string.format('%s_%s', licensePlateType, licensePlate)] then
            return false
        end
    end

    return true
end

local _cacheLicensePlatePrice = {}
function Utils.getLicensePlatePrice(licensePlateType, licensePlate)
    if (not licensePlate or type(licensePlate) ~= 'string' or not licensePlateType or type(licensePlateType) ~= 'string') then
        return false
    end

    if not Utils.isLicensePlateValid(licensePlate, licensePlateType) then
        return false
    end

    if not Utils.isLicensePlateAvailable(licensePlateType, licensePlate) then
        return false
    end

    local _cacheKey = (licensePlateType..licensePlate)
    if _cacheLicensePlatePrice[_cacheKey] then
        return _cacheLicensePlatePrice[_cacheKey]
    end

    local isLicensePlatePrivate = Utils.isLicensePlatePrivate(licensePlate, licensePlateType)

    local baseLicensePlatePrice = Utils.getLicensePlateTypeProperty(licensePlateType, 'price') or 0
    local addLicensePlatePrice = 0

    local licensePlateType = licensePlateType:find('ru') and 'ru' or licensePlateType

    if isLicensePlatePrivate then
        local _baseLicensePlatePrivatePrice = 0
        for licensePlatePattern, licensePlatePrice in pairs(Config.LICENSE_PLATE_PRIVATE[licensePlateType]) do
            if (licensePlate:find(licensePlatePattern)) then
                _baseLicensePlatePrivatePrice = licensePlatePrice
                break
            end
        end
        baseLicensePlatePrice = baseLicensePlatePrice + _baseLicensePlatePrivatePrice
    end

    local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
    if validateProperty then
        local _filter = {}

        local _licensePlate = validateProperty.regionRegex and licensePlate:gsub(validateProperty.regionRegex, '') or _licensePlate
        _licensePlateChar = _licensePlate:gsub(validateProperty.numberRegex, '')
        _licensePlateNumber = _licensePlate:match(validateProperty.numberRegex)
        _licensePlateRegion = validateProperty.regionRegex and licensePlate:match(validateProperty.regionRegex) or nil

        local isIdenticalChar = Utils.isIdenticalCharsString(_licensePlateChar) -- одинаковые буквы
        local isIdenticalNumber = Utils.isIdenticalCharsString(_licensePlateNumber) -- одинаковые цифры
        local isMirrorChar = Utils.isMirrorCharsString(_licensePlateChar) -- зеркальные буквы
        local isMirrorNumber = Utils.isMirrorCharsString(_licensePlateNumber) -- зеркальные цифры

        local checkNumber = true
        if (isIdenticalChar) then
            if (isIdenticalNumber) then -- одинаковые буквы и одинаковые цифры
                --table.insert(_filter, 'одинаковые буквы и одинаковые цифры')
                baseLicensePlatePrice = 600000
                checkNumber = false
            elseif (_licensePlateNumber:find('^[1-9]000?$')) then -- с цифрами 100–900 и одинаковыми буквами
                --table.insert(_filter, 'с цифрами 100–900 и одинаковыми буквами')
                baseLicensePlatePrice = 450000
                checkNumber = false
            elseif (_licensePlateNumber:find('^000?[1-9]$')) then -- с цифрами 001–009 и одинаковыми буквами
                --table.insert(_filter, 'с цифрами 001–009 и одинаковыми буквами')
                baseLicensePlatePrice = 300000
                checkNumber = false
            elseif (_licensePlateNumber:find('^0[1-9]0$')) then -- с цифрами 010–090 и одинаковыми буквами
                --table.insert(_filter, 'с цифрами 010–090 и одинаковыми буквами')
                baseLicensePlatePrice = 200000
                checkNumber = false
            else
                --table.insert(_filter, 'одинаковые буквы при любых цифрах')
                addLicensePlatePrice = addLicensePlatePrice + 150000
            end
        elseif (isMirrorChar) then -- зеркальные буквы при любых цифрах
            --table.insert(_filter, 'зеркальные буквы при любых цифрах')
            addLicensePlatePrice = addLicensePlatePrice + 50000
        end

        if (checkNumber) then
            if (isIdenticalNumber) then -- одинаковые цифры при любых буквах
                --table.insert(_filter, 'одинаковые цифры при любых буквах')
                addLicensePlatePrice = addLicensePlatePrice + 150000
            elseif (isMirrorNumber) then -- зеркальные цифры при любых буквах
                --table.insert(_filter, 'зеркальные цифры при любых буквах')
                addLicensePlatePrice = addLicensePlatePrice + 50000
            elseif (Utils.isComboCharsString(_licensePlateNumber)) then -- с двумя одинаковыми цифрами подряд
                --table.insert(_filter, 'с двумя одинаковыми цифрами подряд')
                addLicensePlatePrice = addLicensePlatePrice + 100000
            end
        end

        local isRegionInChar = string.find(_licensePlateChar, _licensePlateRegion)
        local isRegionInNumber = string.find(_licensePlateNumber, _licensePlateRegion)
        if (Utils.isIdenticalCharsString(_licensePlateRegion) and not (isRegionInChar or isRegionInNumber)) then -- одинаковые цифры (буквы) в регионе
            --table.insert(_filter, 'одинаковые цифры (буквы) в регионе')
            addLicensePlatePrice = addLicensePlatePrice + 100000
        elseif (isRegionInNumber or isRegionInChar) then -- присутствие цифр (буквы) региона в цифрах (буквах) номера
            --table.insert(_filter, 'присутствие цифр (буквы) региона в цифрах (буквах) номера')
            addLicensePlatePrice = addLicensePlatePrice + 200000
        end

        -- iprint({
        --     _licensePlateChar = _licensePlateChar,
        --     _licensePlateNumber = _licensePlateNumber,
        --     _licensePlateRegion = _licensePlateRegion,
        --     isIdenticalChar = isIdenticalChar,
        --     isIdenticalNumber = isIdenticalNumber,
        --     isMirrorChar = isMirrorChar,
        --     isMirrorNumber = isMirrorNumber,
        -- })

        --iprint(_filter)
    end

    local licensePlatePrice = baseLicensePlatePrice + addLicensePlatePrice
    _cacheLicensePlatePrice[_cacheKey] = tonumber(licensePlatePrice)

    return licensePlatePrice
end

--- Сгенерировать рандомный русский (транзитный) номерной знак
local _letters = {"A", "B", "C", "E", "H", "K", "M", "O", "P", "T", "X", "Y"}
local _ruRegions = {}
for region in pairs(Config.LICENSE_PLATE_REGION['ru']) do
    table.insert(_ruRegions, region)
end

function Utils.generateRandomRuTrLicensePlate()
    local licensePlateType = Config.LICENSE_PLATE_TYPE[3]

    local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
    if not validateProperty then
        outputDebugString('Utils.generateRandomRuTrLicensePlate: validate not found', 1)
        return false
    end

    local licensePlate = false
    repeat
        licensePlate = string.format('%s%s%d%d%d%s%s', 
            _letters[math.random(#_letters)],
            _letters[math.random(#_letters)],
            math.random(0, 9),
            math.random(0, 9), 
            math.random(0, 9),
            _letters[math.random(#_letters)],
            _ruRegions[math.random(#_ruRegions)]
        )
    until (
        Utils.isLicensePlateAvailable(licensePlateType, licensePlate) and 
        not Utils.isLicensePlatePrivate(licensePlate, licensePlateType)
    )

    return licensePlate
end

function Utils.generateRandomRuLicensePlate()
    local licensePlateType = Config.LICENSE_PLATE_TYPE[1]

    local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
    if not validateProperty then
        outputDebugString('Utils.generateRandomRuLicensePlate: validate not found', 1)
        return false
    end

    local licensePlate = false
    repeat
        licensePlate = string.format('%s%d%d%d%s%s%s', 
            _letters[math.random(#_letters)],
            math.random(0, 9),
            math.random(0, 9), 
            math.random(0, 9),
            _letters[math.random(#_letters)],
            _letters[math.random(#_letters)],
            _ruRegions[math.random(#_ruRegions)]
        )
    until (
        Utils.isLicensePlateAvailable(licensePlateType, licensePlate) and 
        not Utils.isLicensePlatePrivate(licensePlate, licensePlateType)
    )

    return licensePlate
end

function Utils.generateRandomRuTrailerLicensePlate(region)
    local licensePlateType = Config.LICENSE_PLATE_TYPE[4]

    local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
    if not validateProperty then
        outputDebugString('Utils.generateRandomRuTrailerLicensePlate: validate not found', 1)
        return false
    end

    local _isHasRegion = false
    if (region and Config.LICENSE_PLATE_REGION['ru'][region]) then
        _isHasRegion = true
    end

    local licensePlate = false
    repeat
        licensePlate = string.format('%s%s%d%d%d%d%s', 
            _letters[math.random(#_letters)],
            _letters[math.random(#_letters)],
            math.random(0, 9),
            math.random(0, 9), 
            math.random(0, 9),
            math.random(0, 9),
            _isHasRegion and region or _ruRegions[math.random(#_ruRegions)]
        )
    until (
        Utils.isLicensePlateAvailable(licensePlateType, licensePlate) and 
        not Utils.isLicensePlatePrivate(licensePlate, licensePlateType)
    )

    return licensePlate
end

--- Получить количество слотов в хранилище игрока
function Utils.getPlayerLicensePlateSlotCount(player)
    local player = player or localPlayer
    if not isElement(player) then
        return false
    end
    return tonumber(player:getData('licensePlateSlot')) or 0
end

--- Получить количество свободных слотов в гараже игрока
function Utils.getPlayerFreeLicensePlateSlotCount(player)
    local player = player or localPlayer
    if not isElement(player) then
        return false
    end

    local freeSlotCount = tonumber(Utils.getPlayerLicensePlateSlotCount(player)) -(tonumber(player:getData('license_plate_slot_count')) or 0)
    return (freeSlotCount > 0) and freeSlotCount or 0
end

--- Проверить есть ли у игрока свободные слоты в хранилище игрока
function Utils.isPlayerHasFreeLicensePlateSlot(player)
    local player = player or localPlayer
    if not isElement(player) then
        return false
    end
    return (Utils.getPlayerFreeLicensePlateSlotCount(player) > 0)
end

function Utils.showNotice(message, player)
    local title = "#FFA07AГосударственная регистрация ТС"
    if (not player and localPlayer) then
        return exports.tmtaNotification:showInfobox("info", title, message, _, {240, 146, 115})
    else
        return exports.tmtaNotification:showInfobox(player, "info", title, message, _, {240, 146, 115})
    end
end