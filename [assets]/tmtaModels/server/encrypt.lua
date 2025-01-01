local encryptedFiles = {}

local function saveFile(path, data)
    if not path then
        return false
    end
    if fileExists(path) then
        fileDelete(path)
    end
    local file = fileCreate(path)
    fileWrite(file, data)
    fileClose(file)
    return true
end

local MAX_FILE_LEN = 4 * 1024 * 1024

local function loadFile(path)
    if not fileExists(path) then
        return false
    end
    local file = fileOpen(path)
    if not file then
        return false
    end
    local data = fileRead(file, fileGetSize(file))
    fileClose(file)
    return data
end

local function randomBytes(count, seed)
    if seed then
        math.randomseed(seed)
    end
    local str = ""
    for i = 1, count do
        str = str .. string.char(math.random(0, 255))
    end
    return str
end

addCommandHandler("encmod", 
    function(player)
        if not exports.tmtaUtils:isPlayerAdmin(player) then
            outputDebugString('No access permission', 1)
            return false
        end

        local paths = {}
        local filenum = 1
        local fname = string.sub(string.lower(md5("idk"..filenum)), 1, 6) .. ".tmta"
        local file = fileCreate("data/"..fname)
        local randomHeader = randomBytes(8, getTickCount()) .. "TRUCKER_MTA_ASSET" .. randomBytes(math.random(1024 * 4, 1024 * 8), getTickCount())
        file:write(randomHeader)
        local currentLen = #randomHeader

        local function addFile(path, model)
            if not fileExists(path) then
                return
            end
            local fileData = loadFile(path)
            file:write(fileData)
            paths[path] = { filename = fname, pos = currentLen, len = #fileData }
            currentLen = currentLen + #fileData

            if currentLen > MAX_FILE_LEN then
                file:close()
                filenum = filenum + 1
                fname = string.sub(string.lower(md5("idk"..filenum)), 1, 6) .. ".tmta"
                file = fileCreate("data/"..fname)
                local randomHeader = randomBytes(8, getTickCount()) .. "TRUCKER_MTA_ASSET" .. randomBytes(math.random(1024 * 4, 1024 * 8), getTickCount())
                file:write(randomHeader)
                currentLen = #randomHeader
            end
        end
        for name, model in pairs(ReplacedModels) do
            addFile("assets/"..name..".txd", model)
            addFile("assets/"..name..".dff", model)
            addFile("assets/"..name..".col", model)
        end
        file:close()

        saveFile("client/paths.lua", "ModelPaths = "..pprint.pformat(paths))

        -- Meta
        local _metaData = ""
        local _filenames = {}
        for _, data in pairs(paths) do
            if not _filenames[data.filename] then
                _metaData = _metaData .. string.format('\n<file src="data/%s" />', data.filename)
                _filenames[data.filename] = true
            end
        end
        saveFile("client/metaTemplate.xml", _metaData)

        outputDebugString("Encrypt done")
    end
)
