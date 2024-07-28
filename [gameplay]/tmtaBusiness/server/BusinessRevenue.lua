BusinessRevenue = {}

local trackedBusiness = {}

--- Получить временную метку начисления дохода
function BusinessRevenue.getDateAccrueRevenue()
    return tonumber(exports.tmtaUtils:getTimestamp(_, _, getRealTime().monthday + Config.ACCRUE_REVENUE_DAY))
end

--- Начать отслеживать бизнес
function BusinessRevenue.startTracking(businessData)
    if (type(businessData) ~= 'table') then
        return false
    end

    trackedBusiness[businessData.businessId] = {
        revenue = businessData.revenue,
        accrueRevenueAt = businessData.accrueRevenueAt,
    }

    return true
end

function BusinessRevenue.stopTracking(businessId)
    if (type(businessId) ~= "number" or not trackedBusiness[businessId]) then
        return false
    end

    trackedBusiness[businessId] = nil

    return true
end

function BusinessRevenue.accrue(businessId)
    if (type(businessId) ~= "number" or not trackedBusiness[businessId]) then
        return false
    end
    
    local businessData = Business.get(businessId)
    if (type(businessData) ~= 'table' or #businessData == 0) then
        outputDebugString("BusinessRevenue.accrue: error accrure businessId = "..businessId, 1)
        return false
    end
    businessData = businessData[1]

    local currentBalance = tonumber(businessData.balance + businessData.revenue)
    businessData.balance = currentBalance

    return Business.update(businessId, {balance = currentBalance}, "dbUpdateBusiness", {businessId = businessId, businessData = businessData})
end

addEventHandler("tmtaServerTimecycle.onServerMinutePassed", root, 
    function()
        local currentTimestamp = getRealTime().timestamp
        for businessId, businessData in ipairs(trackedBusiness) do
            if (businessData.accrueRevenueAt --[[and (currentTimestamp >= businessData.accrueRevenueAt)]]) then
                BusinessRevenue.accrue(businessId)
            end
        end
    end
)