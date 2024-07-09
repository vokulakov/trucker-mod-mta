local weapons = {
   {fileName="ak47", model=355},{fileName="colt", model=346},
   {fileName="nig", model=334}, {fileName="mp5", model=353}
}
 
function load()
    for index, weapon in pairs(weapons) do
        tex = engineLoadTXD ( "models/weap/"..weapon.fileName.. ".txd", weapon.model )
        engineImportTXD ( tex, weapon.model )
        mod = engineLoadDFF ( "models/weap/"..weapon.fileName.. ".dff", weapon.model )
        engineReplaceModel ( mod, weapon.model )
    end
end
 
addEventHandler("onClientResourceStart",resourceRoot,
function ()
        setTimer ( load, 1000, 1)
end)