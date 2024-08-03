addEventHandler('onClientResourceStart', resourceRoot,
function()

---salon
local txd = engineLoadTXD('assets/objects/int_carshop.txd',true)
engineImportTXD(txd, 3900)
local dff = engineLoadDFF('assets/objects/int_carshop.dff', 0)
engineReplaceModel(dff, 3900)
engineSetModelLODDistance(3900, 50)
local col = engineLoadCOL('assets/objects/int_carshop.col')
engineReplaceCOL(col, 3900)

--[[
---buy int
local txd = engineLoadTXD('files/intby.txd',true)
engineImportTXD(txd, 3902)
local dff = engineLoadDFF('files/intby.dff', 0)
engineReplaceModel(dff, 3902)
engineSetModelLODDistance(3902, 50)
local col = engineLoadCOL('files/intby.col')
engineReplaceCOL(col, 3902)
]]
end)


