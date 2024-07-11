AntiSpam = {}

local regularPatterns = {
    "([0-9]{1,3}[\.]){3}[0-9]{1,3}", -- ip адреса
}

function AntiSpam.onMessage(message)
    for _, pattern in ipairs(regularPatterns) do
        if pregFind(message, pattern) then 
            return true
        end
    end
    return false
end
