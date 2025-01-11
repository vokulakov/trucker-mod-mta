-- Список дат в которые будет действовать акция принудительно
local PROMO_RESERVED_DATE = {
    ['23.02'] = true, -- 23 февраля — День защитника Отечества
    ['08.03'] = true, -- 8 марта — Международный женский день
    ['01.05'] = true, -- 1 мая — Праздник Весны и Труда;
    ['09.05'] = true, -- 9 мая — День Победы
    ['12.06'] = true, -- 12 июня — День России
    ['01.09'] = true, -- 1 сентября
    ['04.11'] = true, -- 4 ноября — День народного единства
    ['31.12'] = true, -- 31 декабря

    ['01.01'] = true, -- 1 января — Новогодние каникулы
    ['02.01'] = true, -- 2 января — Новогодние каникулы
    ['03.01'] = true, -- 3 января — Новогодние каникулы
} 

local function getTimestamp(day, month, year)
    local time = getRealTime()
    month = month or (time.month + 1)
    year = year or (time.year + 1900)
    return os.time{year = year, month = month, day = day}
end

--- https://lua-users.org/wiki/DayOfWeekAndDaysInMonthExample
--- Получить количество дней в месяце
local function getNumberOfDaysInMonth(month)
    return os.date('*t', getTimestamp(0, month+1))['day']
end

--- Получить выходные дни в месяце
local _cacheWeekendInMonth = {}
local function getWeekendInMonth(month)
    month = month or (getRealTime().month + 1)
    local daysCount = getNumberOfDaysInMonth(month)

    if _cacheWeekendInMonth[month] then
        return _cacheWeekendInMonth[month]
    end

    local _weekend = {}
    for day = 1, daysCount do
        local wday = tonumber(os.date("%w", getTimestamp(day, month)))
        if (wday == 0 or wday == 6) then
            _weekend[day] = true
        end
    end

    _cacheWeekendInMonth[month] = _weekend

    return _weekend
end

--- Проверить действует ли акция сегодня
local function checkIsPromotionValidToday()
    local time = getRealTime()
    local weekend = getWeekendInMonth()

    local date = string.format('%02d.%02d', time.monthday, time.month + 1)
    if PROMO_RESERVED_DATE[date] then
        return true
    end

    if not weekend[time.monthday] then
        return false
    end

    return true
end

addEventHandler('tmtaServerTimecycle.onServerMinutePassed', root, 
    function()
        resourceRoot:setData('tmtaX2:isPromoX2Active', checkIsPromotionValidToday())
    end
)

addEventHandler('onResourceStart', resourceRoot,
    function()
        resourceRoot:setData('tmtaX2:isPromoX2Active', checkIsPromotionValidToday())
    end
)
