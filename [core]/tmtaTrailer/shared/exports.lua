function getTrailerConfigByModel(model)
    if (type(model) ~= 'number' or not Config.TRAILER[model]) then
		return false
	end

    return Config.TRAILER[model]
end

function getTrailerTypeNameByModel(model)
    local trailerConfig = getTrailerConfigByModel(model)
    if not trailerConfig then
        --outputDebugString('getTrailerTypeNameByModel: bad arguments', 1)
        return false
    end
    return Config.TRAILER_TYPE[trailerConfig.type]
end

function getTrailerLoadCapacityByModel(model)
    local trailerConfig = getTrailerConfigByModel(model)
    if not trailerConfig then
        --outputDebugString('getTrailerLoadCapacityByModel: bad arguments', 1)
        return false
    end
    return trailerConfig.loadCapacity or 0
end

function getTrailerLoadCapacity(trailer)
    if not isElement(trailer) then
        --outputDebugString('getTrailerLoadCapacity: bad arguments', 1)
        return false
    end
    return tonumber(trailer:getData('trailer:loadCapacity')) or 0
end

function isTrailer(trailer)
    if not isElement(trailer) then
        --outputDebugString('isTrailer: bad arguments', 1)
        return false
    end
    return trailer:getData('isTrailer')
end