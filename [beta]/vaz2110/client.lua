function replaceModel()
txd = engineLoadTXD('car.txd', 439)
engineImportTXD(txd, 439)
dff = engineLoadDFF('car.dff', 439)
engineReplaceModel(dff, 439)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )