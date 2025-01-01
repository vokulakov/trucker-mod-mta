local objects = {
	[1852] = '2025',
	[1854] = 'christmas_tree',
}

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		for model, fileName in pairs(objects) do
			local txd = engineLoadTXD(string.format('assets/%s.txd', fileName))
			engineImportTXD(txd, model)
			
			local dff = engineLoadDFF(string.format('assets/%s.dff', fileName))
			engineReplaceModel(dff, model)
			
			local dff = engineLoadCOL(string.format('assets/%s.col', fileName))
			engineReplaceCOL(dff, model)
		end
	end
)