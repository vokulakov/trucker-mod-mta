Utils = {}

function Utils.getBusinessConfigByType(businessType)
    if (type(businessType) ~= 'number') then
        return false
    end
    for _, data in pairs(Config.businessTypeList) do
        if (data.type == businessType) then
            return data
        end
    end
    return false
end

function Utils.getBusinessConfigByName(name)
    if (type(name) ~= 'string') then
        return false
    end
    for _, data in pairs(Config.businessTypeList) do
        if (data.name == name) then
            return data
        end
    end
    return false
end

function Utils.getBusinessConfigByPrice(price)
    if (type(price) ~= 'number') then
        return false
    end
    for _, data in pairs(Config.businessTypeList) do
        if exports.tmtaUtils:isBetween(price, unpack(data.price)) then
            return data
        end
    end
    return false
end