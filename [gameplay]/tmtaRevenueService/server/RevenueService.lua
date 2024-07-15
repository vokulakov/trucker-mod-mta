RevenueService = {}

REVENUE_SERVICE_TABLE_NAME = 'revenueService'

function RevenueService.setup()
    exports.tmtaSQLite:dbTableCreate(REVENUE_SERVICE_TABLE_NAME, {
        {name = 'userId', type = 'INTEGER', options = 'UNIQUE NOT NULL'},
        {name = 'individualNumber', type = 'VARCHAR', size = '12', options = 'UNIQUE NOT NULL'},
        {name = 'isBusinessEntity', type = 'INTEGER', options = 'DEFAULT 0' }, -- флаг юридической регистрации
        {name = 'propertyTaxPayable', type = 'INTEGER'}, -- подлежащий уплате налог на имущество
        {name = 'incomeTaxPayable', type = 'INTEGER'}, -- подлежащий уплате подоходный налог
        {name = 'vehicleTaxPayable', type = 'INTEGER'}, -- подлежащий уплате транспортный налог
    }, "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")
end

--- Генерация индивидуального номера налогоплательщика
local function generateIndividualTaxNumber()
end