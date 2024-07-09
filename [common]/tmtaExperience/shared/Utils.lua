Utils = {}

local function getLevelData(level)
    if type(level) ~= 'number' then
        return false
    end
    if not Config.levelsData[tonumber(level)] then
        level = #Config.levelsData
    end
    return Config.levelsData[tonumber(level)]
end

local function levelValid(level)
    if type(level) ~= 'number' then
        return false
    end
    if not Config.levelsData[tonumber(level)] then
        return false
    end
    return true
end

-- Получить опыт для уровня (геометрическая прогрессия)
local function getExpForLevel(level)
    if type(level) ~= 'number' then
        return false
    end
    return exports.tmtaUtils:roundUpHundred(((200*level)^1.38)/10)
end

-- Получить уровень
function Utils.getPlayerLevel(player)
    local player = player or localPlayer
    if not isElement(player) then
        return 0
    end

    local lvl = tonumber(player:getData('lvl')) or 0
    lvl = (math.ceil(lvl) > 0) and math.ceil(lvl) or 1
    return levelValid(lvl) and lvl or #Config.levelsData
end

-- Получить максимальное количество опыта
function Utils.getMaxExperience()
    local maxLevel = #Config.levelsData
    return getExpForLevel(maxLevel)
end

-- Инициализация уровней
function Utils.initializeLevels()
    local ranks = Config.ranks -- таблица рангов и уровней из Config
    if type(ranks) ~= 'table' then
        return false
    end
    local levelsData = {}
    for rank, item in pairs(ranks) do
        for lvl = item.minLvl, item.maxLvl do
            levelsData[lvl] = { 
                rank = rank, 
                exp = getExpForLevel(lvl)
            }
        end
    end
    return levelsData
end

-- Получить звание от уровня
function Utils.getRankFromLevel(level)
    if type(Config.levelsData) ~= 'table' then
        return false
    end
    local levelData = getLevelData(level)
    if not levelData then 
        return false
    end
    return levelData.rank
end

-- Получить необходимый опыт для повышения уровня
function Utils.getExpToLevelUp(level)
    if type(Config.levelsData) ~= 'table' then
        return false
    end
    local levelData = getLevelData(level)
    if not levelData then 
        return false
    end
    return levelData.exp
end