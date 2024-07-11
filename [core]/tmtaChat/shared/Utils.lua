function teaDecodeBinary(data, key)
    return base64Decode(teaDecode(data, key))
end

function teaEncodeBinary(data, key)
    return teaEncode(base64Encode(data), key)
end

function loadFile(path, count)
    if not path then
        return false
    end
    if fileExists(path) then
        local file = fileOpen(path)
        if not count then
            count = fileGetSize(file)
        end
        local data = fileRead(file, count)
        fileClose(file)
        return data
    end
    return false
end

function saveFile(path, data)
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

-- Очискта чата
function clearChat(player)
    player = player or root
    triggerEvent(resName..".clearChat", resourceRoot)
    triggerClientEvent(player, resName..".clearChat", resourceRoot)
end