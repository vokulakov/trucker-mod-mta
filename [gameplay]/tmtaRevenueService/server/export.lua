--- Является ли пользователь субъектом предпринимательской деятельности
function isUserBusinessEntity(userId)
    if (type(userId) ~= "number") then
        return false
    end
    
    local result = RevenueService.getUserDataById(userId, {'isBusinessEntity'})
    if (type(result) ~= "table" or #result == 0) then
        return false
    end

    return exports.tmtaUtils:tobool(result[1].isBusinessEntity)
end

--- Начислить пользователю налог на недвижимость
function addUserPropertyTax(userId, taxAmount)
    if (type(userId) ~= "number" or type(taxAmount) ~= "number") then
        return false
    end
    return RevenueService.addUserPropertyTax(userId, taxAmount)
end

--- Начислить пользователю подоходный налог
function addUserIncomeTax(userId, taxAmount)
    if (type(userId) ~= 'number' or type(taxAmount) ~= 'number') then
        return false
    end
    return RevenueService.addUserIncomeTax(userId, taxAmount)
end

--- Есть ли у пользователя задолженность по налогу на недвижимость
function isUserHasPropertyTaxDebt(userId)
    if type(userId) ~= 'number' then
        return false
    end

    local result = RevenueService.getUserDataById(userId, {'propertyTaxPayable'})
    if (type(result) ~= "table" or #result == 0) then
        return false
    end

    return not (tonumber(result[1].propertyTaxPayable) == 0)
end

--- Есть ли у пользователя задолженность по подоходному налогу
function isUserHasIncomeTaxDebt(userId)
    if type(userId) ~= 'number' then
        return false
    end

    local result = RevenueService.getUserDataById(userId, {'incomeTaxPayable'})
    if (type(result) ~= "table" or #result == 0) then
        return false
    end

    return not (tonumber(result[1].incomeTaxPayable) == 0)
end