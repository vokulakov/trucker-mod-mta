Utils = {}

local _cacheIsValidVehicleModels = {}
local _cacheVehicleModels = {}
local _cacheVehicleNames = {}

function Utils.isValidVehicleModel(model)
    if _cacheIsValidVehicleModels[model] then
        return _cacheIsValidVehicleModels[model]
    end

    _cacheIsValidVehicleModels[model] = exports.tmtaVehicle:isValidVehicleModel(model)

    iprint( _cacheIsValidVehicleModels[model])

    return _cacheIsValidVehicleModels[model]
end

function Utils.getVehicleModelFromName(name)
    if _cacheVehicleModels[name] then
        return _cacheVehicleModels[name]
    end

    local model = exports.tmtaVehicle:getVehicleModelFromName(name)
    if not model then
        return false
    end

    _cacheVehicleModels[name] = model

    return model
end

function Utils.getVehicleNameFromModel(model)
    if _cacheVehicleNames[model] then
        return _cacheVehicleNames[model]
    end

    local readableName = exports.tmtaVehicle:getVehicleReadableNameFromName(model)
    if not readableName then
        return false
    end

    _cacheVehicleNames[model] = readableName

    return readableName
end
