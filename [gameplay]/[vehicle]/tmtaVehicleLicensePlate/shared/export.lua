local _cacheFormatLicensePlateToString = {}
function formatLicensePlateToString(licensePlateType, licensePlate)
    if not (
        (licensePlateType and (type(licensePlateType) == 'number' or type(licensePlateType) == 'string')) and
        (licensePlate and type(licensePlate) == 'string')
    ) then
        return ''
    end

    if (type(licensePlateType) == 'number') then
        licensePlateType = Utils.getCharacterLicensePlateType(licensePlateType)
    end
    
    local _cacheKey = licensePlateType..licensePlate
    if (_cacheFormatLicensePlateToString[_cacheKey]) then
        return _cacheFormatLicensePlateToString[_cacheKey]
    end

    if not Utils.isLicensePlateValid(licensePlate, licensePlateType) then
        return ''
    end

    local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
    if (validateProperty and validateProperty.regionRegex) then
        --@see https://www.ibm.com/docs/en/ias?topic=manipulation-stringgsub-s-pattern-repl-n
        licensePlate = licensePlate:gsub(validateProperty.regionRegex, '|%1|')
    end

    if (licensePlateType:find('ru')) then
        licensePlateType = 'ru'

        local _convertableCharTable = {
            ['A'] = 'А', ['B'] = 'В', ['C'] = 'С', ['Y'] = 'У',
            ['O'] = 'О', ['P'] = 'Р', ['T'] = 'Т', ['E'] = 'Е',
            ['X'] = 'Х', ['M'] = 'М', ['H'] = 'Н', ['K'] = 'К',
        }

        licensePlate = utf8.gsub(utf8.upper(licensePlate), '%w', function(char)
            return _convertableCharTable[char]
        end)
    end

    local result = string.format('%s-%s', string.upper(licensePlateType), licensePlate)

    _cacheFormatLicensePlateToString[_cacheKey] = result
    return result
end

function getVehicleLicensePlate(vehicle)
    if not isElement(vehicle) then
        return false, false
    end

    local licensePlateType = Config.LICENSE_PLATE_TYPE[tonumber(vehicle:getData('numberPlateType'))] or Config.LICENSE_PLATE_TYPE[0]
    local licensePlate = vehicle:getData('numberPlate')

    return licensePlateType, licensePlate
end

function getVehicleLicensePlateRegion(vehicle)
    if not isElement(vehicle) then
        return false
    end

    local licensePlateType, licensePlate = getVehicleLicensePlate(vehicle)
    if not (licensePlateType and licensePlate) then
        return false
    end

    local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
    if not (validateProperty and validateProperty.regionRegex) then
        return false
    end

    return licensePlate:match(validateProperty.regionRegex)
end