local function getRandomLicensePlateByType(licensePlateType, region)
    if not (licensePlateType and type(licensePlateType) == 'string') then
        outputDebugString("getRandomLicensePlateByType: bad arguments", 1)
        return false
    end

    if not Utils.isLicensePlateTypeValid(licensePlateType) then
        return false
    end

    local validateProperty = Utils.getLicensePlateTypeProperty(licensePlateType, 'validate')
    if not validateProperty then
        outputDebugString('getRandomLicensePlateByType: validate not found', 1)
        return false
    end

    local licensePlate = false
    if (licensePlateType == Config.LICENSE_PLATE_TYPE[1]) then
        licensePlate = Utils.generateRandomRuLicensePlate()
    elseif (licensePlateType == Config.LICENSE_PLATE_TYPE[3]) then
        licensePlate = Utils.generateRandomRuTrLicensePlate()
    elseif (licensePlateType == Config.LICENSE_PLATE_TYPE[4]) then
        licensePlate = Utils.generateRandomRuTrailerLicensePlate(region)
    end

    if not licensePlate then
        outputDebugString('setVehicleRandomLicensePlate: licensePlateType not found', 1)
        return false
    end

    return licensePlate
end

function setVehicleRandomLicensePlate(vehicleId, licensePlateType)
    if not (vehicleId and type(vehicleId) == 'number') then
        outputDebugString("setVehicleRandomLicensePlate: bad arguments", 1)
        return false
    end

    local licensePlate = getRandomLicensePlateByType(licensePlateType)
    if not licensePlate then
        outputDebugString('setVehicleRandomLicensePlate: licensePlateType not found', 1)
        return false
    end

    return LicensePlate.setVehicleLicensePlate(vehicleId, licensePlateType, licensePlate)
end

function deleteLicensePlateByVehicleId(vehicleId)
    return LicensePlate.deleteVehicleLicensePlate(vehicleId)
end

--- Добавить пользователю слот
-- @tparam number userId
-- @tparam number amount
-- @treturn bool
function addUserLicensePlateStorageSlot(userId, amount)
    return LicensePlateStorage.addUserSlot(userId, amount)
end

--- Установить фейковый рандомный номерной знак
--- Используется для демонстрации (например в работе дальнобойщика)
--TODO: добавить параметр region
function setVehicleFakeRandomLicensePlate(vehicle, licensePlateType, region)
    if not isElement(vehicle) then
        outputDebugString("setVehicleFakeRandomLicensePlate: bad arguments", 1)
        return false
    end

    local licensePlate = getRandomLicensePlateByType(licensePlateType, region)
    if not licensePlate then
        outputDebugString('setVehicleRandomLicensePlate: licensePlateType not found', 1)
        return false
    end
    
    local licensePlateType = Utils.getNumericLicensePlateType(licensePlateType)
    vehicle:setData('numberPlateType', licensePlateType)
    vehicle:setData('numberPlate', licensePlate)

    return true
end