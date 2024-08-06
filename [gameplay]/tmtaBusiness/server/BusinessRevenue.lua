BusinessRevenue = {}

local trackedBusiness = {}

--- Получить временную метку начисления дохода
function BusinessRevenue.getDateAccrueRevenue()
    return tonumber(exports.tmtaUtils:getTimestamp(_, _, getRealTime().monthday + Config.ACCRUE_REVENUE_DAY))
end

-- Получить временную метку конфискации бизнеса
function BusinessRevenue.getDateConfiscate()
    return tonumber(exports.tmtaUtils:getTimestamp(_, _, getRealTime().monthday + Config.TAX_PAYMENT_PERIOD))
end

--- Начать отслеживать бизнес
function BusinessRevenue.startTracking(businessData)
    if (type(businessData) ~= 'table') then
        return false
    end

    trackedBusiness[businessData.businessId] = {
        revenue = businessData.revenue,
        accrueRevenueAt = businessData.accrueRevenueAt,
        confiscateAt = businessData.confiscateAt,
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

    return Business.update(businessId, {
        balance = currentBalance,
        accrueRevenueAt = BusinessRevenue.getDateAccrueRevenue(),
        confiscateAt = BusinessRevenue.getDateConfiscate(),
    }, "dbAccrueRevenueBusiness", {
        businessId = businessId,
    })
end

function dbAccrueRevenueBusiness(result, params)
    if (not params) then
        return false
    end
    local businessId = params.businessId

    result = not not result
    if result then
        --local businessData = Business.get(businessId)
        --businessData = businessData[1]
        --TODO: начислить налог
    end

    return result
end

addEventHandler("tmtaServerTimecycle.onServerMinutePassed", root, 
    function()
        local currentTimestamp = getRealTime().timestamp
        for businessId, businessData in ipairs(trackedBusiness) do
            if (businessData.accrueRevenueAt and (currentTimestamp >= businessData.accrueRevenueAt)) then
                if (businessData.confiscateAt and (currentTimestamp >= businessData.confiscateAt)) then
                    return Business.sell(businessId)
                end
                BusinessRevenue.accrue(businessId)
            end
        end
    end
)