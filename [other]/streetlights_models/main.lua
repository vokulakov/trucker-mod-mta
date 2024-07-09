local ModelList = {
	{ path = 'assets/bollardlight.dff', model = 1215 },
	{ path = 'assets/cj_traffic.txd', model = { 1350, 1351, 1352 } },
	{ path = 'assets/cj_traffic_light3.dff', model = 1352 },
	{ path = 'assets/cj_traffic_light4.dff', model = 1350 },
	{ path = 'assets/cj_traffic_light5.dff', model = 1351 },
	{ path = 'assets/docklight.txd', model = 1278 },
	{ path = 'assets/dynsigns.txd', model = { 1223, --[[1226,]] 1231, 1232, --[[1290,]] 1295, 1296, --[[1297,]] 1298 } },
	{ path = 'assets/dyntraffic.txd', model = 1315 },
	--{ path = 'assets/gay_lamppost.dff', model = 3853 },
	{ path = 'assets/gay_traffic_light.dff', model = 3855 },
	{ path = 'assets/gay_xref.txd', model = { --[[3853,]] 3854, 3855 } },
	--{ path = 'assets/lamppost1.dff', model = 1297 },
	--{ path = 'assets/lamppost2.dff', model = 1290 },
	--{ path = 'assets/lamppost3.dff', model = 1226 },
	{ path = 'assets/metal.txd', model = { 1214, 1215, 1300 } },
	{ path = 'assets/mitraffic.txd', model = { 1262, 1263, 1283, 1284 } },
	--{ path = 'assets/mlamppost.dff', model = 1294 },
	{ path = 'assets/MTraffic1.dff', model = 1283 },
	{ path = 'assets/MTraffic2.dff', model = 1284 },
	{ path = 'assets/MTraffic4.dff', model = 1262 },
	{ path = 'assets/Streetlamp1.dff', model = 1232 },
	{ path = 'assets/Streetlamp2.dff', model = 1231 },
	--{ path = 'assets/streetlights.txd', model = 1294 },
	{ path = 'assets/sub_floodlite.dff', model = 1278 },
	{ path = 'assets/trafficlight1.dff', model = 1315 },
	--{ path = 'assets/vegaslampost.dff', model = 3460 },
	--{ path = 'assets/vegaslampost2.dff', model = 3463 },
	{ path = 'assets/vegtrafic2.txd', model = 3516 },
	{ path = 'assets/vgnlpost.txd', model = { --[[3460, 3463,]] 3472 } },
	{ path = 'assets/vgsstriptlights1.dff', model = 3516 },
}

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		for _, data in pairs(ModelList) do
			if pregFind(data.path, "txd") then
				local txd = engineLoadTXD(data.path)
				if type(data.model) == 'table' then
					for _, model in pairs(data.model) do
						engineImportTXD(txd, model)
					end
				else
					engineImportTXD(txd, data.model)
				end
			end 
			if pregFind(data.path, "dff") then
				local dff = engineLoadDFF(data.path)
				engineReplaceModel(dff, data.model)
			end
		end
	end
)
