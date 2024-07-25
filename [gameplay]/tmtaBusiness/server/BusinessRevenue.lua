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

addEventHandler("tmtaServerTimecycle.onServerMinutePassed", root, 
    function()
    end
)