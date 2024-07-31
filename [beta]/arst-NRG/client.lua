local MODEL = 522

function replaceModel()
	setTimer(
		function()
			local txd = engineLoadTXD("car.txd", MODEL)
			engineImportTXD(txd, MODEL)
			local dff = engineLoadDFF("car.dff", MODEL)
			engineReplaceModel(dff, MODEL)
		end, 2000, 1
	)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)
