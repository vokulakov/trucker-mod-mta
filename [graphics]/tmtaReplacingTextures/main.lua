local textures = {
	{"assets/collisionsmoke.png", "collisionsmoke"},
	{"assets/particleskid.png", "particleskid"},

	{
		"assets/cardebris.png", 
		{ "cardebris_01", "cardebris_02", "cardebris_03", "cardebris_04", "cardebris_05" }
	},

	{"assets/coronastar.png", "coronastar"},
	{"assets/headlight1.png", "headlight1"},
	{"assets/headlight.png", "headlight"},

	{"assets/vehiclelights128.bmp", "vehiclelights128"},
	{"assets/vehiclelightson128.bmp", "vehiclelightson128"},

	{"assets/cloudmasked.png", "smoke"}, -- выкл дым от нитро синий
	{"assets/sphere.png", "sphere"}, -- эффект выстрела
	{"assets/cloudmasked.png", "cloudmasked"}, -- выкл дым от нитро желтый

	-- Билборды
	{ 
		'assets/bilbord.jpg', 
		{ 
			'Victim_bboard', 'heat_04', 'heat_04lod', 'homies_1', 
			'semi3dirty', 'base5_1', 'bobo_3', 'heat_01', 'eris_5', 
			'ads003 copy', 'dirtringtex1_256', 'cokopops_2', 'cokopops_1', 'cokopops_1lod',
			'heat_02', 
		} 
	},

	{ 
		'assets/bilbord_tmta.png', 
		{ 
			'eris_1', 'eris_1lod', 'didersachs01', 'didersachs01lod',
			'eris_2', 'eris_2lod', 
		} 
	},

	{'assets/ru_flag1.png', 'ws_gayflag1'},
	{'assets/ru_flag2.png', 'ws_gayflag2'},
	{'assets/mc_flags1.png', 'mc_flags1'},
	{'assets/sw_flag01.png', 'sw_flag01'},

	{
		'assets/ru_flag3.png', 
		{'dt_cops_us_flag', 'ws_usflagcrumpled', 'starspangban1_256'},
	},

}

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		for i = 1, #textures do
			local shader = exports.tmtaShaders:createShader('texreplace')
			dxSetShaderValue(shader, "TEXTURE_REMAP", dxCreateTexture(textures[i][1]))
			if type(textures[i][2]) == 'table' then
				for _, textureName in pairs(textures[i][2]) do
					engineApplyShaderToWorldTexture(shader, textureName)
				end
			else
				engineApplyShaderToWorldTexture(shader, textures[i][2])
			end
		end
	end
)

addEventHandler('onClientResourceStop', resourceRoot,
	function()
		for _, texture in ipairs(getElementsByType('texture', resourceRoot)) do
			destroyElement(texture)
		end
		for _, shader in ipairs(getElementsByType('shader', resourceRoot)) do
			destroyElement(shader)
		end
	end
)