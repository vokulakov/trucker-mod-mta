-- @see https://forum.multitheftauto.com/topic/143108-rel-protection-from-trigger-ddos/

local ServerCalls

ServerCalls = {
    interval = 1000,
    maxCallsPerInterval = 20,
    time = 0,
    calls = 0,

    refresh = function(self)
        if self.time < getTickCount() then
            self.time = getTickCount() + self.interval
            self.calls = 0
        end
    end,

    add = function(self)
        self:refresh();
        self.calls = self.calls + 1
    end,
}

ServerCalls.__index = ServerCalls

addDebugHook("preFunction", 
    function()
        ServerCalls:add()

        if ServerCalls.calls >= ServerCalls.maxCallsPerInterval and not ServerCalls.makeLastCall then
            triggerServerEvent("tmtaAntiCheat.banPlayer", resourceRoot, 'Trigger spam detected')
            
            ServerCalls.makeLastCall = true
        end

        return ServerCalls.makeLastCall and "skip" or true
    end, {"triggerServerEvent"})