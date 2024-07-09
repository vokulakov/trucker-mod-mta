--- Выдача игровой валюты
--- Выдача парковочного места
--- Выдача слота для хранения номеров
--- Выдача авто + слота
--- Выдача текстового номера + слот

local function isUserExist(username)
    if (not username or type(username) ~= "string") then
        return false
    end
    return exports.tmtaCore:userExists(username)
end

function giveUserMoney(username, amount)
    if (not username or type(username) ~= "string") then
        return false
    end
end