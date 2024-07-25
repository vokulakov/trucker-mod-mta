Business = {}
local createdBusiness = {}

BUSINESS_TABLE_NAME = 'business'

function Business.setup()
    exports.tmtaSQLite:dbTableCreate(BUSINESS_TABLE_NAME, {
        {name = 'type', type = 'INTEGER'}, -- тип бизнеса
        {name = 'name', type = 'VARCHAR', size = 128, options = 'NOT NULL'}, -- название бизнеса
        {name = 'price', type = 'INTEGER', options = 'DEFAULT 0 NOT NULL'}, -- рыночная стоимость
        {name = 'balance', type = 'INTEGER', options = 'DEFAULT 0'}, -- баланс бизнеса

        {name = 'revenue', type = 'INTEGER'}, -- доход
        {name = 'taxAmount', type = 'INTEGER'}, -- сумма налога (к оплате)

        {name = 'accrueRevenueAt', type = 'TIMESTAMP'}, -- время начисления прибыли (в timestamp)
        {name = 'confiscateAt', type = 'TIMESTAMP'}, -- время конфискации в пользу государства (в timestamp)

        {name = 'position', type = 'TEXT'},
        {name = 'upgrades', type = 'TEXT'},
        {name = 'userId', type = 'INTEGER'},
        {name = 'editorId', type = 'INTEGER'},
    }, 
        "FOREIGN KEY (userId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL,\n"..
        "FOREIGN KEY (editorId)\n\tREFERENCES user (userId)\n\tON DELETE SET NULL")

    local successCount, errorCount = 0, 0
    for _, business in pairs(Business.getAll()) do
        if (Business.create(business)) then
            successCount = successCount + 1
        else
            errorCount = errorCount + 1
        end
    end

    outputDebugString('Система бизнесов загружена')
    outputDebugString('Успешно создано: '..successCount)
    outputDebugString('Не удалось создать: '..errorCount)
end

function Business.getAll()
    return exports.tmtaSQLite:dbTableSelect(BUSINESS_TABLE_NAME)
end

function Business.get(businessId, fields, callbackFunctionName, ...)
    if (type(businessId) ~= "number" or type(fields) ~= "table") then
        outputDebugString("Business.get: bad arguments", 1)
        return false
    end

    return exports.tmtaSQLite:dbTableSelect(BUSINESS_TABLE_NAME, fields, {businessId = businessId}, callbackFunctionName, ...)
end

function Business.add(posX, posY, posZ, type, price, revenue, callbackFunctionName, ...)
    local player = client
    if not isElement(player) then
        return false
    end

    local businessConfig = Utils.getBusinessConfigByType(type)
    if not businessConfig then
        return false
    end

    local businessData = {
        type = type,
        name = businessConfig.name,
        position = tostring(toJSON({x = posX, y = posY, z = posZ})),
        price = price,
        revenue = revenue,
        editorId = player:getData("userId"),
    }

    local success = exports.tmtaSQLite:dbTableInsert(BUSINESS_TABLE_NAME, businessData, callbackFunctionName, ...)
    if success then
        exports.tmtaLogger:log("business", "Added business")
    end

    return exports.tmtaSQLite:dbQuery('SELECT * FROM `business` ORDER BY `businessId` DESC LIMIT 1', callbackFunctionName, ...)
end

addEvent("tmtaBusiness.addBusinessRequest", true)
addEventHandler("tmtaBusiness.addBusinessRequest", resourceRoot,
    function(posX, posY, posZ, type, price, revenue)
        local player = client
        local success = Business.add(posX, posY, posZ, type, price, revenue, "dbAddBusiness", {player = player})
        if not success then
            triggerClientEvent(player, "tmtaBusiness.addBusinessResponse", resourceRoot, false)
        end
    end
)

function dbAddBusiness(result, params)
	if not params or not isElement(params.player) then
        return
    end
    local player = params.player
	local success = not not result
    
    if success then
        Business.create(result[1])
    end

    triggerClientEvent(player, "tmtaBusiness.addBusinessResponse", resourceRoot, success)
end

function Business.remove(player, businessId, callbackFunctionName, ...)
    if not isElement(player) then
        return false
    end

    if type(businessId) ~= "number" then
        outputDebugString("Business.remove: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end

    local success = exports.tmtaSQLite:dbTableDelete(BUSINESS_TABLE_NAME, { businessId = businessId }, callbackFunctionName, ...)
	if not success then
		executeCallback(callbackFunctionName, false)
	end

    exports.tmtaLogger:log("business", 
		string.format("Removed business %s. Success: %s", 
			tostring(businessId), 
			tostring(success)
        )
    )

    return success
end

function Business.update(businessId, fields, callbackFunctionName, ...)
    if (type(businessId) ~= "number" or type(fields) ~= "table") then
        outputDebugString("Business.update: bad arguments", 1)
        return false
    end

    local success = DatabaseTable.update(BUSINESS_TABLE_NAME, fields, {businessId = businessId}, callbackFunctionName, ...)

    if not success then
		executeCallback(callbackFunctionName, false)
	end

    return success
end

-- Получить список всех бизнесов игрока
function Business.getPlayerBusiness(userId, callbackFunctionName, ...)
    if type(userId) ~= "number" then
        outputDebugString("Business.getPlayerBusiness: bad arguments", 1)
        executeCallback(callbackFunctionName, false)
        return false
    end
    return exports.tmtaSQLite:dbTableSelect(BUSINESS_TABLE_NAME, {}, { userId = userId }, callbackFunctionName, ...)
end

function Business.create(businessData)
    if type(businessData) ~= 'table' then
        return false
    end

    local businessId = businessData.businessId
    if (not businessId or type(businessId) ~= 'number') then
        outputDebugString("Business.create: error businessId", 1)
        return false
    end

    if businessData.userId then
        local result = exports.tmtaCore:getUserDataById(tonumber(businessData.userId), {'nickname'})
        businessData.owner = result[1].nickname
    end

    local position = fromJSON(businessData.position)
    businessData.position = Vector3(position.x, position.y, position.z)

    local businessMarker = createMarker(position.x, position.y, position.z-0.6, 'cylinder', 1.5, 255, 255, 255, 0)
    local businessPickup = createPickup(position.x+0.05, position.y-0.05, position.z, 3, Config.PICKUP_ID, 500)

    businessMarker:setData('businessId', businessId)
    businessMarker:setData('isBusinessMarker', true)
    businessMarker:setData('businessData', businessData)

    createdBusiness[businessId] = {
        data = businessData,
        businessMarker = businessMarker,
        businessPickup = businessPickup,
    }

    return true
end

function Business.destroy(businessId)
    if type(businessId) ~= "number" or not createdBusiness[businessId] then
        outputDebugString("Business.destroy: bad arguments", 1)
        return false
    end

    destroyElement(createdBusiness[businessId].businessMarker)
    destroyElement(createdBusiness[businessId].businessPickup)
    createdBusiness[businessId] = nil

    return true
end

function Business.buy(player, businessId)
    if not isElement(player) then
        return false
    end

    local userId = player:getData("userId")
    local playerBusiness = Business.getPlayerBusiness(userId)
    if (#playerBusiness >= Config.PLAYER_MAX_BUSINESS) then
        local errorMessage = string.format('Вы можете одновремено владеть только %d бизнесом', Config.PLAYER_MAX_BUSINESS)
        return false, errorMessage
    end

    if (exports.tmtaExperience:getPlayerLvl(player) < Config.PLAYER_REQUIRED_LVL) then
        local errorMessage = string.format('Для покупки бизнеса требуется %d+ уровень', Config.PLAYER_REQUIRED_LVL)
        return false, errorMessage
    end

    if (not exports.tmtaRevenueService:isPlayerBusinessEntity(player)) then
        local errorMessage = 'Для владения бизнесом Вам необходимо всать на учёт в налоговой службе'
        return false, errorMessage
    end

    local playerHouses = exports.tmtaHouse:getPlayerHouses(player)
    if (type(playerHouses) ~= 'table' or #playerHouses == 0) then
        local errorMessage = 'Для покупки бизнеса необходимо наличие недвижимости'
        return false, errorMessage
    end
    
    if (exports.tmtaMoney:getPlayerMoney(player) < businessData.price) then
        local errorMessage = 'Недостаточно средств для покупки бизнеса'
        return false, errorMessage
    end

end

addEvent("tmtaBusiness.onPlayerBuyBusiness", true)
addEventHandler("tmtaBusiness.onPlayerBuyBusiness", resourceRoot,
    function(businessId)
        local player = client
        if type(businessId) ~= "number" or not isElement(player) then
            return
        end

        if not createdBusiness[businessId] then
            return
        end

        local businessData = createdBusiness[businessId].data
        if (businessData.userId) then
            outputDebugString("tmtaBusiness.onPlayerBuyBusiness: error buying business", 1)
            exports.tmtaLogger:log(
                "business",
                string.format("Error buying business (%d). Business owner user %d", businessId, businessData.userId)
            )
            return triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'error', 'Ошибка покупки бизнеса. Обратитесь к Администратору!')
        end

        local success, errorMessage = Business.buy(player, businessId)
        if (not success and errorMessage) then
            triggerClientEvent(player, 'tmtaBusiness.showNotice', resourceRoot, 'warning', errorMessage)
        end
    end
)

function dbBuyBusiness(result, params)
    if not params or not isElement(params.player) then
        return false
    end
    local player = params.player
end

-- function Business.takeMoney(player, businessId)
-- end

-- function Business.sell(player, businessId)
-- end

-- function Business.sellToPlayer(player, businessId)
-- end

-- function Business.changeName(businessId)
-- end